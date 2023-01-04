data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_route53_zone" "selected" {
  name = "amaldeep.tech"

}

data "template_file" "db_credentials" {
  template = "${file("${path.module}/database.sh")}"
  vars = {
    DB_NAME      = var.db_name
    DB_USER      = var.db_user
    DB_PASS      = var.db_password
    DB_ROOT_PASS = var.db_root_password
  }
}

data "template_file" "db_credentials_frontend" {
  template = "${file("${path.module}/frontend.sh")}"
  vars = {
    DB_NAME = var.db_name
    DB_USER = var.db_user
    DB_PASS = var.db_password
    DB_HOST = "db.${var.private_zone}"
  }
}


