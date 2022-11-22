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

