data "aws_subnet" "subnet1" {
  filter {
    name = "tag:Name"
    values = [
      "subnet-${var.environment}-${var.locationShort}-${var.coreInfraCommonName}-${var.commonName}1"
    ]
  }
}

data "aws_subnet" "subnet2" {
  filter {
    name = "tag:Name"
    values = [
      "subnet-${var.environment}-${var.locationShort}-${var.coreInfraCommonName}-${var.commonName}2"
    ]
  }
}

data "aws_subnet" "subnet3" {
  filter {
    name = "tag:Name"
    values = [
      "subnet-${var.environment}-${var.locationShort}-${var.coreInfraCommonName}-${var.commonName}3"
    ]
  }
}
