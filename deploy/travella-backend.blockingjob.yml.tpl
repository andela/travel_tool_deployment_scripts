apiVersion: batch/v1
kind: Job
metadata:
  name: {{ PROJECT_NAME }}
  namespace: {{ NAMESPACE }}
spec:
  template:
    metadata:
      name: {{ PROJECT_NAME }}
    spec:
      containers:
      - name: {{ PROJECT_NAME }}
        image: {{ DOCKER_REGISTRY }}/{{ PROJECT_ID }}/{{ PROJECT_NAME }}:{{ IMAGE_TAG }}
        command:
          - yarn
          - db:migrate
          env:
            - name: NODE_ENV
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: NodeEnv
            - name: DATABASE_URL
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: DatabaseUrl
      restartPolicy: Never
