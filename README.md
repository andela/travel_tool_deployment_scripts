# Travela Deployment scripts

## Infrastructure
![Travela Infrastructure](docs/travela-infrastructure.png)


When a user first accesses Travela's URL, he/she hits the load balancer which allows external traffic into the cluster. The load balancer forwards the traffic to the Nginx ingress controller, which then forwards the traffic to either the frontend or the backend based on the user's request which is determined by the URL.

As shown in the diagram, there are two more communications that occur; frontend talks with the backend and the backend communicates with the database.

## Creating infrastructure
We are using Terraform to create the infrastructure needed by the application on Google Kubernetes Engine (GKE). The Terraform scripts would create the following resources on GCP:
1. A `VPC Network` together with its `subnetwork`.
2. A `kubernetes cluster` with 2 nodes.

To spawn the infrastructure follow the following steps:
1. Export `GOOGLE_APPLICATION_CREDENTIALS` environment variable, it's value should be the path to the GCP's service account key.
2. Navigate to the terraform folder via terminal.
3. Change the terraform's workspace to the one you want to create the infrastructure for, example, `staging`, `production`, etc, by running;
    - `terraform workspace new *your-workspace*` *if the workspace does NOT exist*
    - `terraform workspace select *your-workspace*` *if the workspace exists*
4. Now, to actually create the infrastructure, run this command:
    - `terraform apply`
  This would prompt you for the `GCP's project id` you want to create the infrastructure in, make sure to provide the correct `project id`.

## Update
#### Updating GCP Provider
Update the version number in the `google provider` section of `terraform/gke/gcp.tf` file:
<pre><code>
provider "google" {
  version = "~> <b><i>new_version</i></b>"
  ...
}
</code></pre>
