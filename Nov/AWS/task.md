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


