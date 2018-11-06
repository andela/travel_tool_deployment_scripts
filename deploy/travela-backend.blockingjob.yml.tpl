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
          - name: SURVEY_URL
            valueFrom:
              secretKeyRef:
                name: {{ PROJECT_NAME }}-secrets
                key: SurveyUrl
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
      restartPolicy: Never
