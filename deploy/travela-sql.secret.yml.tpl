apiVersion: v1
kind: Secret
metadata:
  name: cloudsql-instance-credentials
  namespace: {{ NAMESPACE }}
  labels:
    app: {{ PROJECT_NAME }}
type: Opaque
data:
  credentials.json: {{ SQL_SERVICE_ACCOUNT }}
