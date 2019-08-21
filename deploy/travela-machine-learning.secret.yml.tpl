apiVersion: v1
kind: Secret
metadata:
  name: {{ PROJECT_NAME }}-secrets
  namespace: {{ ENVIRONMENT }}
  labels:
    app: {{ PROJECT_NAME }}
type: Opaque
data:
  DatabaseUrl: {{ DB_URL }}
  SecretKey: {{ SECRET_KEY }}
  AppSettings: {{ APP_SETTINGS }}
