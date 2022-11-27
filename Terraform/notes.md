
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
> map(string), keys  and values are strings. This can be used to declare key value pairs without any predefined keys and values. (Eg in tags section, we can declare a map(string) to let the user define all the tags)


```
variable "files" {
  description = "Configuration for website files."
  type = object({
    terraform_managed     = bool
    error_document_key    = optional(string, "error.html")
    index_document_suffix = optional(string, "index.html")
    www_path              = optional(string)
  })
}
```

The above code is an example of module object  atributes. Input varianbles of a module can be encapsulated in a single object, so that related options can be grouped together. 

> optional: can be used to define the variable is optional. Also can provide default value and data type.  




# Data source 


https://developer.hashicorp.com/terraform/language/data-sources

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami




> how to use a module multiple times in the same place: https://stackoverflow.com/questions/65827717/how-to-get-public-ip-of-ec2-instance-in-terraform


* variable validation    

https://developer.hashicorp.com/terraform/language/expressions/custom-conditions#input-variable-validation


* input variables

https://developer.hashicorp.com/terraform/language/values/variables#custom-validation-rules



* Validate Modules with Custom Conditions

https://developer.hashicorp.com/terraform/tutorials/configuration-language/custom-conditions


* substr 

https://developer.hashicorp.com/terraform/language/functions/substr



* file 

https://developer.hashicorp.com/terraform/language/functions/file

