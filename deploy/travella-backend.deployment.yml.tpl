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
              value : {{ PORT }}
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
          resources:
            requests:
              memory: "64Mi"
              cpu: "100m"
            limits:
              memory: "64Mi"
              cpu: "100m"
          livenessProbe:
            httpGet:
              path: /
              port: http
            initialDelaySeconds: 10
