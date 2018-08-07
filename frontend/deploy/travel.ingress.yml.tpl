apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: {{ PROJECT_NAME }}
  namespace: {{ NAMESPACE }}
  labels:
    app: {{ PROJECT_NAME }}
spec:
  tls: []
  rules:
    - http:
      paths:
        - path: /*
          backend:
            serviceName: {{ PROJECT_NAME }}
            servicePort: http
