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
    nginx.ingress.kubernetes.io/proxy-read-timeout: 86400
    nginx.ingress.kubernetes.io/proxy-send-timeout: 86400
    nginx.ingress.kubernetes.io/limit-connections: 6
    nginx.ingress.kubernetes.io/limit-rps: 6
    nginx.ingress.kubernetes.io/limit-rate: 6
spec:
  tls:
    - secretName: travela-tls-secrets
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
  - host: travela-ai.andela.com
    http:
      paths:
      - path: /*
        backend:
          serviceName: travela-machine-learning
          servicePort: http
