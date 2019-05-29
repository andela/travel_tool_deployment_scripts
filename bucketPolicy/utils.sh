#!/bin/bash

# Exit upon encountering an error
set -euo pipefail

# Set some enviroment configurations
BOLD='\e[1m'
BLUE='\e[34m'
NC='\e[0m'


info() {
    # Display output in this format
    printf "\n${BOLD}${BLUE}====> $(echo $@ ) ${NC}\n"
}

# require "variable name" "value"
require () {
    if [ -z ${2+x} ]; then error "Required variable ${1} has not been set"; fi
}

source .env
