#!/bin/bash


yum install httpd php -y

cat <<EOF > /var/www/html/index.php
<?php
\$output = shell_exec('echo $HOSTNAME');
echo "<h1><center><pre>\$output</pre></center></h1>";
echo "<h1><center> version 2 </center></h1>"
?>
EOF

systemctl restart httpd.service
systemctl enable httpd.service