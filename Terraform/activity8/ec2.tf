resource "aws_instance" "devenv" {

    count = length(var.instance)
    # name = "${var.instance[count.index]}_env"
    
    ami = var.ami
    instance_type = var.instanceType
    key_name = var.keyName
    vpc_security_group_ids = [ aws_security_group.sec_group.id ]
    # vpc_id = aws_vpc.new_vpc_tf.id
    subnet_id = aws_subnet.subnet_tf[count.index].id

    tags = {
      Name = "${var.instance[count.index]}_environment"
    }
  
}
