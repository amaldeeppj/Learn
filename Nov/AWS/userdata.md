# Webserver

#!/bin/bash

yum update -y
hostnamectl set-hostname frontend.amaldeep.tech
yum install git httpd -y 
amazon-linux-extras install php7.4  -y 
systemctl enable httpd.service
systemctl restart httpd.service


==================================================================


# DB server   

#!/bin/bash

yum update -y
hostnamectl set-hostname backend.amaldeep.tech
yum install mariadb-server -y 
systemctl enable mariadb.service
systemctl restart mariadb.service




==================================================================



# Wordpress   


#!/bin/bash


hostnamectl set-hostname frontend.amaldeep.tech
yum update -y
yum install httpd mariadb-server -y 
amazon-linux-extras install php7.4  -y 
systemctl enable httpd.service
systemctl restart httpd.service
systemctl enable mariadb.service
systemctl restart mariadb.service
wget https://wordpress.org/latest.zip -P /var/www/html/
unzip /var/www/html/latest.zip  -d /var/www/html/
mv /var/www/html/wordpress/* /var/www/html/ 
mv /var/www/html/wp-config-sample.php  /var/www/html/wp-config.php
chown -R apache.apache /var/www/html/  

#Make sure that NOBODY can access the server without a password
mysql -e "UPDATE mysql.user SET Password = PASSWORD('Tech@123') WHERE User = 'root'"

#Kill the anonymous users
mysql -e "DROP USER ''@'localhost'"

#Because our hostname varies we'll use some Bash magic here.
mysql -e "DROP USER ''@'$(hostname)'"

#Kill off the demo database
mysql -e "DROP DATABASE test"

#Wordpress db and user creation 
mysql -e "create database wordpress"
mysql -e "create user 'wpuser'@'localhost' identified by 'Tech@123'"
mysql -e "grant all privileges on wordpress.* to 'wpuser'@'localhost'"

#Make our changes take effect
mysql -e "FLUSH PRIVILEGES"

#Any subsequent tries to run queries this way will get access denied because lack of usr/pwd param


#update wp-config 
sed -i 's/database_name_here/wordpress/' /var/www/html/wp-config.php
sed -i 's/username_here/wpuser/' /var/www/html/wp-config.php
sed -i 's/password_here/Tech@123/' /var/www/html/wp-config.php
chown -R apache.apache /var/www/html/







==================================================================


# Docker 


yum update -y
hostnamectl set-hostname docker.amaldeep.tech
curl -fsSL https://get.docker.com -o /var/tmp/get-docker.sh
sh /var/tmp/get-docker.sh
usermod -aG docker ec2-user




# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

