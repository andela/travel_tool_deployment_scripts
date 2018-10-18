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
      restartPolicy: Never
