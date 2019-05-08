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
          command:
            - node
            - index.js
          ports:
          - containerPort: {{ PORT }}
            name: http
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
