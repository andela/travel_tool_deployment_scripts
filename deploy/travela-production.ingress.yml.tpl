apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: travela-production
  namespace: production
  labels:
    app: travela-production
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/affinity: "cookie"
    nginx.ingress.kubernetes.io/session-cookie-name: "route"
    nginx.ingress.kubernetes.io/session-cookie-hash: "sha1"
spec:
  tls:
    - secretName: {{ PROJECT_NAME }}-tls-secrets
  rules:
  - host: travela.andela.com
    http:
      paths:
      - path: /
        backend:
          serviceName: travela-frontend
          servicePort: http
  - host: travela-api.andela.com
    http:
      paths:
      - path: /
        backend:
          serviceName: travela-backend
          servicePort: http
