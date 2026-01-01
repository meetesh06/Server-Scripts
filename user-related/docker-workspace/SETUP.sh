#!/bin/bash

# 1. Ubuntu Version Selection
echo "Select Ubuntu Version:"
echo "a. 20.04"
echo "b. 22.04"
echo "c. 24.04"
echo "d. 20.04 (docker in docker)"
echo "e. 22.04 (docker in docker)"
echo "f. 24.04 (docker in docker)"
read -p "Selection (a-f): " versionOpt

case $versionOpt in
    a) dockerImage="ubuntu:20.04" ;;
    b) dockerImage="ubuntu:22.04" ;;
    c) dockerImage="ubuntu:24.04" ;;
    d) dockerImage="cruizba/ubuntu-dind:focal-latest" ;;
    e) dockerImage="cruizba/ubuntu-dind:jammy-latest" ;;
    f) dockerImage="cruizba/ubuntu-dind:noble-latest" ;;
    *) echo "Invalid selection"; exit 1 ;;
esac

# 2. Working Directory
defaultWD="$HOME/docker-wd"
read -p "Working directory [Default: $defaultWD]: " workingDirectory
workingDirectory=${workingDirectory:-$defaultWD}

if [ ! -d "$workingDirectory" ]; then
    mkdir -p "$workingDirectory"
    echo "Created directory: $workingDirectory"
fi

# 3. SSH Directory
defaultSSH="$HOME/.ssh"
read -p "SSH directory [Default: $defaultSSH]: " sshDirectory
sshDirectory=${sshDirectory:-$defaultSSH}

if [ ! -d "$sshDirectory" ]; then
    mkdir -p "$sshDirectory"
    echo "Created directory: $sshDirectory"
fi

# 4. Image Name
defaultName="${USER}-wd"
read -p "Image name [Default: $defaultName]: " myImageName
imageName=${myImageName:-$defaultName}

echo "Configuration:"
echo "Image: $imageName (from $dockerImage)"
echo "WD: $workingDirectory"
echo "SSH: $sshDirectory"

echo "Building image: $imageName..."
docker build --build-arg BASE_IMAGE="$dockerImage" -t "$imageName" .

echo "Saving Scripts"
echo "#!/bin/bash" > START.sh
echo "# Generated: $(date)" >> START.sh
echo "docker run -it --rm -d --name $imageName --mount type=bind,source=$workingDirectory,target=/root --mount type=bind,source=$sshDirectory,target=/root/.ssh $imageName" >> START.sh
echo "created START.sh"

echo "#!/bin/bash" > COMMIT.sh
echo "# Generated: $(date)" >> COMMIT.sh
echo "docker commit $imageName $imageName" >> COMMIT.sh
echo "created COMMIT.sh"

echo "#!/bin/bash" > STOP.sh
echo "# Generated: $(date)" >> STOP.sh
echo "docker stop $imageName" >> STOP.sh
echo "docker container prune" >> STOP.sh
echo "created STOP.sh"
