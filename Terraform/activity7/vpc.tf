resource "aws_vpc" "amaldeep_vnetpc" {
    cidr_block = var.nw_range

    tags = {
      "Name" = var.network_name
    }
  
}