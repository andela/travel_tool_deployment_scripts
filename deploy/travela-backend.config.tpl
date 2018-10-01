# Configuration for https://github.com/reactiveops/rok8s-scripts

# External registry domain
EXTERNAL_REGISTRY_BASE_DOMAIN={{ DOCKER_REGISTRY }}/{{ PROJECT_ID }}

# Name of repository/project
REPOSITORY_NAME={{ PROJECT_NAME }}

# Docker tag that will be created
# Defaults to concatenation of your external registry + repository name, i.e.:
# DOCKERTAG=quay.io/example-org/example-app
DOCKERTAG="${EXTERNAL_REGISTRY_BASE_DOMAIN}/${REPOSITORY_NAME}"

# Namespace to work in
NAMESPACE={{ NAMESPACE }}

# List of files ending in '.configmap.yml' in the kube directory
CONFIGMAPS=()

# List of files ending in '.service_account.yml' in the kube directory
SERVICE_ACCOUNTS=()

# List of files ending in '.secret.yml' in the kube directory
SECRETS=('travela-backend' 'travela-tls')

# List of files ending in '.service.yml' in the kube directory
SERVICES=('travela-backend' 'nginx')

# List of ingress resource files ending in '.ingress.yml' in the kube directory
INGRESSES=("travela-{{ NAMESPACE }}")

# List of files ending in '.deployment.yml' in the kube directory
DEPLOYMENTS=('travela-backend')

# List of files ending in '.horizontal_pod_autoscaler.yml' in the kube directory
HORIZONTAL_POD_AUTOSCALERS=('travela')

# List of files ending in '.blockingjob.yml' in the kube directory
BLOCKING_JOBS=('travela-backend')
