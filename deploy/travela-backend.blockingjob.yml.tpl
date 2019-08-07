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
              yarn db:migrate
          volumeMounts:
            - name: tmp-pod
              mountPath: /tmp/pod
          env:
            - name: PORT
              value: "{{ PORT }}"
            - name: NODE_ENV
              value: {{ NAMESPACE }}
            - name: DATABASE_URL
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: DatabaseUrl
            - name: JWT_PUBLIC_KEY
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: JwtPublicKey
            - name: DEFAULT_ADMIN
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: DefaultAdmin
            - name: REDIRECT_URL
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: RedirectUrl
            - name: BUGSNAG_API_KEY
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: BugsnagApiKey
            - name: MAILGUN_API_KEY
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: MailgunApiKey
            - name: MAILGUN_DOMAIN_NAME
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: MailgunDomainName
            - name: MAIL_SENDER
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: MailSender
            - name: CLOUDINARY_CLOUD_NAME
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: CloudinaryCloudName
            - name: CLOUDINARY_API_KEY
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: CloudinaryApikey
            - name: CLOUDINARY_API_SECRET
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: CloudinaryApiSecret
            - name: CLOUDINARY_ENHANCE_IMAGE
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: CloudinaryEnhanceImage
            - name: CLOUDINARY_STATIC_IMAGE
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: CloudinaryStaticImage
            - name: TRAVEL_READINESS_MAIL_CYCLE
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: TravelReadinessMailCycle
            - name: SURVEY_URL
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: SurveyUrl
            - name: ANDELA_PROD_API
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: AndelaProdApi
            - name: BAMBOOHR_API
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: BamboohrApi
            - name: LASTCHANGED_BAMBOO_API
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: LastChangedBambooApi
            - name: BAMBOOHRID_API
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: BamboohridApi
            - name: OCRSOLUTION
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: OcrSolution
            - name: CRASH_REPORTING_CHANNEL
              valueFrom:
                secretKeyRef:
                  name: {{ PROJECT_NAME }}-secrets
                  key: CrashReportingChannel
      restartPolicy: Never
