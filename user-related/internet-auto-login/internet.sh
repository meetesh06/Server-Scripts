#!/bin/bash
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
