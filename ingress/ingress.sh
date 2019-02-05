#!/usr/bin/env bash

ingressMandatoryCommands() {
  kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $(gcloud config get-value account)
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml
}

replaceIp() {
  cp nginx.service.yml.tpl nginx.service.yml
  sed -i -e "s/{{ STATIC_IP }}/$IP/" nginx.service.yml
  kubectl apply -f nginx.service.yml
}

main() {
  ingressMandatoryCommands
  replaceIp
}

main
