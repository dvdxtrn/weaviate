# 🚀 Terraform EKS Weaviate Deployment

This section of the challenge automates the deployment of a **Weaviate vector database** on **Amazon EKS (Elastic Kubernetes Service)** cluster using **Terraform** and **Helm**. It provides a scalable, highly available, and repeatable infrastructure setup that can be reused across environments like `dev`, `staging`, or `prod`.

---

## 📦 What This Project Does

- Creates an EKS cluster via Terraform providers
- Creates a dedicated Kubernetes namespace for Weaviate
- Deploys Weaviate using the official Helm chart
- Configures:
  - Pod replica count
  - Data replication
  - Persistent storage
  - Affinity and tolerations
- Applies AWS tags for resource tracking
- Outputs key deployment information

---

## 📁 Project Structure

```text
.
├── main.tf              # Main deployment logic
├── variables.tf         # Configurable inputs
├── outputs.tf           # Post-deploy outputs
├── terraform.tfvars     # Your environment-specific settings
└── modules/
    └── weaviate/
        ├── main.tf      # Helm release definition
        ├── variables.tf # Inputs to the module
        └── outputs.tf   # Module-level outputs
````

---

## 🛠️ Requirements

* Terraform >= 1.3.0
* AWS CLI with access to EKS
* Helm installed (for local validation, optional)

---

## 🔧 How to Use

1. **Initialize the project**

   ```bash
   terraform init
   ```

2. **Review the plan**

   ```bash
   terraform plan -var-file="terraform.tfvars"
   ```

3. **Apply the changes**

   ```bash
   terraform apply -var-file="terraform.tfvars"
   ```

4. **Verify the output**
   After a successful apply, Terraform will show:

   * Cluster name
   * Namespace
   * Number of replicas
   * PVC size

---

## 🧪 Example `terraform.tfvars`

```hcl
region                      = "us-west-2"
eks_cluster_name            = "wv-customer-prod"
namespace                   = "weaviate"
environment                 = "prod"

aws_default_tags = {
  owner       = "sre-team"
  environment = "prod"
  project     = "weaviate-cluster"
}

replica_count               = 3
weaviate_replication_factor = 3
weaviate_storage_size       = "50Gi"
```

---

## 📤 Outputs

| Output                   | Description                           |
| ------------------------ | ------------------------------------- |
| `eks_cluster_name`       | The name of the EKS cluster used      |
| `weaviate_namespace`     | Kubernetes namespace for Weaviate     |
| `weaviate_replica_count` | Number of replicas deployed           |
| `weaviate_storage_size`  | Size of the persistent volume per pod |

---

## 🧠 Notes

* If you're using this for multiple environments, create files like `dev.tfvars`, `prod.tfvars`, etc.

---

## 📚 Resources

* [Weaviate Helm Chart](https://artifacthub.io/packages/helm/weaviate/weaviate)
* [Terraform Helm Provider Docs](https://registry.terraform.io/providers/hashicorp/helm/latest/docs)
* [Terraform Kubernetes Provider Docs](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)