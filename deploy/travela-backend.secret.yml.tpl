apiVersion: v1
kind: Secret
metadata:
  name: {{ PROJECT_NAME }}-secrets
  namespace: {{ ENVIRONMENT }}
  labels:
    app: {{ PROJECT_NAME }}
type: Opaque
data:
  JwtPublicKey: {{ JWT_PUBLIC_KEY }}
  DatabaseUrl: {{ DATABASE_URL }}
  DefaultAdmin: {{ DEFAULT_ADMIN }}
  RedirectUrl: {{ REDIRECT_URL }}
  BugsnagApiKey: {{ BUGSNAG_API_KEY }}
  MailgunApiKey: {{ MAILGUN_API_KEY }}
  MailgunDomainName: {{ MAILGUN_DOMAIN_NAME }}
  MailSender: {{ MAIL_SENDER }}
  CloudinaryCloudName: {{ CLOUDINARY_CLOUD_NAME }}
  CloudinaryApikey: {{ CLOUDINARY_API_KEY }}
  CloudinaryApiSecret: {{ CLOUDINARY_API_SECRET }}
  CloudinaryEnhanceImage: {{ CLOUDINARY_ENHANCE_IMAGE }}
  CloudinaryStaticImage: {{ CLOUDINARY_STATIC_IMAGE }}
  TravelReadinessMailCycle: {{ TRAVEL_READINESS_MAIL_CYCLE }}
  SurveyUrl: {{ SURVEY_URL }}
  AndelaProdApi: {{ ANDELA_PROD_API }}
  BamboohrApi: {{ BAMBOOHR_API }}
  LastChangedBambooApi: {{ LASTCHANGED_BAMBOO_API }}
  BamboohridApi: {{ BAMBOOHRID_API }}
  OcrSolution: {{ OCRSOLUTION }}
  CrashReportingChannel: {{CRASH_REPORTING_CHANNEL}}
  