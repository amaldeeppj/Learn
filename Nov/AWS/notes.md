aws VPC

https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Scenario2.html

https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html

https://varunmanik1.medium.com/how-to-create-aws-vpc-in-10-steps-less-than-5-min-a49ac12064aa




lost keypair:
https://aws.amazon.com/premiumsupport/knowledge-center/ec2-user-account-cloud-init-user-data/





configure nginx as load balancer 
nginx will be listening in port 80

round robin, weighted algorithms are supported    

> healthcheck is also possible  

ssl termination (ssl off loading) available 
ssl will be installed at load balancer level 


> end to end encryption : The connection between user and load balancer will be encrypted with SSL. As well as connection between load balancer and backend server will be encrypted with SSL.    

> sticky session: load balancer will be directing the user to the same server as long as the session is valid    

> redis can be used to keep the session data and can avoid sticky sessoin for better load balancing  

webserver will be generating a session for each user login 
cookie: file contains session data  


hostinger 
redis, redis cluster 



linux virtual server > kernel level load balancing 



weighted > same conf 
public ip not needed
healthcheck protocol only http?





# 23 nov 2022



http request : data generated by browser
google http request headers 
data as key value pairs 
host: hostname
path: /(for default page) eg: /wp-contents/upload/etc
user-agent: client host and browser details 


tcp/ip stack in side kernel 
socket 
port
tcp packet : data generated by app > http request inside this tcp packet
client side port range
tcp vs udp 

contents of tcp packet 
source port 
destination port 
since the packet contains http header, it will direct the packet to port 80 in destination

ip packet encapsulate tcp/udp packet
ip packet contains 
source ip 
destiantion ip (got destination ip from dns)


how client machine identifies dns server ip?

ip packet is encapsulated by mac frame

when entering a wesite name in browser, the client machine first connect to 53 for name resolution 


netstat -ntlp : tcp 
netstat -nulp : udp

osi layer 
app layer : layer 7

check layers of clb, alb

layer 4 contains source port and dest port details 
layer 3 contains ip 
layer 2 mac 


router works in layer 3 
clb works in layer 4 
firewall works in layer 3 and layer 4 



> if clb working in layer 4 how it finds destination ip?

layer 7 data depends and varies between applications 
nacl and security groups work in layer 3 and 4

layer 3 and 4 have a predefined structre
layer 7 does not have a constant structure 
most layer 7 firewalls will be working in http only (http requests are easiest to read)


ip based virtual hosting vs name based 

httpd reads host field from http request to identify the virtual host 


how browser works 


httpd can block wget requests
wget can set useragent to avoid this 

clb cannot handle layer 7 data (cannot do name based resolution)
alb works in layer 7 (can read http data)


osi layer model vs tcp/ip layer model 


nlb and clb are in layer 4 ( clb also works in layer 7 http) 
alb in layer 7


clb may have more than 1 public ip 


if clb working in http layer 7, it can read and modify http packet (clb: http: 80 | instance : 80) :: this is why backend showing clb ip in logs 
if clb is in tcp mode, (clb : tcp: 80) clb cannot read/modify layer 7 data 
clb will encapsulate http header in tcp packet and will send to backend 

client request > igw > clb(private ip) > backend



name resolution in detail 
how process generates 
3way handshake 



how chown works 
how routers work
how modems work 
how switches work 


> does load balancer has route table entries?

clb can be multiple instances

alb is modified version of nginx 


dig lb dns 
lb can be already dns load balanced 
clb could be creating each instance in each subnet 



>>>
how clb identifies 
sticky session
session manager 
server load (ensures that no one server is overworked

https://www.nginx.com/resources/glossary/load-balancing/
https://avinetworks.com/what-is-load-balancing/







# 24 nov 2022








ec2 > images and templates > launch more like this

tcp health check will be faster 
http health check will be more reliable 


load balancer instances will be assigned per subnet 


route53 has multivalue answer
health check can be enabled for ips enabled in multivalue instance



log file log format edit



> modems are working in network layer, how do they replace source ip attached from brownser 

how xforward works?


in http mode clb will do this:
source ip from layer4 added as xforwarded field in layer 7 data 

we can only add xforwadedfor when using listeners with http. switching to tcp, the xforwarded tag will not be providing any data in the webserver logs. 











# 25 nov 2022



* Elastic file system (EFS)

single point of failiure  
io rates 
what if multiple writes are coming to same file 


cannot mention size while creating 
size of efs is 8 exabite


> efs vs ebs
ebs payment for size 
efs payment for usage



> in case mount issue, check:
subnet access
sg 2049







# 26 nov 2022



* Auto Scaling

> Auto Scaling Group    
group of ec2 instances
ec2 instances are created by launch configuration 
auto scaling group can have 1 launch conf at a time 

> Launch Configuration 
instructions to create ec2
launch configurations are immutable; cannot edit
we have to create a new LC and replace it in ASG



alias vs cname

in aws route53, adding a domain as alias to a service will take only 1 dns query to fetch the IP, whereas addin the domain as cname for the service will need 2 dns queries to get the IP address








# 28 nov 2022

> cannot make autoscaling group without ec2 or launch configuration or launch template

autoscaling group does not have payment but ec2 instances have

> cannot add ec2 instances to ALB directly, need to added to target group first 


* Adding existing ec2 instance to autoscaling group 

    * create ami from exinsting ec2 instance 
    * create a launch conf to create ec2 from the ami
    * add the existing ec2 to ASG (desired and min capacity should be 0 when creating ASG, max should be number of instances are going to add to ASG [`creating emplty instance`])
    * instance > instance settings > attach to asg 
    * update min and desired, instances will come up even though the min is 0, once an instance is attached

    * or create an asg and max should be higher than desired, then attach the existing ec2 to asg


> fleet management aka static ASG

disired - number of instances to launch when deploying ASG 



> Standby mode

the instance state will not be monitored by ASG 
use standby to update existing server in ASG 
update min values as needed 


> detach instance from ec2

asg is not needed - set min to 0 if and detach instances from the ASG



> while creating an ASG, create an AMI with everything needed to deploy when launching instance from it. (edit ssl redirection)
    `create new AMI for newer versions of application`


> launch configuration is immutable - cannot edit 
 create a copy instead and make necessary changes in it
 update ASG with new launch conf, update tags as well
 delete instances/ detach instance to update the version of application
  

 `instance refresh`










# 30 nov 2022




* autoscaling termination policy

will execute selected policies from left to right 
set default policy at the end 

* oldest instance 
* newest instance
* oldest launch configuration
    helpful when upgrading the version 
* closest to next hour 
    terminate the instances that are closer to the next billing hour; helps reduce cost 
* default 
    useful when there are multiple scaling policies for the auto scaling group; will select the instances from the AZs with most instances running > then will be checking for instances with oldest configuration > then will check for instances closest to next billing hour;  

even if we have deployed termination policy, aws will balance the instances in AZs/subnets


* instance protection
    protects instances from termination while scale in
    newly launched instances will be protected from scale in by default 
    can be applied to an instance or an entire ASG 








# 01 dec 2022



* Launch template

    launch conf can only can be used with ASG 
    Launch template supports versioning
    can be used to launch instances 



create ami
create launch template
create asg using launch template 
create empty target group 
attach target group under alb section in ASG 
create alb and add target groups
    > listener port 443 only 
    > add new listener for port 80 > default action > redirect > https > 443

> for version 2
create new version for existing launch template 
create another asg using launch template v2
create empty target group
attach target group under alb section in asg v2
edit 443 listener in alb
 > add target group for existing domain 
 > mentiopn weitage
 > add stickiness(optional)



in alb http can be redirected to https at load balancer. whereas in clb, http > https redirect has to be done at server


when using default launch template in asg, and we have updated defalt version of launch template, the version of ec2 instances launched by asg will be changed

asg will fail to create ec2 if no launch template (if deleted launch template)








# 02 dec 2022



Horizontal scaling - no of servers
Vertical scaling - spec of server 

microservices and monolithic archetecture

query string 










# 05 dec 2022



ssl session key generation 
symmetric vs assymtric 
hash, checksum 



* KMS 
    key generation and management 
    * 2 types of keys 
        * AMK - amazon managed keys(free)
        * CMK - customer managed keys
    key will be used to encrypt the ec2(resource) by the hypervisor 
    hypervisor will contact KMS for the key 
    KMS will create a random value `data key` and will encrypt with CMK -> encrypted `data key`
    KMS will pass the `data key` and encrypted `data key` to the hypervisor 
    hypervisor will keep the encrypted `data key` as metadata inside created volume 
    hypervisor will store the `data key` given by KMS 
    hypervisor will encrypt the data inside volume with `data key` on the fly(while transferring data)
    hypervisor will decrypt the data inside volume with `data key` on the fly(while transferring data)
    `data key` will be removed from hypervisor while stopping the ec2, but ebs volume will remain there
    while starting the ec2, hypervisor will create the instance(most probably in a different node)
    but, will attach the old volume to new instance 
    but the `data key` is not available to decrypt the existing volume 
    hypervisor will fetch the encrypted `data key` from the volume and will send it to KMS
    the volume cannot be decrypted if CMK is removed from KMS 
    if CMK is present and IAM user has permission, KMS will decrypt the encrypted `data key` with CMK and will send it back to the hypervisor
    encryption and decryptin is symmetric, key is data key 
    
    while migrating a decrypted volume to a different region, we need to chose a key at the destination. 
    the data will be decrypted from source and send to destination
    at destination, the volume will be again encrypted with new key selected 


    secret 0 




    how its decrypted? - symmetric?












# 07 dec 2022




https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-instances.html
https://docs.aws.amazon.com/vpc/latest/userguide/vpc-subnets-commands-example.html












# 09 dec 2022










# 13 dec 2022







# 16 dec 2022

Cloudwatch cannot read memory utilization by default 







# 19 dec 2022


rds proxy 





rds load balancing 










# 26 dec 2022




# NAT gateway 
A public NAT gateway can be used to connect to internet from private subnets. 
The public NAT gateway needs an elastic IP and has to be in a public subnet. 
https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html






doubts: 

1) Internet Gateways can be imported using the id, e.g.,
   $ terraform import aws_internet_gateway.gw igw-c0a643a9

2) how to modfy local routing 

