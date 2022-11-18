### 18 nov 22


__Task 1__

Created an instance and installed apache. In security group - test-sg, allowed all traffic for both inbound and outbound.  
Screenshot 1: Security group details
Screenshot 2: Website loading from the instance 

Removed outbound rules from the security group.
Screenshot 3: Security group details
Screenshot 4: Website still loading from the instance 


Created NACL - my-NACL. Associated new NACL with the subnet including existing EC2 instance. 
Screenshot 5: my-NACL -> subnet association
Screenshot 6: EC2 details including subnet info

Added rule #100 in my-NACL outbound section to allow all traffic. 
Added rule #200 in my-NACL inbound section to allow SSH from my ip.
Added rule #300 in my-NACL inbound section to allow HTTP from my ip.
Screenshot 7: my-NACL > inbound section 

Deleted my-NACL. The subnet is now associated with the default NACL. 
