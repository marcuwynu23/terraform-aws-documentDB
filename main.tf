# Provider Configuration
provider "aws" {
  region = "ap-southeast-1" # Specify the AWS region (adjust as needed)
}

# Generate a unique ID for the DocumentDB cluster and instance names
resource "random_id" "docdb_cluster_id" {
  byte_length = 8
}

# Create a VPC (if you don't already have one)
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16" # Replace with your desired CIDR block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "MyVPC"
  }
}

# Create a Security Group for DocumentDB in the same VPC
resource "aws_security_group" "docdb_sg" {
  name        = "docdb-security-group"
  description = "Security group for DocumentDB access"
  vpc_id      = aws_vpc.my_vpc.id # Use the VPC created earlier

  # Allow access on DocumentDB default port (27017)
  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow access from anywhere (can restrict as needed)
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "docdb-sg"
  }
}

# Create the DocumentDB Cluster in the same VPC
resource "aws_docdb_cluster" "my_docdb_cluster" {
  cluster_identifier  = "my-docdb-cluster-${random_id.docdb_cluster_id.hex}" # Unique cluster identifier
  engine              = "docdb"                                              # Engine type (DocumentDB)
  master_username     = "admin"                                              # The username for the database
  master_password     = "your-password-here"                                 # The password for the database (store securely)
  skip_final_snapshot = true                                                 # Skip final snapshot on delete (optional)

  # Backup configuration
  backup_retention_period = 7             # Retain backups for 7 days (adjust as needed)
  preferred_backup_window = "07:00-09:00" # Time window for backups (optional)

  # Tags
  tags = {
    Name        = "MyDocumentDBCluster"
    Environment = "Production"
  }

  # VPC security group IDs (use the correct security group ID here)
  vpc_security_group_ids = [aws_security_group.docdb_sg.id]


  # KMS encryption (optional)
  storage_encrypted = true # Enable encryption at rest

  # Ensure the cluster is created in the same VPC (implicitly done through security group)
  
}

# Create the DocumentDB Instance
resource "aws_docdb_cluster_instance" "my_docdb_instance" {
  cluster_identifier = aws_docdb_cluster.my_docdb_cluster.cluster_identifier # Link to the DocumentDB cluster
  instance_class     = "db.r5.large"                                         # Instance class (adjust as needed)
  engine             = "docdb"
  identifier         = "my-docdb-instance-${random_id.docdb_cluster_id.hex}" # Unique instance identifier

  tags = {
    Name        = "MyDocumentDBInstance"
    Environment = "Production"
  }
}

# Output the DocumentDB Cluster Endpoint (URL to connect to the cluster)
output "docdb_cluster_endpoint" {
  value       = aws_docdb_cluster.my_docdb_cluster.endpoint
  description = "The endpoint of the DocumentDB cluster for application connections."
}

# Output the DocumentDB Cluster ARN (useful for other integrations)
output "docdb_cluster_arn" {
  value       = aws_docdb_cluster.my_docdb_cluster.arn
  description = "The ARN of the DocumentDB cluster."
}

# Output the DocumentDB Instance Endpoint (URL to connect to the instance)
output "docdb_instance_endpoint" {
  value       = aws_docdb_cluster_instance.my_docdb_instance.endpoint
  description = "The endpoint of the DocumentDB instance for application connections."
}






