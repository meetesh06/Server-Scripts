# Internet Auto Login

This script can be used to keep the interned logged in at all times.


## Usage

1. Copy the `internet.sh` file into your home directory.

2. Update the `username` and `ssoToken` variables in the `internet.sh`.

```bash
#!/bin/bash
date

username="your_ldap_id"
ssoToken="your_SSO_token"
...
```

3. Add `internet.sh` to cron tab to run every 30 minutes. The following command can be used to access the cron tab.

```bash
crontab -e
```

Inside the crontab, we will add a new job which runs every 30 minutes (see the last line). 
Also, make sure you replace `YOUR_USERNAME` with your actual username.

```bash
# Edit this file to introduce tasks to be run by cron.
# 
# Each task to run has to be defined through a single line
# indicating with different fields when the task will be run
# and what command to run for the task
# 
# To define the time you can provide concrete values for
# minute (m), hour (h), day of month (dom), month (mon),
# and day of week (dow) or use '*' in these fields (for 'any').
# 
# Notice that tasks will be started based on the cron's system
# daemon's notion of time and timezones.
# 
# Output of the crontab jobs (including errors) is sent through
# email to the user the crontab file belongs to (unless redirected).
# 
# For example, you can run a backup of all your user accounts
# at 5 a.m every week with:
# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
# 
# For more information see the manual pages of crontab(5) and cron(8)
# 
# m h  dom mon dow   command
*/30 * * * * /home/YOUR_USERNAME/internet.sh | tee -a /home/YOUR_USERNAME/internetLogin.log
```


### Notes

Logs will be saved to `/home/YOUR_USERNAME/internetLogin.log`.