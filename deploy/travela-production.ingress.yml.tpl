apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: travella-production
  namespace: production
  labels:
    app: travella-production
  annotations:
    kubernetes.io/ingress.global-static-ip-name: {{ INGRESS_STATIC_IP_NAME }}
spec:
  rules:
  - host: travela.andela.com
    http:
      paths:
      - path: /*
        backend:
          serviceName: travella-frontend
          servicePort: http
  - host: travela-api.andela.com
    http:
      paths:
      - path: /*
        backend:
          serviceName: travella-backend
          servicePort: http