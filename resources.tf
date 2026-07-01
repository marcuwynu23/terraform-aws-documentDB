# Generate a unique ID for the DocumentDB cluster and instance names
resource "random_id" "docdb_cluster_id" {
  byte_length = 8
}

# Create a VPC (if you don't already have one)
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr_block
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
    cidr_blocks = var.allowed_cidr_blocks
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
  cluster_identifier  = "${var.cluster_identifier_prefix}${random_id.docdb_cluster_id.hex}"
  engine              = "docdb"
  master_username     = var.master_username
  master_password     = var.master_password
  skip_final_snapshot = true

  backup_retention_period = var.backup_retention_period
  preferred_backup_window = "07:00-09:00"

  # Tags
  tags = {
    Name        = "MyDocumentDBCluster"
    Environment = var.environment
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
  instance_class     = var.instance_class
  engine             = "docdb"
  identifier         = "${var.instance_identifier_prefix}${random_id.docdb_cluster_id.hex}"

  tags = {
    Name        = "MyDocumentDBInstance"
    Environment = var.environment
  }
}