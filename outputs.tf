
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






