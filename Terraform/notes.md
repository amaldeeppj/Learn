
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


> A .gitignore file can be used here. Refer: https://github.com/github/gitignore/blob/main/Terraform.gitignore



The `provider` block should not be added in the module.   
The provider should be inherited from the root module rather than the child module. (Whoever using the module should specify the provider)   



The values in `output.tf` inside root module will be shown to the user. 
The values in output.tf file can be used to pass information about parts of the infra to another modules. ie., To pass values between modules. 



> When creating a module, the only variables defined inside the module can be assigned while calling the module. Similarly, the values we will get in return from the modules are the values defined in outputs.tf file. Thus to pass values to the module, first we have to declare them as variables inside the module. To retrieve some values in return from the module inorder to use them for other resources, we have to declare as output inside the module. Refer here:   
https://github.com/amaldeeppj/Learn/tree/main/Terraform/activity11   





> Objects map a specific set of named keys to values.   
