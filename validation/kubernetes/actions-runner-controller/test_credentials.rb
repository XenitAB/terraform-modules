require 'fileutils'
require 'json'
require 'open3'
require 'tmpdir'
require 'yaml'

ROOT = File.expand_path(__dir__)
MODULE = File.expand_path('../../../modules/kubernetes/actions-runner-controller', ROOT)
SANDBOX = File.join(ROOT, '.terraform', 'arc-credentials-regression')
REMOTE = 'https://remote-workload.invalid:6443'
MANAGEMENT_NAMESPACE = 'fixture-test'
CHART = 'platform/fixture/remote-test-aks1/argocd-applications/actions-runner-controller'
IDENTITIES = [
  ['Namespace', nil, 'arc-runners'],
  ['ServiceAccount', 'arc-runners', 'external-secrets'],
  ['SecretStore', 'arc-runners', 'azure-kv'],
  ['ExternalSecret', 'arc-runners', 'arc-github-app']
].freeze

def check(condition, message)
  raise message unless condition
end

def execute(*command)
  output, result = Open3.capture2e(*command)
  check(result.success?, "#{command.join(' ')} failed:\n#{output}")
  output
end

def documents(content)
  YAML.load_stream(content).compact
end

def application(content)
  parsed = documents(content)
  check(parsed.length == 1 && parsed.first['kind'] == 'Application', 'Expected one Application')
  parsed.first
end

def file_for(resources, name, required = true)
  matches = resources.select { |resource| resource['address'] == "git_repository_file.#{name}" || resource['address'] == "git_repository_file.#{name}[0]" }
  check(matches.length == (required ? 1 : 0), "Unexpected count/address for #{name}: #{matches.length}")
  matches.first && matches.first.fetch('values')
end

def credentials(resources, phase)
  identities = resources.map { |resource| [resource['kind'], resource.dig('metadata', 'namespace'), resource.dig('metadata', 'name')] }
  check(identities.sort_by(&:to_s) == IDENTITIES.sort_by(&:to_s), "#{phase}: credential resource identities changed")
  resources.each do |resource|
    options = resource.dig('metadata', 'annotations', 'argocd.argoproj.io/sync-options').to_s.split(',').map(&:strip)
    check(options.include?('Prune=false') == (phase != 'managed'), "#{phase}: wrong prune protection on #{resource['kind']}")
    check(!options.include?('Replace=true'), "#{phase}: destructive credentials sync option")
  end
  external = resources.find { |resource| resource['kind'] == 'ExternalSecret' }
  check(external.dig('spec', 'target', 'name') == 'arc-github-app', "#{phase}: wrong target Secret")
  check(external.dig('spec', 'target', 'template', 'data') == {
    'github_app_id' => '12345', 'github_app_installation_id' => '67890', 'github_app_private_key' => '{{ .privateKey }}'
  }, "#{phase}: ESO template must contain identifiers and the plain privateKey expression only")
  check(external.dig('spec', 'data') == [{ 'secretKey' => 'privateKey', 'remoteRef' => { 'key' => 'github-arc-private-key' } }], "#{phase}: wrong private key reference")
  check(external.dig('spec', 'secretStoreRef') == { 'kind' => 'SecretStore', 'name' => 'azure-kv' }, "#{phase}: wrong SecretStore reference")
  store = resources.find { |resource| resource['kind'] == 'SecretStore' }
  provider = store.fetch('spec').fetch('provider').fetch('azurekv')
  check(provider['authType'] == 'WorkloadIdentity' && provider['serviceAccountRef'] == { 'name' => 'external-secrets' }, "#{phase}: wrong ESO identity")
  check(provider['vaultUrl'] == 'https://kv-test.vault.azure.net', "#{phase}: wrong vault")
  account = resources.find { |resource| resource['kind'] == 'ServiceAccount' }
  check(account.dig('metadata', 'annotations', 'azure.workload.identity/client-id') == '11111111-1111-1111-1111-111111111111', "#{phase}: wrong generated client ID")
end

FileUtils.mkdir_p(File.join(SANDBOX, 'tests'))
Dir.glob(File.join(SANDBOX, '*.tf')).each { |path| FileUtils.rm_f(path) }
FileUtils.rm_rf(File.join(SANDBOX, 'templates'))
FileUtils.cp(Dir.glob(File.join(MODULE, '*.tf')), SANDBOX)
FileUtils.cp_r(File.join(MODULE, 'templates'), SANDBOX)
FileUtils.cp(File.join(ROOT, 'credentials.tftest.hcl'), File.join(SANDBOX, 'tests'))
unless File.directory?(File.join(SANDBOX, '.terraform', 'providers')) && File.file?(File.join(SANDBOX, '.terraform.lock.hcl')) && ENV['ARC_TEST_INIT'] != '1'
  puts execute('tofu', "-chdir=#{SANDBOX}", 'init', '-backend=false', '-input=false', '-no-color')
end
output, result = Open3.capture2e('tofu', "-chdir=#{SANDBOX}", 'test', '-json', '-verbose', '-no-color')
events = output.lines.map { |line| JSON.parse(line) rescue nil }.compact
plans = events.select { |event| event['type'] == 'test_plan' }.to_h do |event|
  [event.fetch('@testrun'), event.fetch('test_plan')]
end
check(!plans.empty?, "No module plans exported:\n#{output}")
failures = []
controllers = []
%w[controller_only protect handoff managed default_managed].each do |run|
  begin
    phase = run == 'default_managed' ? 'managed' : run
    plan = plans.fetch(run)
    resources = plan.fetch('planned_values').fetch('root_module').fetch('resources')
    files = resources.select { |resource| resource['type'] == 'git_repository_file' }
    expected_names = %w[arc_chart arc_values arc_app arc_controller]
    expected_names += %w[arc_runner_set arc_external_secret] unless phase == 'controller_only'
    expected_names << 'arc_credentials' if %w[handoff managed].include?(phase)
    check(files.map { |resource| resource['name'] }.sort == expected_names.sort, "#{run}: unexpected Git files")
    parent = application(file_for(files, 'arc_app').fetch('content'))
    check(parent.dig('spec', 'destination') == { 'server' => 'https://kubernetes.default.svc', 'namespace' => MANAGEMENT_NAMESPACE }, "#{run}: parent must target management cluster")
    check(parent.dig('spec', 'source', 'path') == CHART, "#{run}: wrong parent source path")
    controller_content = file_for(files, 'arc_controller').fetch('content')
    controllers << controller_content
    controller = application(controller_content)
    check(controller.dig('spec', 'destination') == { 'server' => REMOTE, 'namespace' => 'arc-system' }, "#{run}: wrong controller target")
    Dir.mktmpdir('arc-generated-') do |directory|
      files.each do |resource|
        values = resource.fetch('values')
        path = File.expand_path(values.fetch('path'), directory)
        check(path.start_with?(directory + '/'), "#{run}: generated path outside fixture")
        content = values.fetch('content')
        check(!content.match?(/-----BEGIN .*PRIVATE KEY-----/), "#{run}: inline private key")
        check(documents(content).none? { |document| document['kind'] == 'Secret' }, "#{run}: inline Kubernetes Secret")
        FileUtils.mkdir_p(File.dirname(path))
        File.write(path, content)
      end
      rendered = documents(execute('helm', 'template', 'arc-test', File.join(directory, CHART)))
      expected_apps = phase == 'controller_only' ? 1 : (phase == 'protect' ? 2 : 3)
      apps = rendered.select { |document| document['kind'] == 'Application' }
      check(apps.length == expected_apps, "#{run}: wrong parent Application count")
      check(apps.all? { |app| app.dig('metadata', 'namespace') == MANAGEMENT_NAMESPACE }, "#{run}: wrong Application management namespace")
      check(rendered.length == expected_apps + (phase == 'protect' ? 4 : 0), "#{run}: parent Helm leaked raw credentials")
      if phase == 'controller_only'
        file_for(files, 'arc_external_secret', false)
        file_for(files, 'arc_credentials', false)
        next
      end
      runner = application(file_for(files, 'arc_runner_set').fetch('content'))
      check(runner.dig('spec', 'destination') == { 'server' => REMOTE, 'namespace' => 'arc-runners' }, "#{run}: wrong runner target")
      policy = runner.fetch('spec').fetch('syncPolicy')
      check(!policy.key?('managedNamespaceMetadata') && !policy.fetch('syncOptions', []).include?('CreateNamespace=true'), "#{run}: runner still owns namespace")
      check(runner.dig('spec', 'source', 'helm', 'valuesObject', 'githubConfigSecret') == 'arc-github-app', "#{run}: runner must reference ESO Secret")
      external = file_for(files, 'arc_external_secret')
      expected_path = phase == 'protect' ? "#{CHART}/templates/external-secret-arc.yaml" : "#{CHART}/manifests/credentials/external-secret-arc.yaml"
      check(external.fetch('path') == expected_path, "#{run}: wrong generated credentials path")
      if phase == 'protect'
        file_for(files, 'arc_credentials', false)
        check(external.fetch('content').include?('{{`{{ .privateKey }}`}}'), 'protect: missing Helm escape')
        credentials(rendered.reject { |document| document['kind'] == 'Application' }, phase)
      else
        credentials(documents(external.fetch('content')), phase)
        child_file = file_for(files, 'arc_credentials')
        check(child_file.fetch('path') == "#{CHART}/templates/arc-credentials.yaml", "#{run}: wrong child path")
        child = application(child_file.fetch('content'))
        check(child.dig('metadata', 'namespace') == MANAGEMENT_NAMESPACE, "#{run}: wrong child management namespace")
        check(child.dig('spec', 'destination') == { 'server' => REMOTE, 'namespace' => 'arc-runners' }, "#{run}: wrong credentials target")
        check(child.dig('spec', 'source', 'path') == "#{CHART}/manifests/credentials", "#{run}: wrong raw source path")
        check(child.dig('spec', 'source', 'repoURL') == 'https://git.invalid/fleet.git', "#{run}: wrong source repository")
        check(!child.fetch('spec').fetch('source').key?('helm'), "#{run}: credentials must not pass through Helm again")
        child_policy = child.fetch('spec').fetch('syncPolicy', {})
        check(!child_policy.fetch('syncOptions', []).include?('Replace=true'), "#{run}: credentials child uses Replace=true")
        if phase == 'handoff'
          check(!child_policy.key?('automated'), 'handoff: credentials must require manual sync')
        else
          check(child_policy.dig('automated', 'prune') == true && child_policy.dig('automated', 'selfHeal') == true, "#{run}: missing managed automation")
        end
      end
    end
    puts "PASS #{run}: module Git output and Helm rendering"
  rescue StandardError => error
    failures << "#{run}: #{error.message}"
  end
end
failures << 'Controller output changes between phases' unless controllers.uniq.length == 1
unless result.success?
  diagnostics = events.select { |event| event['type'] == 'diagnostic' }.map { |event| event['@message'] }
  failures << "OpenTofu tests failed (including invalid phase rejection):\n#{diagnostics.join("\n")}"
end
check(failures.empty?, failures.join("\n"))
puts 'PASS invalid_phase: rejected by module variable validation'
puts 'PASS credentials migration regression suite (plan-only mocks; no apply)'