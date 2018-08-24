# travel tool deployment scripts

Secrets for the backend should be stored inside GCP storage bucket. Here is an example of that file with the keys that are required:

```
data:
  DatabaseUrl: "postgresql://username:password@host:port/database"
  NodeEnv: "environment"
```

Then the path to that file should be exported as `SECRET_FILE` environment variable, example:

```
export SECRET_FILE=gs://bucket-name/[folder]/file
```
