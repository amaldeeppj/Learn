# IAM 

* Identity and Access Management 
* `Global service` 

* root account: created by default 
* users: accounts under IAM; `users can be belong to multiple groups` 
* groups: Contains set of users. `groups cannot contain other groups`

* Users and groups helps us to manage users and their permissions.

* Permissions: 
    users and groups can be assigned JSON doc called IAM policies 

* policy: defines permissions of a user 

* `Least privilege principle`: don't give more permissions than a user needs

* users will inherit the permissions granted for their groups

* inline policy: policy which is only attached to a user rather than attaching a policy to a group
    users with or without groups can have attached with inline policies

## IAM Policy Structure

