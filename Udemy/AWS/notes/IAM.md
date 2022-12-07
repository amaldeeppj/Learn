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

* consists of:
    * __version__: policy language version 
    * __ID__: identifier of the policy (optional)
    * __statement__: one or more individual statements are required
        * __sid__: identifier of the statement
        * __effect__: 




```
{
    "Id": "key-consolepolicy-3",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::797041117166:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        }
    ]
}

```