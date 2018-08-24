apiVersion: v1
kind: Secret
metadata:
  name: {{ PROJECT_NAME }}-tls-secrets
  namespace: {{ NAMESPACE }}
type: kubernetes.io/tls
data:
  tls.crt: {{ SSL_CERTIFICATE }}
  tls.key: {{ SSL_PRIVATE_KEY }}
