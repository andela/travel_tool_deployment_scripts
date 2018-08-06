#!/usr/bin/env bash
set -e
DIRECTORY="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
ROOT_DIRECTORY=$(dirname $DIRECTORY)

BOLD='\e[1m'
BLUE='\e[34m'
RED='\e[31m'
YELLOW='\e[33m'
GREEN='\e[92m'
NC='\e[0m'

info() {
    printf "\n${BOLD}${BLUE}====> $(echo $@ ) ${NC}\n"
}

warning () {
    printf "\n${BOLD}${YELLOW}====> $(echo $@ )  ${NC}\n"
}

error() {
    printf "\n${BOLD}${RED}====> $(echo $@ )  ${NC}\n"
    exit 1
}

success () {
    printf "\n${BOLD}${GREEN}====> $(echo $@ ) ${NC}\n"
}

# require "variable name" "value"
require () {
    if [ -z ${2+x} ]; then error "Required variable ${1} has not been set"; fi
}

# specify required variables
VARIABLES=(
  'NAMESPACE' 'PROJECT_NAME' 'DOCKER_REGISTRY'
  'PROJECT_ID' 'TARGET_CPU_UTILIZATION' 'MAXIMUM_REPLICAS' 'MINIMUM_REPLICAS' 'PORT'
  )

# Set default values
TARGET_CPU_UTILIZATION=${TARGET_CPU_UTILIZATION:-75}
MINIMUM_REPLICAS=${MINIMUM_REPLICAS:-2}
MAXIMUM_REPLICAS=${MAXIMUM_REPLICAS:-5}
DOCKER_REGISTRY=${DOCKER_REGISTRY:-gcr.io}
PORT=${PORT:-5000}

require VARIABLES $VARIABLES
require NAMESPACE $NAMESPACE
require PORT $PORT
require DOCKER_REGISTRY $DOCKER_REGISTRY
require PROJECT_NAME $PROJECT_NAME
require PROJECT_ID $PROJECT_ID
require TARGET_CPU_UTILIZATION $TARGET_CPU_UTILIZATION
require MAXIMUM_REPLICAS $MAXIMUM_REPLICAS
require MINIMUM_REPLICAS $MINIMUM_REPLICAS

findTempateFiles() {
  local _yamlFilesVariable=$1
  local _templates=$(find $ROOT_DIRECTORY/deploy -name "*.tpl" -type f)
  if [ "$_yamlFilesVariable" ]; then
      eval $_yamlFilesVariable="'$_templates'"
    else
      echo $_templates;
  fi
}

findAndReplaceVariables() {
  for file in ${TEMPLATES[@]}; do
    local output=${file%.tpl}
    cp $file $output
    info "Building $(basename $file) template to $(basename $output)"
    for variable in ${VARIABLES[@]}; do
      local value=${!variable}
      sed -i -e "s/{{ $variable }}/$value/g" $output;
      sed -i -e "s/{{$variable}}/$value/g" $output;
    done

    if [[ $? == 0 ]]; then
        success "Template file $(basename $file) has been successfuly built to $(basename $output)"
      else
        error "Failed to build template $(basename $file)"
    fi
  done

  info "Cleaning backup files after substitution"
  rm -rf deploy/*-e
}

cleanGeneratedYamlFiles() {
  info "Removing generated all generated config files"
  rm -rf deploy/*.yml
  rm -rf deploy/*.config
}

# findTempateFiles 'TEMPLATES'
# findAndReplaceVariables
# cleanGeneratedYamlFiles
