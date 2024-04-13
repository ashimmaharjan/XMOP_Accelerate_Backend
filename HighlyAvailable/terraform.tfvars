aws_region    = "ap-southeast-2"
min_instances = 2
max_instances = 5
ami           = "ami-081ab858da818bcf1"
instance_type = "t2.micro"
key_name      = "wordpressKey"

db_engine               = "mysql"
engine_version          = "5.7"
db_instance_type        = "db.t3.micro"
db_name                 = "wordpressdb"
db_user                 = "admin"
db_password             = "Wordpress-AWS2Tier"
storage_capacity        = 20
target_application_port = 80
