# Terraform VMware vSphere Static IP + SSH + Docker Access for user

this Terraform module provisions VMware virtual machines with:
- **Static IP assignment** (configurable range)
- **SSH access** with key-based authentication
- **Docker socket access** for newly admin created user to access docker Docker Engine

Perfect for DevOps and Cloud engineers needing consistent, reproducible VM environments with Docker control.

---

## 🛠️ Prerequisites

- Terraform v1.0+
- VMware vSphere environment (ESXi + vCenter)
- SSH key pair (public key for VM auth)
- Docker installed on target VMs (handled via cloud-init)

---

## ⚙️ Configuration

### 1. Set Your Variables in `terraform.tfvars`
### 2. Edit the locals block in main.tf to define your desired static IP range
### 3. # Initialize Terraform

```hcl
terraform init

# Review plan
terraform plan

# Apply configuration
terraform apply

# SSH into a VM (after apply)
ssh user@192.168.1.5

# test docker have no permission error
docker ps
