apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: travela-qa
  namespace: qa
  labels:
    app: travela-qa
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/affinity: "cookie"
    nginx.ingress.kubernetes.io/session-cookie-name: "route"
    nginx.ingress.kubernetes.io/session-cookie-hash: "sha1"
    nginx.ingress.kubernetes.io/proxy-read-timeout: 86400
    nginx.ingress.kubernetes.io/proxy-send-timeout: 86400
spec:
  tls:
    - secretName: travela-tls-secrets
  rules:
  - host: travela-qa.andela.com
    http:
      paths:
      - path: /
        backend:
          serviceName: travela-frontend
          servicePort: http
  - host: travela-qa-api.andela.com
    http:
      paths:
      - path: /
        backend:
          serviceName: travela-backend
          servicePort: http
