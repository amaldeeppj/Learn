### 18 nov 22


__Task 1__

Created an instance and installed apache. In security group, allowed all traffic for both inbound and outbound.  
Screenshot 1: Security group details
Screenshot 2: Website loading from the instance 

Removed outbound rules from the security group.
Screenshot 3: Security group details
Screenshot 4: Website still loading from the instance 

Added allow all traffic to outbound of the security group. 
Created NACL - my-NACL. Associated new NACL with the subnet containing the existing EC2 instance. 
Screenshot 5: my-NACL -> subnet association
Screenshot 6: EC2 details including subnet info

Added rule #100 in my-NACL outbound section to allow all traffic. 
Added rule #200 in my-NACL inbound section to allow SSH from my ip.
Added rule #300 in my-NACL inbound section to allow HTTP from my ip.
Screenshot 7: my-NACL > inbound section 

Deleted my-NACL after removing association with the subnet. The subnet is now associated with the default NACL. 



__Task 2__


VPC Peering

Create 2 VPC in Ohio
1. Frontend-VPC     172.16.0.0/16
    frontend-public-1   172.16.0.0/18
    frontend-public-2   172.16.64.0/18
    frontend-private-1   172.16.128.0/18

    IGW
        frontent-IGW

    Enable DNS hostname
    Enable public IP in public subnets 

    Route table 
        frontend-public-rtb
        frontend-private-rtb

    Create SGs for instances
        frontend-webserver-sg
        frontend-bastion-sg

    Create 2 EC2 
        frontend-webserver
        frontend-bastion


    

2. Backend-VPC      172.17.0.0/16
    backend-public-1   172.17.0.0/18
    backend-public-2   172.17.64.0/18
    backend-private-1   172.17.128.0/18

    IGW
        backent-IGW

    NAT-GW
        nat-gw create under backend-public-2 subnet 

    Enable DNS hostname
    Enable public IP in public subnets 

    Route table 
        backend-public-rtb
        backend-private-rtb

    Create SGs for instances
        backend-database
            (22 from sation subnet address, 3306 from frontend address)

    Create EC2 
        backend-database







Screenshot 
Route table entries 
SG entries of EC2s


Screenshot 1: Route table entries of frontend-public-rtb
Screenshot 2: Route table entries of frontend-private-rtb
Screenshot 3: Route table entries of backend-public-rtb
Screenshot 4: Route table entries of backend-private-rtb
Screenshot 5: SG entries of bastion server
Screenshot 6: SG entries of webserver frontend server
Screenshot 7: SG entries of database backend server

Website working fine. URL: http://ec2-3-16-69-208.us-east-2.compute.amazonaws.com/ 








22 nov 22




1
domain transfer to route53 
hosted zones 

2
create 2 backend 
backend-ap-south-1a
backend-ap-south-1b 

screenshot 
ec2 instances in console 

3
git clone 
apache restart 
check both instance 

screenshot 
2 website 


create ELB
shopping-app
select subnets 
port 
http 80 in both 

sg - all traffic 
ssl cert no

connection draining 5 sec 


screenshot 
load balancer: 
description
instances 
share url 

4
shopping-app 
cname 

share http://shopping-app.amaldeep.tech 

5
whatismyip
tailf /var/log/access_log

access websites 
check logs 

screenshot - 
my ip 
logs 





ns-1253.awsdns-28.org.
ns-685.awsdns-21.net.
ns-438.awsdns-54.com.
ns-1823.awsdns-35.co.uk.





#!/bin/bash

yum update -y
hostnamectl set-hostname backend1b.amaldeep.tech
yum install git httpd -y 
amazon-linux-extras install php7.4  -y 
git clone https://github.com/Fujikomalan/aws-elb-site.git  /var/website/
cp -r  /var/website/*  /var/www/html/
chown -R apache:apache /var/www/html/*
systemctl restart httpd.service
systemctl enable httpd.service





screenshot of 2 instances created 

screenshots of websites loading from both instances 

screenshot of CLB

screenshot of instances section in CLB 

CLB URL: http://shopping-app-431665167.ap-south-1.elb.amazonaws.com/

Website URL: http://shopping-app.amaldeep.tech 

screenshot of my public IP 

screenshots of logs from both servers. Connections are coming from CLB private IP for website contents and health check page. 








24 nov 2022



1. 
create ssl in acm (mumbai region)

screenshot 
ssl issued 
rooute53 dns entries 


create 2 backends 
backend-ap-south-1a
backend-ap-south-1b

screenshot 
instances in console 
web page 
URL

create clb 
http 80
connection draining 5 sec




myapp cname to clb 

edit log conf xforwarded 

screenshot 
public ip in log file
whatis my ip
conf 


add https in listener 
load ssl cert 

screenshot 
ssl cert in browser 
share url 


sticky session 
screenshot
browser inspection 


remove listner 
add tcp listener 
check xforwarded 



1a
Screenshot: SSL cert issued in ACM 

1b
Screenshot: CNAME added for domain verification

2a
Screenshot: backend instance details from console

2b
Screenshot: webpage from both instances are loading in browser 

URLs:
http://ec2-65-1-135-84.ap-south-1.compute.amazonaws.com/
http://ec2-13-234-31-158.ap-south-1.compute.amazonaws.com/

3a
Screenshot: my public IP

3b
Screenshot: public IP logging in apache logs

3c
Screenshot: apache conf modified to log visitor IPs

4a
Screenshot: SSL certificate info 

URL: https://myapp.amaldeep.tech/

5a
Screenshot: cookies are enabled when enabled with load balancer generated cookie stickiness

6a
Screenshot: stickiness option will not be available when using TCP protocol in listeners. SSL can be enabled with secure TCP protocol in listeners. CLB is not able to attach x-forwarded-for http header when not using http/https protocol in listeners.  

Screenshot:
Screenshot:










# 25 nov 2022





webserver-docroot 
standard 
ia shift -disable 



ec2 
backend-ap-south-1a
backend-ap-south-1b


mount volume fstab 
mount -a 


screenshot 
df -h

URL: public dns of both ec2 

create clb 
shopping-app

listeners
443
80

add ssl 

health check health.html

connection draining 5sec

check http https 


shopping alias > clb 

URL: http://shopping.amaldeep.tech
https://shopping.amaldeep.tech


redirect http > https
check official doc 




Screenshot: efs attached to both instances

Public DNS of backend-ap-south-1a: http://ec2-52-66-213-71.ap-south-1.compute.amazonaws.com/
Public DNS of backend-ap-south-1b: http://ec2-65-2-57-11.ap-south-1.compute.amazonaws.com/ 

URLs: 
http://shopping.amaldeep.tech
https://shopping.amaldeep.tech










# 26 nov 2022




create launch conf
shopping-app-LC

ami id - 
sg 
key pair
userdata 


create autoscaling group 
shopping-app-ASG 

vpc 
subnet 

grace 120

tag 


load balancer 
shopping-app-CLB

http https 

do not select instance 

connection draining 5 sec 


edit asg 
add clb 
update


screenshot 
clb > instances 
asg > instance management 

URL: https:// 


edit asg 
min max > 4

clb > instances



edit asg > 
healthcheck > elb
update 

disable healthcheck file in 1 ec2 

screenshot 
ec2 console
asg > activity history 







URL: https://shopping.amaldeep.tech/
Screenshot: Instances in Autoscaling group with Desired capacity = 2
Screenshot: Instances in Load balancer


Screenshot: Instances in Autoscaling group with Desired capacity = 4
Screenshot: Instances in Load balancer


Screenshot: 1 Instance replaced when health check failed
Screenshot: activity history - failed ec2 replaced








# 28 nov 2022



create instance 
install website 



task 1 - created instance with sample data.

screenshot: instance details from console 
screenshot: website loading from instance 


task 2 - add the existing instance to an Auto Scaling Group
To achieve this - 
create an AMI: webserver-ami
create Launch configuration to launch instances identical to existing EC2: webserver-lc
create ASG: webservver-asg; min-0, max-1, desired-0 : to create an empty ASG and add existing EC2 to ASG; AZs- ap-south-1a, ap-south-1b; no load balancer; health check grace period: 120s; 
attach instance to ASG
update min value to 1 in ASG

screenshot: instance description - autoscaling group info
screenshot: ASG instance management tab
screenshot: ASG activity history


task 3 - set instance from ASG to standby mode

screenshot: error message when trying to lower the number of instances below min without opting for `Add a new instance to the Auto Scaling group to balance the load`

change min value to 0 and then move instance from ASG to standby mode 

screenshot: instance in standby mode

stop and start instance 
move instance from standby to `in service`

screenshot: instance is in service under ASG instance management 


task 4 - detach ec2 from ASG. Once detached, EC2 will not be managed by ASG. 

screenshot: instance management - no instances as of now

deleted ASG and LC, instance is still intact


task 5 - rename ec2 instance name to shopping-application-template 
create ami: shopping-application-version1-ami
create lc: shopping-application-version1-lc
create asg: shopping-application-asg; desired capacity - 2

screenshot: instance management under ASG
screenshot: instances in console 

create elb: shopping-application-elb
connection draining: 5sec
edit asg and attach load balancer 
alias the domain to load balancer 

screenshot: instances in load balancer 

URL: https://shopping.amaldeep.tech/


task 6 - update website code to next version - version 2.0 
create ami: shopping-application-version2-ami
create lc: shopping-application-version2-lc
update launch configuration in ASG 
updated tags in ASG for EC2 

proceeding with rolling update by terminating each instances with old version

screenshot: ec2 console 
screenshot: activity history from ASG 


task 7 - update code to version 3
create ami: shopping-application-version3-ami
create lc: shopping-application-version3-lc
update launch configuration in ASG 
update termination policy to oldest launch configuration
in clb, updata sticky session 
in asg, updated desired capacity to 4 
now there are 2 version2 instances and 2 version3 instances 

screenshot: ec2 console with 2 version2 and 2 version3 instances

downgrade desired capacity to 2 with updated termination policy 

screenshot: activity history from ASG
screenshot: instance management under ASG











# 29 nov 2022



#!/bin/bash

# Define hostname
#HN=frontend.amaldeep.tech

yum update -y
#hostnamectl set-hostname $HN
yum install git httpd -y 
amazon-linux-extras install php7.4  -y 
systemctl enable httpd.service
git clone https://github.com/amaldeeppj/webserver_sample_content.git /var/website/
cp -r  /var/website/*  /var/www/html/
chown -R apache:apache /var/www/html/*
systemctl restart httpd.service


<h1  style="text-decoration: underline;">Site Not Found</h1>



task 1 
create 4 ec2 instances 
unix.amaldeep.tech ap-south-1a
unix.amaldeep.tech ap-south-1b
linux.amaldeep.tech ap-south-1a
linux.amaldeep.tech ap-south-1b

screenshot: ec2 console 


task 2 
create 2 target groups 


<!-- create target group 
instances
tg-linux
healthcheck - http 
/
healthy treshold 2
name tag 
include 2 linux 

create target group 
instances
tg-unix
healthcheck - http 
/
healthy treshold 2
name tag 
include 2 unix -->


screenshot: target details of target group tg-linux
screenshot: target details of target group tg-unix 


task 3 

create application load balancer my-alb with default action is to forward requests to tg-linux 


default listener
tg-linux 


task 4 

in route53 add 3 records
linux.amaldeep.tech
unix.amaldeep.tech
windows.amaldeep.tech


task 5 
edit rules in ALB

alb > listener > edit rules
add rule for unix 
host header - forward to 

edit default rule 
return fixed response 
text/html
h1 

screenshot: Rules under alb listener

URLs: 
http://linux.amaldeep.tech
http://unix.amaldeep.tech
http://windows.amaldeep.tech



delete alb 
remove listener first, then alb
target
instance







# 01 dec 2022



task 1 
create ec2
shopping-application-version1
create ami 
shopping-application-ami-version1

update version 
create ami
shopping-application-ami-version2

update version 
create ami
shopping-application-ami-version3



task 2 

create launch template 
shopping-application
desription version 1 
add resource tags (ec2 vol, network interface) 
shopping-application-version1


task 3
create asg 
shopping-application-asg-version1
select version 1 
2 instances 
no tags 

screenshot: ec2 console - instances created by asg version 1 
screenshot: website loading from ec2
screenshot: instance management tab in ASG 


task 4 

create empty target group 
shopping-application-tg-version1


screenshot: empty target group version 1

attached target group in asg

screenshot: target group with ec2 instances from asg version 1


task 5
create alb 
shopping-application 
listener: https


rout53 

screenshot: rules under listener 443

edit rule to redirect to 443

screenshot: listeners under ALB
URL: http://shopping.amaldeep.tech/


task 6
create new version for launch template 
version 2 
tag application v2 

screenshot: versions created uner launch template



task 7 
create new asg 
shopping-application-asg-version1
version 2 
2 ec2 
no tags 


screenshot: ec2 console with newly created instances from asg version2
screenshot: instances under ASG version 2


task 8 
new empty target group 
upate asg 

screenshot: instances under target group version 2 



task 9 
asg > edit 443 rule > add tg and weitage 90:10

screesnhot: rules under listener 443 with 90percent traffic to version 1

upadte rule, weitage v2 










# 02 dec 2022





install nginx in ubuntu 



3 virtual hosts












# 03 dec 2022






http://home.amaldeep.tech/
http://order.amaldeep.tech/order/
http://cart.amaldeep.tech/cart/
http://product.amaldeep.tech/product


create 3 instances 
install httpd php






URL: http://shopping.amaldeep.tech/
URL: http://shopping.amaldeep.tech/result
Screenshot: Rules under 443 listener 
Screenshot: 



URL: http://linux.amaldeep.tech/
URL: http://unix.amaldeep.tech/ 
URL: http://windows.amaldeep.tech/


URL: http://nginx.amaldeep.tech/
Screenshot: backend load balancer conf file











# 06 dec 2022

create cmk 
create ec2; encrypt 
rename root vol 
create additional vol 
partition mount attach 
fstab
install apache 
pubish site 

create iam user; ec2 full access 
login as user 
reboot instance 
stop start instance 
add user to cmk
remove ec2user from cmk users 

create a new user and try to create ec2 with encryption
keys wont be able to see
add inline policy 
create ec2 with cmk
it will not boot 

create another instance 

encrypt unencrypted volume(create instance from snapshot)
change existing key - create snapshot, while building vol, use encryption and chose another key 



* once added user to cmk, able to start the instance 
* while creating new instance with key 
    user is not authorized to perform kms:list





https://797041117166.signin.aws.amazon.com/console




task completed;
insted of copying inline policy as JSON format, I have added it through visual editor by selecting necessary service, action and resources 









Screenshot: S3 bucket created 
Screenshot: object inside s3 bucket 
Screenshot: Image loading via URL


 aws s3 ls



 aws ec2 run-instances \
--image-id ami-074dc0a6f6c764218 \
--instance-type t2.micro \
--subnet-id subnet-051fcd75dbe892f9a \
--security-group-ids sg-057661ce90b13bf3d \
--key-name devops




aws ec2 create-vpc --cidr-block 10.0.1.0/16 --query Vpc.VpcId --output text

aws ec2 create-subnet --vpc-id vpc-08ec9b4b8f63cec1f --cidr-block 10.0.2.0/24

aws ec2 create-key-pair --key-name devops1 --query "KeyMaterial" --output text > devops1.pem

aws ec2 create-security-group --group-name SSHopen --description "Security group for SSH access" --vpc-id vpc-08ec9b4b8f63cec1f

sg-0ade723fecd7b5ae8



aws ec2 authorize-security-group-ingress --group-id sg-0ade723fecd7b5ae8 --protocol tcp --port 22 --cidr 0.0.0.0/0

 aws ec2 run-instances \
--image-id ami-074dc0a6f6c764218 \
--instance-type t2.micro \
--subnet-id subnet-0694affa899a28ad0 \
--security-group-ids sg-0ade723fecd7b5ae8 \
--key-name devops1


igw-094c9b82098b98a4c


aws ec2 attach-internet-gateway --vpc-id vpc-08ec9b4b8f63cec1f --internet-gateway-id igw-094c9b82098b98a4c

aws ec2 create-route-table --vpc-id vpc-08ec9b4b8f63cec1f --query RouteTable.RouteTableId --output text

rtb-0f0c639df0d0f9c6b

aws ec2 create-route --route-table-id rtb-0f0c639df0d0f9c6b --destination-cidr-block 0.0.0.0/0 --gateway-id igw-094c9b82098b98a4c

aws ec2 describe-route-tables --route-table-id rtb-0f0c639df0d0f9c6b


aws ec2 describe-subnets --filters "Name=vpc-id,Values=vpc-08ec9b4b8f63cec1f" --query "Subnets[*].{ID:SubnetId,CIDR:CidrBlock}"

 subnet-0694affa899a28ad0

aws ec2 associate-route-table  --subnet-id  subnet-0694affa899a28ad0 --route-table-id rtb-0f0c639df0d0f9c6b

aws ec2 modify-subnet-attribute --subnet-id subnet-0694affa899a28ad0 --map-public-ip-on-launch



aws ec2 describe-instances --instance-id i-052f0a6df66415606 --query "Reservations[*].Instances[*].{State:State.Name,Address:PublicIpAddress}"








# 08 dec 2022



create 2 buckets 
bucket-kevin.amaldeep.tech
bucket-john.amaldeep.tech

create 2 IAM users
john
AKIA3TE22I7XIQKQQSVX
AKIA3TE22I7XIQKQQSVX
FBz3boOA+6Bnwmy8MC5+JR9EbawTsfaZyTJTLT1Q

kevin
AKIA3TE22I7XMH526PXV
IegD2J60/RmRHj4U/OBZA0t5WbNrEgcx00//6VXj




env:program-s3


programatic 
no policy 

aws cli list profiles 
aws s3 ls john 
aws s3 ls kevin 

* 
Screenshot: created 2 buckets using cli, created IAM users from web console. Configured profiles for aws cli. Now, both IAM users are not given privileges to check s3 buckets. 


arn:aws:s3:::bucket-john.amaldeep.tech
arn:aws:s3:::bucket-kevin.amaldeep.tech


create IAM policy for aws s3 

john-s3-policy
kevin-s3-policy

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:*"],
      "Resource": [
                "arn:aws:s3:::bucket-john.amaldeep.tech",
                "arn:aws:s3:::bucket-john.amaldeep.tech/*"
                ]
    }
  ]
}

* 
Screenshot: kevin-s3-policy
Screenshot: john-s3-policy
Screenshot: bucket permissions and access from IAM profiles




*   
Screenshot: kevin-s3-policy updated
Screenshot: john-s3-policy updated
Screenshot: bucket permissions and access from IAM profiles






{
      "Effect": "Allow",
      "Action": ["s3:*"],
      "Resource": [ "*" ]
    }


* 

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::bucket-john.amaldeep.tech",
                "arn:aws:s3:::bucket-john.amaldeep.tech/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}










# 09 dec 2022




aws ec2 create-subnet --vpc-id vpc-2f09a348 --cidr-block 10.0.1.0/24

aws ec2 create-subnet --vpc-id vpc-05a615e3e484dedf8 --cidr-block 10.0.1.0/24 --output text --output text --query "Subnet.SubnetId"



create 2 buckets 
bucket-kevin.amaldeep.tech
bucket-john.amaldeep.tech

create 2 users 

kevin 
AKIA3TE22I7XM3N6HI2Y
a8PDtSJe1vPh15d7wS4eWoIVKn2Xwc+aGqLvF/ob

john
AKIA3TE22I7XBSJZZ66U
NJd3dq9TvEaCNWUqLpIzByvnGwuWgeJpY848w2QM



create bucket policies 


{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::797041117166:user/kevin"
      },
      "Action": "s3:*",
      "Resource": ["arn:aws:s3:::bucket-kevin.amaldeep.tech",
                   "arn:aws:s3:::bucket-kevin.amaldeep.tech/*"]
    }
  ]
}

* 
Screenshot: S3 buckets 
Screenshot: kevin IAM user 
Screenshot: john IAM user  
Screenshot: kevin-s3-policy
Screenshot: john-s3-policy
Screenshot: Accessing buckets 





create ec2 
load template 

http://s3website.amaldeep.tech/


create role 
images-s3

policy 
images-s3-policy


{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::s3bucket-website.amaldeep.tech",
                "arn:aws:s3:::s3bucket-website.amaldeep.tech/*"
            ]
        }
    ]
}



rewrite enable 

RewriteEngine On
RewriteRule ^/images/(.*)$  https://s3.ap-south-1.amazonaws.com/s3bucket-website.amaldeep.tech/$1 [L]


s3://s3bucket-website.amaldeep.tech/closeup-shot-newlywed-couple-sitting-bench.jpg
https://s3.ap-south-1.amazonaws.com/s3bucket-website.amaldeep.tech/closeup-shot-newlywed-couple-sitting-bench.jpg



Screenshot: error when trying to sync images to s3 bucket 
Screenshot: Role details 
Screenshot: Bucket operation working from EC2
Screenshot: S3 Bucket in console
Screenshot: EC2 metadata for IAM credentials 
URL: http://s3website.amaldeep.tech/
URL: https://s3.ap-south-1.amazonaws.com/s3bucket-website.amaldeep.tech/gallery/bearded-stylish-groom-suit-beautiful-blonde.jpg














12 dec 2022









create bucket 
mys3site.amaldeep.tech


upload site 



{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicRead",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion"
            ],
            "Resource": [
                "arn:aws:s3:::mys3site.amaldeep.tech/*"
            ]
        }
    ]
}





Screenshot: Objects under S3 bucket mys3site.amaldeep.tech
URL: http://mys3site.amaldeep.tech/
This URL will redirect to https; website is added to Cloudfront and enabled SSL. 




task 2 

create s3 bucket 
expiration.amaldeep.tech 
upload 3 files 

red.txt(tags project:zomato, env:dev )
blue.txt(tags project:zomato, env:prod )
green.txt

add 2 lifecycle rules 
expiration-1: filter project:zomato, env:dev delete after 1 days 
expiration-2: filter project:zomato, env:prod delete after 2 days


Screenshot: S3 bucket lifecycle expiration rule - expiration-1
Screenshot: S3 bucket lifecycle expiration rule - expiration-2



task 3 

lifecycle rule 
standard > after 100 >  standard ia > after 150 > one zone ia > 300 > delete (whole bucket)

Screenshot:  transition and expiration rule for the entire objects of the bucket


task 4

replication
mybucket-src.amaldeep.tech
mybucket-dst.amaldeep.tech

enable versioning in both
in src bucket enable replication based on tag 
project:zomato 

add tag while uploading 

add another object with same tag, right after upload modify tag
check if this object replicates 
* no, Replication status - failed

Screenshot: Source bucket rule
Screenshot: object in source bucket 
Screenshot: object in destination bucket







# 13 dec 2022



create 2 instances 
mumbai
europe

geolocation.amaldeep.tech

task1
Screenshot: A records for Routing policy - Geolocation
Screenshot: Geopeeker result of website loading from multiple locations
Screenshot: Website loading from India



task2 

healthcheck - server1 - tcp 80 
record failover.amaldeep.tech

task2
Screenshot: records for Routing policy - failover
turned off httpd in first server
Screenshot: dig results before and after 1st server failed



task3 

record - weighted.amaldeep.tech

task3 
Screenshot: DNS record for Routing policy - Weighted
Screenshot: curl result in `while loop`


task 4 

add healthcheck server2 
record multivalue.amaldeep.tech

task 4 
Screenshot: DNS record for Routing policy - Multivalue
turned off httpd in first server
Screenshot: dig result before and after 1st server failed
Screenshot: Route 53 healthcheck of both servers



Screenshot: dig
Screenshot: healthcheck












# 15 dec 2022



create 2 instances 
server-mumbai
server-paris

shopping.amaldeep.tech

Screenshot: A Records under Latency routing
Screenshot: Geopeeker result 




task 2 

create 2 hosted zones

mumbai.amaldeep.tech
paris.amaldeep.tech

create ns records

site.mumbai.
A record 

site.paris.
A record

URL: http://site.mumbai.amaldeep.tech/
URL: http://site.paris.amaldeep.tech/
Screenshot: NS records - mumbai.amaldeep.tech, paris.amaldeep.tech
Screenshot: A record - 	site.mumbai.amaldeep.tech
Screenshot: A record - site.paris.amaldeep.tech


task 3 

create 2 elastic ip
create target group 
create nlb 
assign elastic ip 


shopping. 


URL: http://shopping.amaldeep.tech
URL: https://shopping.amaldeep.tech
Screenshot: Elastic IPs
Screenshot: Dig result
Screenshot: My IP in apache logs 



Refer https://www.youtube.com/watch?v=8PtSAncWNwM

In the setup described in task 3 will not redirect http to https as NLB is working in network layer 4. This can be covered with either Cloudfront or `Application Load Balancer-type Target Group for Network Load Balancer`. The documentation is here: https://aws.amazon.com/blogs/networking-and-content-delivery/application-load-balancer-type-target-group-for-network-load-balancer/

Instances can be part of multiple target groups. But one target group can be associated with only one load balancer. So created another target group with same instances and associated it with an ALB. On top of that, created a new target group, and target is set to ALB instead of instances. Now we have 3 target groups. 2 of them are containing instances as targets and the other one has ALB as target. 
Created a new NLB with 2 listeners for ports 80 and 443. Listener on port 80 will forward requests to ALB and listener on port 443 will directly send requests to target group containing instances. 

In ALB, requests coming to port 80 will be redirected to port 443, which is not possible in NLB. This way we can channel the traffic through secure channel only. 

curl -IL http://shopping.amaldeep.tech/
HTTP/1.1 301 Moved Permanently
Server: awselb/2.0
Date: Thu, 15 Dec 2022 15:23:09 GMT
Content-Type: text/html
Content-Length: 134
Connection: keep-alive
Location: https://shopping.amaldeep.tech:443/

HTTP/1.1 200 OK
Date: Thu, 15 Dec 2022 15:23:09 GMT
Server: Apache/2.4.54 ()
X-Powered-By: PHP/7.4.33
Upgrade: h2,h2c
Connection: Upgrade
Content-Type: text/html; charset=UTF-8


```
http to https redirection
https://i-407.com/en/blog/tech/n7/
```




task 4 

create 2 IAM users
mumbai-admin
paris-admin

https://797041117166.signin.aws.amazon.com/console
mumbai-admin


list all hosted zones
manage records in 1 zone 


Screenshot: Error when accessing paris zone as mumbai admin
Screenshot: Error when accessing mumbai zone as paris admin
Screenshot: Added record under mumbai zone as mumbai-admin user
Screenshot: Added record under paris zone as paris-admin user 
Screenshot: Policy under mumbai-admin
Screenshot: Policy under paris-admin





{
"Version": "2012-10-17",
"Statement": [
{
"Effect": "Allow",
"Action": [
"route53:GetHostedZone",
"route53:ListResourceRecordSets",
"route53:ListHostedZones",
"route53:ChangeResourceRecordSets",
"route53:ListResourceRecordSets",
"route53:GetHostedZoneCount",
"route53:ListHostedZonesByName"
],
"Resource": "arn:aws:route53:::hostedzone/<id>"
},
{
"Effect": "Allow",
"Action": [
"route53:GetHostedZone",
"route53:ListResourceRecordSets",
"route53:ListHostedZones",
"route53:ChangeResourceRecordSets",
"route53:ListResourceRecordSets",
"route53:GetHostedZoneCount",
"route53:ListHostedZonesByName"
],
"Resource": "arn:aws:route53:::hostedzone/<id2>"
}
]
}




paris


{
"Version": "2012-10-17",
"Statement": [
{
"Effect": "Allow",
"Action": [
"route53:GetHostedZone",
"route53:ListResourceRecordSets",
"route53:ListHostedZones",
"route53:ListResourceRecordSets",
"route53:GetHostedZoneCount",
"route53:ListHostedZonesByName"
],
"Resource": "*"
},
{
"Effect": "Allow",
"Action": [
"route53:*", 
"route53domains:*"
],
"Resource": "arn:aws:route53:::hostedzone/Z00772591515N9KMI9NJR"
}
]
}



mumbai

{
"Version": "2012-10-17",
"Statement": [
{
"Effect": "Allow",
"Action": [
"route53:GetHostedZone",
"route53:ListResourceRecordSets",
"route53:ListHostedZones",
"route53:ListResourceRecordSets",
"route53:GetHostedZoneCount",
"route53:ListHostedZonesByName"
],
"Resource": "*"
},
{
"Effect": "Allow",
"Action": [
"route53:*", 
"route53domains:*"
],
"Resource": "arn:aws:route53:::hostedzone/Z06590001LBOJVSFCFGFZ"
}
]
}





{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:GetHostedZone",
                "route53:ListHostedZones",
                "route53:GetHostedZoneCount",
                "route53:ListHostedZonesByName"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "route53:*",
                "route53domains:*"
            ],
            "Resource": "arn:aws:route53:::hostedzone/Z00772591515N9KMI9NJR"
        }
    ]
}















# 16 dec 2022



Screenshot: CPU utilization in of instance in Cloudwatch > Metrics
Screenshot: Cloudwatch alarm in `in alarm` state











# 19 dec 2022

dynamic autoscaling group 


Screenshot: Dynamic scaling policies 
Screenshot: Cloudwatch Alarm
Screenshot: ASG activity 



create rds 

admin
olS3uC#7S15$

Screenshot: database console
Screenshot: Connection to RDS 












# 20 dec 2022






use company;

CREATE TABLE shopping( id int(5),name varchar(255), age int(3),email varchar(255));
INSERT INTO shopping(id, name,age,email) VALUES(101,"alex",30,"alex@gmail.com");
INSERT INTO shopping(id, name,age,email) VALUES(102,"don",20,"don@gmail.com");
INSERT INTO shopping(id, name,age,email) VALUES(103,"kevin",25,"kevin@gmail.com");
INSERT INTO shopping(id, name,age,email) VALUES(104,"devon",35,"devon@gmail.com");
INSERT INTO shopping(id, name,age,email) VALUES(105,"john",42,"john@gmail.com");
INSERT INTO shopping(id, name,age,email) VALUES(106,"ron",38,"ron@gmail.com");
INSERT INTO shopping(id, name,age,email) VALUES(107,"thomas",19,"thomas@gmail.com");
INSERT INTO shopping(id, name,age,email) VALUES(108,"fuji",34,"fuji@gmail.com");





create rds 
create read replica 


add routing53 shopping-read.amaldeep.tech



Screenshot: select * from all 
Screenshot: write from read 1 error 




Screenshot: Read operation from master DB; Write operation from master
Screenshot: Read operation from read-replica-1 ; Write operation from read-replica-1
Screenshot: Read operation from read-replica-2 ; Write operation from read-replica-2
Screenshot: Dig result of read replica load balancing domain > getting different values in each query since routing is set to weighted 
Screenshot: Read operation from load balanced read replicas    








# 21 dec 2022 

terraform --version 


Screenshot: Terraform installed in EC2 instance
Screenshot: Terraform installed in PC 


terraform init 

Screenshot: Terrafotm conf files after terraform init

Screenshot: terraform plan output
Screenshot: terraform apply output
Screenshot: terraform public IP from terraform.tfstate file



remove one sg 

terraform plan 
terrafoem apply 

Screenshot: Security groups after removing one rule
Screenshot: terraform apply 
Screenshot: Security groups after re-apply (terraform configuration is idempotent)






# 22 dec 2022


task 1 

remove tfstate file 

key gen mykey 

Task 1 
Screenshot: Key generation 


Task 2
Screenshot: inputs.tf
Screenshot: provider.tf 
Screenshot: Key in console 


Task 3 
Screenshot: Security groups 



Task 4 
Screenshot: Security group rules under instance 
Screenshot: terraform state list 
Screenshot: Output 



public ip
dns 
ssh link 
ec2 id 
ec2 arn 







# 23 dec 2022



add default tags 


Screenshot: changes to apply after adding default_tags under provider 
Screenshot: tags updated using default tags 

create common tags; type map 

Screenshot: Variables not allowed inside another variable
Screenshot: Variables declared through local values(Local values are like a function's temporary local variables)

modify security group name 
add lifecycle 
Screenshot: Security group name updated by enabling the meta-argument create_before_destroy in lifecycle block

update security group description 
add name prefix for security group name
Screenhot: Security group description (updated with the help of meta-argument create_before_destroy and name_prefix argument for security group) 






# 27 dec 2022



print az 1 and az 2 of mumbai 
print az 1 and az 2 of virginia 

cidr block of first 3 subnets subnets 

https://paste.ee/p/fJwWb

update code pastebin 





# 28 dec 2022

terraform state list 

updated code by replacing length function with local variable.






i-0a22ecb739d35c798



Instance id of version1: i-0c711b3430f8e6a58
Instance id of version2: i-0a0da1418b997c4ba



URL in output 

code: https://paste.ee/p/vEGcB
EC2 instances in console 
Instance id of version1: i-0c711b3430f8e6a58
Instance id of version2: i-0a0da1418b997c4ba