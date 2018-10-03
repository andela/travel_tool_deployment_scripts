apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: travela-staging
  namespace: staging
  labels:
    app: travela-staging
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/affinity: "cookie"
    nginx.ingress.kubernetes.io/session-cookie-name: "route"
    nginx.ingress.kubernetes.io/session-cookie-hash: "sha1"
    nginx.ingress.kubernetes.io/proxy-read-timeout: 3600
    nginx.ingress.kubernetes.io/proxy-send-timeout: 3600
spec:
  tls:
    - secretName: travela-tls-secrets
  rules:
  - host: travela-staging.andela.com
    http:
      paths:
      - path: /
        backend:
          serviceName: travela-frontend
          servicePort: http
  - host: travela-staging-api.andela.com
    http:
      paths:
      - path: /
        backend:
          serviceName: travela-backend
          servicePort: http
