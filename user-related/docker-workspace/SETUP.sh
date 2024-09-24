#!/bin/bash

#
# @author Meetesh Kalpesh Mehta
# @email meeteshmehta@cse.iitb.ac.in
# @create date 2024-09-24 23:28:06
# @modify date 2024-09-24 23:28:59
#

#
# Utility Functions
# ===========================================================================
# 
# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BRed='\033[1;31m'         # Bold Red
BGreen='\033[1;32m'       # Bold Green
BYellow='\033[1;33m'      # Bold Yellow
BBlue='\033[1;34m'        # Bold Blue
BPurple='\033[1;35m'      # Bold Purple
BCyan='\033[1;36m'        # Bold Cyan
BWhite='\033[1;37m'       # Bold White

# Functions for colored output
color_red() {
  echo -e "${Red}$*${Color_Off}"
}

color_green() {
  echo -e "${Green}$*${Color_Off}"
}

color_yellow() {
  echo -e "${Yellow}$*${Color_Off}"
}

color_blue() {
  echo -e "${Blue}$*${Color_Off}"
}

color_purple() {
  echo -e "${Purple}$*${Color_Off}"
}

color_cyan() {
  echo -e "${Cyan}$*${Color_Off}"
}

color_white() {
  echo -e "${White}$*${Color_Off}"
}

# Bold versions
bold_red() {
  echo -e "${BRed}$*${Color_Off}"
}

bold_green() {
  echo -e "${BGreen}$*${Color_Off}"
}

bold_yellow() {
  echo -e "${BYellow}$*${Color_Off}"
}

bold_blue() {
  echo -e "${BBlue}$*${Color_Off}"
}

bold_purple() {
  echo -e "${BPurple}$*${Color_Off}"
}

bold_cyan() {
  echo -e "${BCyan}$*${Color_Off}"
}

bold_white() {
  echo -e "${BWhite}$*${Color_Off}"
}

# Write content to a file
generateFile () {
  echo "$1" > $2
  bold_green "[Generated $2]"
}

#
# Globals
# ===========================================================================
# 

timestamp=`date`
uname=$USER
gname=$USER
uid=`id -u`
gid=`id -g`
homedir="/home/$USER"
wddir="/home/$USER/docker-wd"
image_name="$USER-wd"
container_name="$USER-wd"
dockerwd="$homedir/wd"
dockerindocker="n"
packagesToInstall="sudo build-essential git curl wget"
sshdir="/home/$USER/.ssh"
dockersshdir="/home/$USER/.ssh"

baseDockerImage=""

echo ""
bold_green "[Your docker image will be named: '$uname-wd']"

#
# Generating Config
# ===========================================================================
# 
#
# 1. Password
#
echo ""
read -p "(1) Password to use inside the container: " passwd
if [[ "$passwd" == "" ]]; then
  color_red "Enter a valid password to proceed!" 
  exit 1
fi

#
# 2. Ubuntu version
#
echo ""
echo "(2) Select your Ubuntu version:"
color_yellow "    1) 20.04"
color_yellow "    2) 22.04 (default)"
color_yellow "    3) 24.04"
read -p "Enter your choice (1-3, default is 2): " choice
case "$choice" in
  1)
    regularSource="ubuntu:20.04"
    dindSource="cruizba/ubuntu-dind:focal-latest"
    ;;
  2 | "")
    regularSource="ubuntu:22.04"
    dindSource="cruizba/ubuntu-dind:jammy-latest"
    ;;
  3)
    regularSource="ubuntu:24.04"
    dindSource="cruizba/ubuntu-dind:noble-latest"
    ;;
  *)
    color_red "Invalid selection '$choice'. Exiting."
    exit 1
    ;;
esac

#
# 3. Selecting working directory
#
echo ""
echo "(3) Select working directory"
color_yellow "Your local working directory (default: '$wddir') will be mirrored inside the docker container at '$dockerwd'"
bold_cyan "  $wddir <--> $dockerwd"
read -p "Enter a different path or leave it blank (default: '$wddir'):" choice
if [[ "$choice" == "" ]]; then
  wddir=$wddir
else
  wddir=$choice
fi

mkdir -p $wddir
if [ $? -eq 0 ]; then
  bold_cyan "  $wddir <--> $dockerwd"
else
  bold_red "Failed to create directory!"
  exit 1
fi

#
# 4. Docker in Docker
#
echo ""
read -p "(4) Do you want to use docker inside docker [y/n]?" confirmation
if [[ "$confirmation" == "y" ]]; then
  dockerindocker="y"
  baseDockerImage=$dindSource
elif [[ "$confirmation" == "n" ]]; then
  dockerindocker="n"
  baseDockerImage=$regularSource
else
  color_red "Invalid Selection '$confirmation', exiting!!"
  exit 1
fi

#
# 5. Mirroring .ssh
# 

echo ""
echo "(5) Mirroring .ssh folder (this is useful for things like git access)"
color_yellow "Your local .ssh dir (default: '$sshdir') will be mirrored inside the docker container at '$dockersshdir'"
bold_cyan "  $sshdir <--> $dockersshdir"
read -p "Enter a different path or leave it blank (default: '$sshdir'):" choice
if [[ "$choice" == "" ]]; then
  sshdir=$sshdir
else
  sshdir=$choice
fi

mkdir -p $sshdir
if [ $? -eq 0 ]; then
  bold_cyan "  $sshdir <--> $dockersshdir"
else
  bold_red "$sshdir is invalid, check the path!"
  exit 1
fi

#
# Final Confirmation
# 
echo ""
echo ""
bold_green "Final Config"
bold_cyan "  baseImage        : '$baseDockerImage'"
bold_cyan "  username         : '$uname'"
bold_cyan "  password         : '$passwd'"
bold_cyan "  local-wd         : '$wddir'"
bold_cyan "  container-wd     : '$dockerwd'"
bold_cyan "  docker-in-docker : '$dockerindocker'"
bold_cyan "  default-packages : '$packagesToInstall'"
bold_cyan "  ssh directory    : '$sshdir'"
echo ""
echo ""

read -p "Do you want to proceed [y/n]?" confirmation
if [[ "$confirmation" == "y" ]]; then
  color_yellow "[Generate files...]"
elif [[ "$confirmation" == "n" ]]; then
  color_red "Exiting!!"
  exit 1
else
  color_red "Invalid Selection '$confirmation', exiting!!"
  exit 1
fi



#
# Generating files
# ===========================================================================
# 
#
# 1. Generate Dockerfile
# 
data=$(cat <<EOF
#
# Generated: $timestamp
#
# Final Config
#   baseImage        : '$baseDockerImage'
#   username         : '$uname'
#   password         : '$passwd'
#   local-wd         : '$wddir'
#   container-wd     : '$dockerwd'
#   docker-in-docker : '$dockerindocker'
#   default-packages : '$packagesToInstall'
#   ssh directory    : '$sshdir'
#

# Use an official base image (e.g., Ubuntu)
FROM $baseDockerImage

# Set environment variables
# "id -u" and "id -g" give the uid and gid
ENV USERNAME=$uname
ENV GROUPNAME=$gname
ENV UID=$uid 
ENV GID=$gid
ENV HOME_DIR=$homedir
ENV PASSWORD=$passwd

# Update package list and install sudo
RUN apt-get update && apt-get install -y $packagesToInstall

# Create a new group with the specified GID
RUN groupadd -g $gid $gname

# Create the home directory
RUN mkdir -p $homedir && chown $uid:$gid $homedir

# Create a new user with the specified UID and home directory, and add to the group
RUN useradd -m -d $homedir -u $uid -g $gid -s /bin/bash $uname

# Set the default password for the new user
RUN echo "$uname:$passwd" | chpasswd

# Add the new user to the sudo group
RUN usermod -aG sudo $uname

# Set the HOME environment variable
ENV HOME=$homedir

# Switch to the new user
USER $uname

# Switch to the home directory
WORKDIR $homedir

# copy the skeletion .bashrc for environment variable setup
RUN cp /etc/skel/.bashrc $homedir/.bashrc
EOF
)
generateFile "$data" "Dockerfile"

#
# 2. Generate commit.sh
# 
data=$(cat <<EOF
#!/bin/bash

#
# Generated: $timestamp
#

docker commit $container_name $image_name
EOF
)
generateFile "$data" "commit.sh"

#
# 3. Generate start.sh
# 
data=$(cat <<EOF
#!/bin/bash

#
# Generated: $timestamp
#

if [ "\$( docker container inspect -f '{{.State.Running}}' $container_name )" = "true" ]; then 
	echo "Container already running..."
	docker container list
else
	# If is is stopped remove it
	docker remove $container_name &>/dev/null
	# Run the Docker container with the volume mount and set appropriate permissions
	docker run -it --privileged --cgroup-parent=/docker --rm -d --name $container_name \
			--mount type=bind,source=$wddir,target=$dockerwd \
			--mount type=bind,source=/home/$USER/.ssh,target=/home/$USER/.ssh \
    		$image_name
	echo "Started container"
	docker container list
fi
EOF
)
generateFile "$data" "start.sh"


#
# 4. Generate stop.sh
# 
data=$(cat <<EOF
#!/bin/bash

#
# Generated: $timestamp
#

docker stop $container_name
docker container prune
EOF
)
generateFile "$data" "stop.sh"

#
# 5. Generate restart.sh
# 
data=$(cat <<EOF
#!/bin/bash

#
# Generated: $timestamp
#

bash stop.sh
bash start.sh

EOF
)
generateFile "$data" "restart.sh"

#
# 6. Generate startIsolated.sh
# 
data=$(cat <<EOF
#!/bin/bash

#
# Generated: $timestamp
#

# Display available cgroups
echo "Available cgroups:"
echo "Name | Subs"
cset_output=\$(cset set | awk '{if (NR>2 && \$7 == 0) print \$1, "| ", \$6}' | sort)
echo "\$cset_output"

# Prompt user to select a cgroup
read -p "Enter cgroup name: " cgroup

# Check if the input is empty
if [[ -z "\$cgroup" ]]; then
	echo "Invalid cgroup: \$cgroup"
  exit 1
fi

# Validate the cgroup name against the available cgroups
if echo "\$cset_output" | grep -qw "\$cgroup"; then
  echo "Selected cgroup: \$cgroup"
else
  echo "Invalid cgroup: \$cgroup"
  exit 1
fi

if [ "\$( docker container inspect -f '{{.State.Running}}' $container_name )" = "true" ]; then 
	echo "Container already running..."
	docker container list
else
	# If is is stopped remove it
	docker remove $container_name &>/dev/null
	# Run the Docker container with the volume mount and set appropriate permissions
	docker run -it --privileged --cgroup-parent=/\$cgroup  --rm -d --name $container_name \
			--mount type=bind,source=$wddir,target=$dockerwd \
			--mount type=bind,source=/home/$USER/.ssh,target=/home/$USER/.ssh \
    		$image_name
	echo "Started container"
	docker container list
fi
EOF
)
generateFile "$data" "startIsolated.sh"

#
# 7. Generate restartIsolated.sh
# 
data=$(cat <<EOF
#!/bin/bash

#
# Generated: $timestamp
#

bash stop.sh
bash startIsolated.sh

EOF
)
generateFile "$data" "restartIsolated.sh"

#
# Building docker container
# ===========================================================================
# 
read -p "All files generated, build docker container [y/n]?" confirmation
if [[ "$confirmation" == "y" ]]; then
  docker build -t $image_name .
else
  bold_red "Exiting!!"
  color_yellow "You can build the docker image by running:"
  color_blue "docker build -t $image_name ."
  exit 1
fi
