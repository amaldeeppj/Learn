

# terraform init
initiate the provider 

# terraform validate 
validate the code

# terraform fmt 
format code files

# terraform plan 
dry run the code 

# terraform apply 
run code 

# terraform.tfstate 

# file 
reads the contents of a file at the given path and returns them as a string
file(path)

used in reading key files


# terraform output [output name]
to view output 


# terraform state list 

# terraform state show <resource name>

# default_tags

# current state VS desired state 

# locals 

# common_tags 
variables cannot be reffered inside another variable

# terraform life cycle policy 
security group name and description are immutable
cannot remove existing security group, need to create a new one and attach, then detach the older one 

# name_prefix 

# count 
has issues when working with lists. if order of list elements are modified, count will have to create the resources 
resources will be saved into array in tfstate file
reources are linked to index order of count. so index order has changed, resource will be recreated 
subnets[0].id
subnets[1].id

array and count should not used together
* use array with for_each 
* count loops based on a number
* for_each loops over an array/map


# Types of array
* set - values cannot be repeated
* list - values can be repeated
* tuple 

* Only set of strings or map can be used in for_each 
* toset() - convert list to set  - only list?

> In list(string), numbers will be converted to string

in for_each, resources will be saved into map
subnet["web"].id



# Terraform workspace 

terraform workspace new <workspace>
terraform workspace list 
terraform workspace select <workspace>


bash show workspace in prompt 


wrapper in bash 


# dynamic blocks
repeatable nested blocks inside top level blocks

labels?
