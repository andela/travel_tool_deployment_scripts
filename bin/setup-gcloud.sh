#!/usr/bin/env bash
ROOT_DIR=$(pwd)

source $ROOT_DIR/bin/utils.sh

installGoogleCloudSdk(){
    info "Installing google cloud sdk"
    echo "deb http://packages.cloud.google.com/apt cloud-sdk-jessie main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    sudo apt-get update && sudo apt-get install kubectl google-cloud-sdk
    info "Gcloud and Kubectl has been installed successfully"
}

activateServiceAccount() {
    require PROJECT_ID $PROJECT_ID
    require COMPUTE_ZONE $COMPUTE_ZONE
    require CLUSTER_NAME $CLUSTER_NAME
    require GCLOUD_SERVICE_KEY $GCLOUD_SERVICE_KEY

    info "Activate Google Service Account"

    echo $GCLOUD_SERVICE_KEY | base64 --decode > $SERVICE_KEY_PATH
    # setup kubectl auth
    gcloud auth activate-service-account --key-file $SERVICE_KEY_PATH
    gcloud --quiet config set project ${PROJECT_ID}
    gcloud --quiet config set compute/zone ${COMPUTE_ZONE}
    gcloud --quiet container clusters get-credentials ${CLUSTER_NAME}
}

main(){
    installGoogleCloudSdk
    activateServiceAccount
}

$@
