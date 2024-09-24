#!/bin/bash

#
# @author Meetesh Kalpesh Mehta
# @email meeteshmehta@cse.iitb.ac.in
# @create date 2024-09-24 23:29:28
# @modify date 2024-09-24 23:29:19
#

date

username=""
ssoToken=""

curl --location-trusted -u $username:$ssoToken "https://internet-sso.iitb.ac.in/login.php" >/dev/null
if curl -s --head --request GET --max-time 3 http://www.google.com | grep "200 OK" > /dev/null
then
	echo "Internet Connected"
else
	echo "No Internet!!"
fi
echo "=== X === X ==="
