apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: {{ PROJECT_NAME }}
  namespace: {{ NAMESPACE }}
spec:
  minReadySeconds: 15
  revisionHistoryLimit: 3
  template:
    metadata:
      labels:
        app: {{ PROJECT_NAME }}
    spec:
      containers:
        - name: {{ PROJECT_NAME }}
          image: {{ DOCKER_REGISTRY }}/{{ PROJECT_ID }}/{{ PROJECT_NAME }}:{{ IMAGE_TAG }}
          command:
            - node
            - index.js
          ports:
          - containerPort: {{ PORT }}
            name: http
          env:
            - name: PORT
              value: "{{ PORT }}"
            - name: NodeEnv
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: NodeEnv
            - name: DATABASE_URL
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: DatabaseUrl
            - name: DATABASE_URL_TEST
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: DatabaseUrl
            - name: JWT_SECRET_KEY_TEST
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: JWT_SECRET_KEY_TEST
            - name: JWT_PUBLIC_KEY_TEST
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: JWT_PUBLIC_KEY_TEST
          readinessProbe:
            httpGet:
              path: /api/v1/_healthz
              port: http
            periodSeconds: 10
            timeoutSeconds: 10
            successThreshold: 1
            failureThreshold: 10
          livenessProbe:
            httpGet:
              path: /api/v1/_healthz
              port: http
            initialDelaySeconds: 10
