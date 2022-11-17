variable "resource_group" {
    type = object(
        {
            name = string
            location = string 
        }
    )

default = {
  location = "East US"
  name = "testRGfromTF"
}
  
}
