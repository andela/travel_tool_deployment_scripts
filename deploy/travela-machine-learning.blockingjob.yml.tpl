apiVersion: batch/v1
kind: Job
metadata:
  name: {{ PROJECT_NAME }}
  namespace: {{ ENVIRONMENT }}
spec:
  template:
    metadata:
      name: {{ PROJECT_NAME }}
    spec:
      volumes:
        - name: cloudsql-instance-credentials
          secret:
            secretName: cloudsql-instance-credentials
        - name: tmp-pod
          emptyDir: {}
      containers:
        - name: cloudsql-proxy
          image: gcr.io/cloudsql-docker/gce-proxy:1.13
          command: ["sh", "-c"]
          args:
            - |
              /cloud_sql_proxy -instances={{ DB_INSTANCE_CONNECTION_NAME }}=tcp:5432 -credential_file=/secrets/cloudsql/credentials.json -log_debug_stdout=true &
              CHILD_PID=$!
              (while true; do echo "waiting for termination file"; if [[ -f "/tmp/pod/main-terminated" ]]; then kill $CHILD_PID; echo "Killed $CHILD_PID as the main container terminated."; fi; sleep 1; done) &
              wait $CHILD_PID
              if [[ -f "/tmp/pod/main-terminated" ]]; then exit 0; echo "Job completed. Exiting..."; fi
          securityContext:
            runAsUser: 2  # non-root user
            allowPrivilegeEscalation: false
          volumeMounts:
            - name: cloudsql-instance-credentials
              mountPath: /secrets/cloudsql
              readOnly: true
            - name: tmp-pod
              mountPath: /tmp/pod
        - name: {{ PROJECT_NAME }}
          image: {{ DOCKER_REGISTRY }}/{{ PROJECT_ID }}/{{ PROJECT_NAME }}:{{ IMAGE_TAG }}
          command: ["/bin/sh", "-c"]
          args:
            - |
              trap "touch /tmp/pod/main-terminated" EXIT
              python3 run.py db migrate
          volumeMounts:
            - name: tmp-pod
              mountPath: /tmp/pod
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
      restartPolicy: Never
