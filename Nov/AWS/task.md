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
