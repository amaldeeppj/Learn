# IAM 

* Identity and Access Management 
* `Global service` 

* __root account__: created by default 
* __users__: accounts under IAM; `users can be belong to multiple groups` 
* __groups__: Contains set of users. `groups cannot contain other groups`

* Users and groups helps us to manage users and their permissions.

* __Permissions__: 
    users and groups can be assigned JSON doc called IAM policies 

* __policy__: defines permissions of a user 

* `Least privilege principle`: don't give more permissions than a user needs

* __users will inherit the permissions granted for their groups__

* __inline policy__: policy which is only attached to a user rather than attaching a policy to a group
    users with or without groups can have attached with inline policies

## IAM Policy Structure

