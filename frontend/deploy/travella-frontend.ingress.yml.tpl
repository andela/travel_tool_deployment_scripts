apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: {{ PROJECT_NAME }}
  namespace: {{ NAMESPACE }}
  labels:
    app: {{ PROJECT_NAME }}
  annotations:
    kubernetes.io/ingress.global-static-ip-name: {{ INGRESS_STATIC_IP_NAME }}
spec:
  rules:
  - http:
      paths:
      - path: /*
        backend:
          serviceName: {{ PROJECT_NAME }}
          servicePort: http


