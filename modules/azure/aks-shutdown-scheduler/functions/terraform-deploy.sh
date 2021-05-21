#!/bin/bash
cp ./* ../tmp/functions
set -e
cp -r ./ShutdownAKS ../tmp/functions
cd ../tmp/functions
npm install
npm run build
npm prune --production
cd ..
zip -r functions.zip ./functions/
rm -rf ./functions