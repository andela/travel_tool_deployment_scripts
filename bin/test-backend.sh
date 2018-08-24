#!/usr/bin/env bash

PROJECT_NAME=travella-backend

source bin/utils.sh
source deploy/template.sh

build(){
  info " find and list all template files in deploy folder"

  findTempateFiles 'TEMPLATES'

  # Ensure that TEMPLATES variable has been set
  require TEMPLATES $TEMPLATES

  # build templates into config files
  findAndReplaceVariables
}
# lint files
lint(){
  info "Linting configuration files for $PROJECT_NAME $NAMESPACE environment"

  k8s-lint -f deploy/${PROJECT_NAME}.config

  cleanGeneratedYamlFiles
}

deploy(){
  k8s-deploy-and-verify -f deploy/${PROJECT_NAME}.config
}

$@
