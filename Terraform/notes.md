
### 19 nov 22

https://www.freecodecamp.org/news/terraform-modules-explained/#:~:text=A%20Terraform%20module%20allows%20you,features%20hosted%20in%20the%20cloud.

https://developer.hashicorp.com/terraform/tutorials/modules

https://developer.hashicorp.com/terraform/tutorials/certification/associate-study?in=terraform%2Fcertification



root module - conf files in current working directory   
child module - a module that is called by another configuration



Name your provider like this:
> ***`terraform-<PROVIDER>-<NAME>`***




* ###### Structure of module
    * LICENSE
    * README.md
    * main.tf
    * variables.tf
    * outputs.tf



* ###### Files and directories shouldn't be shared with modules: 
    * terraform.tfstate 
    * .terraform 
    * *.tfvars 


> A .gitignore file can be used here: https://github.com/github/gitignore/blob/main/Terraform.gitignore

