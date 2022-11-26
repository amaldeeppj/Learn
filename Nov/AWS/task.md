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

