resource "aws_db_instance" "greencompute_db" {
  allocated_storage    				 = 15  # in gigabytes
  engine               				 = "postgres"
  engine_version       				 = "16.3"
  instance_class       				 = "db.t4g.micro"
	storage_encrypted 	 				 = true
	copy_tags_to_snapshot 			 = true
	max_allocated_storage 			 = 1000
	monitoring_interval 				 = 60
	performance_insights_enabled = true
	publicly_accessible					 = true
}