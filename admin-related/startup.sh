#!/bin/bash

#
# Pre-setup required for this script to work
# 
# 1. Install cpuset
# sudo apt install cpuset
#
# 2. Disable unified cores and reboot
# sudo su
# echo 'GRUB_CMDLINE_LINUX=systemd.unified_cgroup_hierarchy=false' > /etc/default/grub.d/cgroup.cfg
# sudo reboot now
#

LOGPATH="/home/admin/startup.log"

echo "[startup.sh] Starting Cron..." &>> $LOGPATH
date &>> $LOGPATH

# 1. Disable address space randomization (https://llvm.org/docs/Benchmarking.html)
sudo sh -c "echo 0 > /proc/sys/kernel/randomize_va_space"

# 2. Log in to Internet
# curl --location-trusted -u USERNAME:SSO-TOKEN "https://internet-sso.iitb.ac.in/login.php" > /dev/null

# 3. Create the sets (run every time from here post a reboot)
sudo cset set -c 0-63 -s system
sudo cset set -c 64-95 -s c32_1
sudo cset set -c 96-127 -s c32_2
sudo cset set -c 128-143 -s c16_1
sudo cset set -c 144-159 -s c16_2
sudo cset set -c 160-175 -s c16_3
sudo cset set -c 176-191 -s c16_4
sudo cset set -c 192-207 -s c16_5
sudo cset set -c 208-223 -s c16_6
sudo cset set -c 224-239 -s c16_7
sudo cset set -c 240-255 -s c16_8
sudo cset set -c 0-63 -s docker

# 5. Move system processes to the "system" set
sudo cset proc -m -k -f root -t system

# 6. List all the sets
sudo cset set &>> $LOGPATH
cat /proc/sys/kernel/randomize_va_space &>> $LOGPATH
