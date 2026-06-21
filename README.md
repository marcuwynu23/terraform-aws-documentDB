# Terraform AWS DocumentDB Cluster Provisioning

This Terraform project provisions an Amazon DocumentDB cluster inside a custom VPC, including security group configuration and a single database instance.

---

## Overview

This configuration creates:

* A custom VPC
* A security group for DocumentDB access
* A DocumentDB cluster
* A DocumentDB instance
* Randomized naming for uniqueness

It is intended for development or production-style MongoDB-compatible workloads on AWS.

---

## Resources Created

* `aws_vpc.my_vpc` – Custom VPC for database isolation
* `aws_security_group.docdb_sg` – Security group allowing MongoDB port access (27017)
* `aws_docdb_cluster.my_docdb_cluster` – DocumentDB cluster
* `aws_docdb_cluster_instance.my_docdb_instance` – Database instance
* `random_id.docdb_cluster_id` – Ensures unique cluster and instance names

---

## Prerequisites

Ensure the following tools are installed and configured:

* Terraform >= 1.0
* AWS CLI configured (`aws configure`)
* AWS account with permissions for:

  * VPC
  * DocumentDB
  * EC2 networking
  * IAM (if needed)

Verify setup:

```sh
terraform -v
aws sts get-caller-identity
```

---

## Security Notes

* Default password is set in Terraform (`master_password`) and must be changed for production
* Security group currently allows access from `0.0.0.0/0` (not secure for production)
* It is recommended to restrict access to your IP only

Example:

```hcl
cidr_blocks = ["YOUR_IP/32"]
```

---

## File Structure

```
.
├── main.tf
├── variables.tf (optional if extended)
└── outputs.tf
```

---

## Usage

### 1. Initialize Terraform

```sh
terraform init
```

---

### 2. Validate Configuration

```sh
terraform validate
```

---

### 3. Plan Deployment

```sh
terraform plan
```

---

### 4. Apply Infrastructure

```sh
terraform apply -auto-approve
```

This will create:

* VPC
* Security group
* DocumentDB cluster
* DocumentDB instance

---

### 5. Destroy Infrastructure (optional)

```sh
terraform destroy -auto-approve
```

---

## Outputs

After deployment, Terraform provides:

### Cluster Endpoint

Used for application connections:

```
docdb_cluster_endpoint
```

---

### Cluster ARN

Used for integrations and AWS references:

```
docdb_cluster_arn
```

---

### Instance Endpoint

Direct instance-level connection endpoint:

```
docdb_instance_endpoint
```

---

## Usage as a Module

Reference this repository as a Terraform module in your own configurations:

```hcl
module "documentdb" {
  source = "github.com/marcuwynu23/terraform-aws-documentDB?ref=main"
}
```

Then use the outputs in your configuration:

```hcl
# Example: pass the cluster endpoint to an application config
output "db_endpoint" {
  value = module.documentdb.docdb_cluster_endpoint
}
```

All outputs documented below are available when using this as a module.

---

## Connection Details

DocumentDB uses MongoDB-compatible protocol.

Example connection string:

```text
mongodb://admin:your-password-here@<cluster-endpoint>:27017/?ssl=true&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false
```

---

## Default Configuration

* Engine: DocumentDB (MongoDB compatible)
* Instance Class: db.r5.large
* Backup Retention: 7 days
* Backup Window: 07:00-09:00
* Storage Encryption: Enabled
* Port: 27017

---

## Networking

* VPC CIDR: 10.0.0.0/16
* Subnet: Managed by default VPC resources (can be extended)
* Security Group: Allows inbound MongoDB traffic (27017)

---

## Common Issues

### Cannot connect to cluster

* Check security group inbound rules
* Ensure VPC routing allows access
* Verify SSL connection is enabled

### Cluster creation fails

* Ensure valid AWS region supports DocumentDB
* Check instance class availability

---

## Security Best Practices

* Do not expose port 27017 to the public internet
* Store passwords in AWS Secrets Manager or environment variables
* Use private subnets for production deployments
* Enable IAM authentication if required

---

## Summary

This Terraform setup provisions a fully functional AWS DocumentDB environment with:

* Isolated VPC networking
* Secure database cluster
* Scalable instance setup
* MongoDB-compatible connection support
