---
apiVersion: v1
kind: Service
metadata:
  name: {{ PROJECT_NAME }}
  namespace: {{ ENVIRONMENT }}
  labels:
    app: {{ PROJECT_NAME }}
spec:
  type: NodePort
  ports:
    - name: http
      protocol: TCP
      port: 80
      targetPort: {{ PORT }}
  selector:
    app: {{ PROJECT_NAME }}
