#!/usr/bin/env bash
set -eo pipefail

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

base64Encode () {
    if [ -n "${3}" ]; then
      echo -n "$3" | base64 $1 $2
    elif [ -n "${1}" ]; then
      echo -n "$1" | base64
    fi
}

# specify required variables
VARIABLES=(
  'ENVIRONMENT' 'NAMESPACE' 'PROJECT_NAME' 'DOCKER_REGISTRY'
  'PROJECT_ID' 'TARGET_CPU_UTILIZATION' 'MAXIMUM_REPLICAS'
  'MINIMUM_REPLICAS' 'PORT' 'IMAGE_TAG' 'STATIC_IP'
  'DB_INSTANCE_CONNECTION_NAME' 'SQL_SERVICE_ACCOUNT'
  'SSL_CERTIFICATE' 'SSL_PRIVATE_KEY' 'JWT_PUBLIC_KEY' 'DATABASE_URL'
  'DEFAULT_ADMIN' 'REDIRECT_URL' 'BUGSNAG_API_KEY' 'MAILGUN_API_KEY'
  'MAILGUN_DOMAIN_NAME' 'MAIL_SENDER' 'CLOUDINARY_CLOUD_NAME'
  'CLOUDINARY_API_KEY' 'CLOUDINARY_API_SECRET' 'CLOUDINARY_ENHANCE_IMAGE'
  'CLOUDINARY_STATIC_IMAGE' 'TRAVEL_READINESS_MAIL_CYCLE'
  'SURVEY_URL' 'ANDELA_PROD_API' 'BAMBOOHR_API' 'LASTCHANGED_BAMBOO_API' 
  'BAMBOOHRID_API' 'OCRSOLUTION' 'CRASH_REPORTING_CHANNEL' 'SECRET_KEY'
  'DB_URL' 'APP_SETTINGS'
  )

# Set default values
TARGET_CPU_UTILIZATION=${TARGET_CPU_UTILIZATION:-75}
MINIMUM_REPLICAS=${MINIMUM_REPLICAS:-2}
MAXIMUM_REPLICAS=${MAXIMUM_REPLICAS:-5}
DOCKER_REGISTRY=${DOCKER_REGISTRY:-gcr.io}
PORT=${PORT:-5000}

require VARIABLES $VARIABLES
require NAMESPACE $NAMESPACE
require ENVIRONMENT $ENVIRONMENT
require PORT $PORT
require IMAGE_TAG $IMAGE_TAG
require STATIC_IP $STATIC_IP
require DOCKER_REGISTRY $DOCKER_REGISTRY
require PROJECT_NAME $PROJECT_NAME
require PROJECT_ID $PROJECT_ID
require TARGET_CPU_UTILIZATION $TARGET_CPU_UTILIZATION
require MAXIMUM_REPLICAS $MAXIMUM_REPLICAS
require MINIMUM_REPLICAS $MINIMUM_REPLICAS
require SSL_BUCKET_NAME $SSL_BUCKET_NAME
require SQL_SERVICE_ACCOUNT $SQL_SERVICE_ACCOUNT

if [ `uname` == 'Linux' ]; then
    BASE_64_ARGS='-w 0'
fi

# base64 environment variables
SSL_PRIVATE_KEY=$(gsutil cat gs://${SSL_BUCKET_NAME}/ssl/andela_key.key | base64 $BASE_64_ARGS)
SSL_CERTIFICATE=$(gsutil cat gs://${SSL_BUCKET_NAME}/ssl/andela_certificate.pem | base64 $BASE_64_ARGS)
JWT_PUBLIC_KEY=$(base64Encode $BASE_64_ARGS ${JWT_PUBLIC_KEY-default})
DATABASE_URL=$(base64Encode $BASE_64_ARGS ${DATABASE_URL-default})
DEFAULT_ADMIN=$(base64Encode $BASE_64_ARGS ${DEFAULT_ADMIN-default})
REDIRECT_URL=$(base64Encode $BASE_64_ARGS ${REDIRECT_URL-default})
BUGSNAG_API_KEY=$(base64Encode $BASE_64_ARGS ${BUGSNAG_API_KEY-default})
MAILGUN_API_KEY=$(base64Encode $BASE_64_ARGS ${MAILGUN_API_KEY-default})
MAILGUN_DOMAIN_NAME=$(base64Encode $BASE_64_ARGS ${MAILGUN_DOMAIN_NAME-default})
MAIL_SENDER=$(base64Encode $BASE_64_ARGS ${MAIL_SENDER-default})
CLOUDINARY_CLOUD_NAME=$(base64Encode $BASE_64_ARGS ${CLOUDINARY_CLOUD_NAME-default})
CLOUDINARY_API_KEY=$(base64Encode $BASE_64_ARGS ${CLOUDINARY_API_KEY-default})
CLOUDINARY_API_SECRET=$(base64Encode $BASE_64_ARGS ${CLOUDINARY_API_SECRET-default})
CLOUDINARY_ENHANCE_IMAGE=$(base64Encode $BASE_64_ARGS ${CLOUDINARY_ENHANCE_IMAGE-default})
CLOUDINARY_STATIC_IMAGE=$(base64Encode $BASE_64_ARGS ${CLOUDINARY_STATIC_IMAGE-default})
TRAVEL_READINESS_MAIL_CYCLE=$(base64Encode $BASE_64_ARGS "${TRAVEL_READINESS_MAIL_CYCLE-default}")
SURVEY_URL=$(base64Encode $BASE_64_ARGS ${SURVEY_URL-default})
ANDELA_PROD_API=$(base64Encode $BASE_64_ARGS "${ANDELA_PROD_API-default}")
BAMBOOHR_API=$(base64Encode $BASE_64_ARGS "${BAMBOOHR_API-default}")
LASTCHANGED_BAMBOO_API=$(base64Encode $BASE_64_ARGS "${LASTCHANGED_BAMBOO_API-default}")
BAMBOOHRID_API=$(base64Encode $BASE_64_ARGS "${BAMBOOHRID_API-default}")
OCRSOLUTION=$(base64Encode $BASE_64_ARGS "${OCRSOLUTION-default}")
CRASH_REPORTING_CHANNEL=$(base64Encode $BASE_64_ARGS "${CRASH_REPORTING_CHANNEL-default}")
SECRET_KEY=$(base64Encode $BASE_64_ARGS "${SECRET_KEY-default}")
DB_URL=$(base64Encode $BASE_64_ARGS "${DB_URL-default}")
APP_SETTINGS=$(base64Encode $BASE_64_ARGS "${APP_SETTINGS-default}")


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
  projectNameRegex="${PROJECT_NAME}.+"
  namespaceRegex="travela-${ENVIRONMENT}.+"
  tlsSecretRegex="travela-tls.+"
  generalRegex="travela\..+"
  nginxRegex="nginx+"

  for file in ${TEMPLATES[@]}; do
    if [[ $file =~ $projectNameRegex ]] \
    || [[ $file =~ $namespaceRegex ]] \
    || [[ $file =~ $generalRegex ]] \
    || [[ $file =~ $tlsSecretRegex ]] \
    || [[ $file =~ $nginxRegex ]]
    then
      local output=${file%.tpl}
      cp $file $output
      info "Building $(basename $file) template to $(basename $output)"
      for variable in ${VARIABLES[@]}; do
        local value=${!variable-default}
        sed -i -e "s#{{ $variable }}#$value#" $output;
        sed -i -e "s#{{ $variable }}#$value#" $output;
      done

      if [[ $? == 0 ]]; then
          success "Template file $(basename $file) has been successfuly built to $(basename $output)"
        else
          error "Failed to build template $(basename $file)"
      fi
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
