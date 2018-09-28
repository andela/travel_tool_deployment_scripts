#!/usr/bin/env bash

DIR=$(pwd)

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
    printf "\n${BOLD}${RED}====> $(echo $@ )  ${NC}\n"; exit 1
}

success () {
    printf "\n${BOLD}${GREEN}====> $(echo $@ ) ${NC}\n"
}

is_success_or_fail() {
    if [ "$?" == "0" ]; then success $@; else error $@; fi
}

is_success() {
    if [ "$?" == "0" ]; then success $@; fi
}

# require "variable name" "value"
require () {
    if [ -z ${2+x} ]; then error "Required variable ${1} has not been set"; fi
}

if [ -f $DIR/bin/sample.envs ]; then
   source $DIR/bin/sample.envs
fi


SERVICE_KEY_PATH=$HOME/service-account-key.json
IMAGE_TAG=$(git rev-parse --short HEAD)
PROJECT_ID=apprenticeship-projects
# assert required variables

require PRODUCTION_COMPUTE_ZONE $PRODUCTION_COMPUTE_ZONE
require STAGING_COMPUTE_ZONE $STAGING_COMPUTE_ZONE
require PRODUCTION_STATIC_IP $PRODUCTION_STATIC_IP
require STAGING_STATIC_IP $STAGING_STATIC_IP
require PRODUCTION_CLUSTER_NAME $PRODUCTION_CLUSTER_NAME
require STAGING_CLUSTER_NAME $STAGING_CLUSTER_NAME
require PRODUCTION_DATABASE_URL $PRODUCTION_DATABASE_URL
require STAGING_DATABASE_URL $STAGING_DATABASE_URL
require STAGING_JWT_PUBLIC_KEY $STAGING_JWT_PUBLIC_KEY
require PRODUCTION_JWT_PUBLIC_KEY $PRODUCTION_JWT_PUBLIC_KEY

if [ "$CIRCLE_BRANCH" == 'master' ]; then
    export ENVIRONMENT=production
    export COMPUTE_ZONE=$PRODUCTION_COMPUTE_ZONE
    export CLUSTER_NAME=$PRODUCTION_CLUSTER_NAME
    export STATIC_IP=$PRODUCTION_STATIC_IP
    export DATABASE_URL=$PRODUCTION_DATABASE_URL
    export JWT_PUBLIC_KEY=$PRODUCTION_JWT_PUBLIC_KEY
else
    export ENVIRONMENT=staging
    export COMPUTE_ZONE=$STAGING_COMPUTE_ZONE
    export CLUSTER_NAME=$STAGING_CLUSTER_NAME
    export STATIC_IP=$STAGING_STATIC_IP
    export DATABASE_URL=$STAGING_DATABASE_URL
    export JWT_PUBLIC_KEY=$STAGING_JWT_PUBLIC_KEY
fi

export NAMESPACE=$ENVIRONMENT
