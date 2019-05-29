#!/bin/bash

# Exit upon encountering an error
set -euo pipefail

# Set the base route
ROOT_DIR=$(pwd)

# Run the script to set up the env variables and other custom functions
source $ROOT_DIR/utils.sh

activateServiceAccount() {
    # Get the env variables
    require PROJECT_ID $PROJECT_ID
    require GCLOUD_SERVICE_KEY $GCLOUD_SERVICE_KEY

    # Authenticate to GCP using the Service account Key
    info "Activate Google Service Account"
    gcloud auth activate-service-account --key-file $GCLOUD_SERVICE_KEY
    gcloud --quiet config set project ${PROJECT_ID}
}

setupLifecyclePolicy(){
    # Get the env variables
    require BUCKET_NAME $BUCKET_NAME
    require AGE_MIN_LIMIT $AGE_MIN_LIMIT
    require AGE_MAX_LIMIT $AGE_MAX_LIMIT
    require DEF_STORAGE_CLASS $DEF_STORAGE_CLASS

    # List all the objects in the bucket
    info "List the files within the bucket"
    gsutil ls -l gs://${BUCKET_NAME}

    # Set a default storage class for that bucket
    info "Set default bucket storage class"
    gsutil defstorageclass set ${DEF_STORAGE_CLASS} gs://${BUCKET_NAME}
    
    # Update the age condition in the policy with the appropriate values
    info "Add an age limit to be used in the condition"
    sed -i '' 's/"AGE_MAX"/'"${AGE_MAX_LIMIT}"'/' ./lifecycle-policy.json
    sed -i '' 's/"AGE_MIN"/'"${AGE_MIN_LIMIT}"'/' ./lifecycle-policy.json

    # Apply the policy to the bucket
    info "Enable the policy"
    gsutil lifecycle set lifecycle-policy.json gs://${BUCKET_NAME}

    # Check if the policy is enabled
    info "Check if the policy was enabled"
    gsutil lifecycle get gs://${BUCKET_NAME}

    # Restore the policy file to it's original state
    info "Restore JSON file conditions"
    sed -i '' 's/'"${AGE_MAX_LIMIT}"'/"AGE_MAX"/' ./lifecycle-policy.json
    sed -i '' 's/'"${AGE_MIN_LIMIT}"'/"AGE_MIN"/' ./lifecycle-policy.json

}

main(){
    activateServiceAccount
    setupLifecyclePolicy
}

main
