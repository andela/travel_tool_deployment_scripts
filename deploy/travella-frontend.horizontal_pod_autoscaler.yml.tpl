apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: {{ PROJECT_NAME }}
  namespace: {{ NAMESPACE }}
spec:
  minReplicas: {{ MINIMUM_REPLICAS }}
  maxReplicas: {{ MAXIMUM_REPLICAS }}
  scaleTargetRef:
    apiVersion: extensions/v1beta1
    kind: Deployment
    name: {{ PROJECT_NAME }}
  targetCPUUtilizationPercentage: {{ TARGET_CPU_UTILIZATION }}
