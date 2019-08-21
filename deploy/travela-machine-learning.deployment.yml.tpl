apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: {{ PROJECT_NAME }}
  namespace: {{ ENVIRONMENT }}
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
          imagePullPolicy: Always
          command: ["python", "run.py", "runserver"]
          ports:
          - containerPort: {{ PORT }}
            name: http
          env:
            - name: DB_URL
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: DatabaseUrl
            - name: SECRET_KEY
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: SecretKey
            - name: APP_SETTINGS
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: AppSettings
          readinessProbe:
            httpGet:
              path: /
              port: http
            periodSeconds: 10
            timeoutSeconds: 10
            successThreshold: 1
            failureThreshold: 10
          livenessProbe:
            httpGet:
              path: /
              port: http
            initialDelaySeconds: 10
        - name: cloudsql-proxy
          image: gcr.io/cloudsql-docker/gce-proxy:1.13
          command: ["/cloud_sql_proxy",
                    "-instances={{ DB_INSTANCE_CONNECTION_NAME }}=tcp:5432",
                    "-credential_file=/secrets/cloudsql/credentials.json",
                    "-log_debug_stdout=true"]
          securityContext:
            runAsUser: 2  # non-root user
            allowPrivilegeEscalation: false
          volumeMounts:
            - name: cloudsql-instance-credentials
              mountPath: /secrets/cloudsql
              readOnly: true
      volumes:
        - name: cloudsql-instance-credentials
          secret:
            secretName: cloudsql-instance-credentials
