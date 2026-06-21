# Terraform AWS DocumentDB Cluster Provisioning

This Terraform project provisions an Amazon DocumentDB cluster inside a custom VPC, including security group configuration and a single database instance.

## Prerequisites

Ensure the following tools are installed and configured:
- Terraform >= 1.0
- AWS CLI configured (`aws configure`)
- AWS account with permissions for VPC, DocumentDB, EC2 networking, and IAM

Verify:

```bash
aws sts get-caller-identity
```

## Setup & Deployment

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **Validate Configuration**:
   ```bash
   terraform validate
   ```

3. **Plan Deployment**:
   ```bash
   terraform plan
   ```

4. **Apply Infrastructure**:
   ```bash
   terraform apply -auto-approve
   ```

   This will create: VPC, security group, DocumentDB cluster, and DocumentDB instance.

5. **Destroy** (when no longer needed):
   ```bash
   terraform destroy -auto-approve
   ```

## Usage as a Module

Reference this repository as a Terraform module in your own configurations:

```hcl
module "documentdb" {
  source = "github.com/marcuwynu23/terraform-aws-documentDB?ref=main"
}
```

Then use the outputs in your configuration:

```hcl
output "db_endpoint" {
  value = module.documentdb.docdb_cluster_endpoint
}
```

All outputs documented below are available when using this as a module.

## Variables

This module accepts no configurable variables. Cluster name, instance class, VPC settings, and credentials are preconfigured with sensible defaults.

## Outputs

| Output | Description |
|--------|-------------|
| `docdb_cluster_endpoint` | Endpoint of the DocumentDB cluster for application connections |
| `docdb_cluster_arn` | ARN of the DocumentDB cluster |
| `docdb_instance_endpoint` | Endpoint of the DocumentDB instance |

## Default Configuration

- Engine: DocumentDB (MongoDB compatible)
- Instance Class: db.r5.large
- Backup Retention: 7 days
- Storage Encryption: Enabled
- Port: 27017

## Security Notes

- Default password is set in Terraform (`master_password`) and must be changed for production
- Security group currently allows access from `0.0.0.0/0` (not secure for production)
- Recommended to restrict access to your IP only
- Do not expose port 27017 to the public internet
- Store passwords in AWS Secrets Manager or environment variables

## Connection Details

Example connection string:

```text
mongodb://admin:your-password-here@<cluster-endpoint>:27017/?ssl=true&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false
```

## Common Issues

### Cannot connect to cluster
- Check security group inbound rules
- Ensure VPC routing allows access
- Verify SSL connection is enabled

### Cluster creation fails
- Ensure valid AWS region supports DocumentDB
- Check instance class availability
