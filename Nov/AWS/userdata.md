Webserver

#!/bin/bash

hostnamectl set-hostname frontend.zomato.com
yum install httpd -y 
amazon-linux-extras install php7.4  -y 
systemctl enable httpd.service
systemctl restart httpd.service


===================================================================
DB server

#!/bin/bash

hostnamectl set-hostname backend.zomato.com
yum install mariadb-server -y 
systemctl enable mariadb.service
systemctl restart mariadb.service