# Docker workspace
This folder contains the script(s) needed to setup docker workspaces on the CompL Server.

## Usage

1. Create a folder named `docker-scripts` inside your home directory and copy `SETUP.sh` into it.

```bash
mkdir ~/docker-scripts
cp SETUP.sh ~/docker-scripts
cd ~/docker-scripts
```

2. Execute `SETUP.sh`

```bash
bash SETUP.sh
```

```bash
meetesh@server:~/docker-scripts$ bash SETUP.sh

[Your docker image will be named: 'meetesh-wd']

(1) Password to use inside the container: 1234

(2) Select your Ubuntu version:
    1) 20.04
    2) 22.04 (default)
    3) 24.04
Enter your choice (1-3, default is 2): 2

(3) Select working directory
Your local working directory (default: '/home/meetesh/docker-wd') will be mirrored inside the docker container at '/home/meetesh/wd'
  /home/meetesh/docker-wd <--> /home/meetesh/wd
Enter a different path or leave it blank (default: '/home/meetesh/docker-wd'):
  /home/meetesh/docker-wd <--> /home/meetesh/wd

(4) Do you want to use docker inside docker [y/n]?n

(5) Mirroring .ssh folder (this is useful for things like git access)
Your local .ssh dir (default: '/home/meetesh/.ssh') will be mirrored inside the docker container at '/home/meetesh/.ssh'
  /home/meetesh/.ssh <--> /home/meetesh/.ssh
Enter a different path or leave it blank (default: '/home/meetesh/.ssh'):
  /home/meetesh/.ssh <--> /home/meetesh/.ssh


Final Config
  baseImage        : 'ubuntu:22.04'
  username         : 'meetesh'
  password         : '1234'
  local-wd         : '/home/meetesh/docker-wd'
  container-wd     : '/home/meetesh/wd'
  docker-in-docker : 'n'
  default-packages : 'sudo build-essential git curl wget'
  ssh directory    : '/home/meetesh/.ssh'


Do you want to proceed [y/n]?y
[Generate files...]
[Generated Dockerfile]
[Generated commit.sh]
[Generated start.sh]
[Generated stop.sh]
[Generated restart.sh]
[Generated startIsolated.sh]
[Generated restartIsolated.sh]
All files generated, build docker container [y/n]?y
[+] Building 0.2s (13/13) FINISHED                                                                                       docker:default
 => [internal] load build definition from Dockerfile                                                                               0.0s
 => => transferring dockerfile: 1.52kB                                                                                             0.0s
 => [internal] load metadata for docker.io/library/ubuntu:22.04                                                                    0.0s
 => [internal] load .dockerignore                                                                                                  0.0s
 => => transferring context: 2B                                                                                                    0.0s
 => [1/9] FROM docker.io/library/ubuntu:22.04                                                                                      0.0s
 => CACHED [2/9] RUN apt-get update && apt-get install -y sudo build-essential git curl wget                                       0.0s
 => CACHED [3/9] RUN groupadd -g 1002 meetesh                                                                                      0.0s
 => CACHED [4/9] RUN mkdir -p /home/meetesh && chown 1002:1002 /home/meetesh                                                       0.0s
 => CACHED [5/9] RUN useradd -m -d /home/meetesh -u 1002 -g 1002 -s /bin/bash meetesh                                              0.0s
 => CACHED [6/9] RUN echo "meetesh:1234" | chpasswd                                                                                0.0s
 => CACHED [7/9] RUN usermod -aG sudo meetesh                                                                                      0.0s
 => CACHED [8/9] WORKDIR /home/meetesh                                                                                             0.0s
 => CACHED [9/9] RUN cp /etc/skel/.bashrc /home/meetesh/.bashrc                                                                    0.0s
 => exporting to image                                                                                                             0.0s
 => => exporting layers                                                                                                            0.0s
 => => writing image sha256:742d38e5574977bc64ab363954e8a68a4da850f798fff08efc36fa5f64d40ffd                                       0.0s
 => => naming to docker.io/library/meetesh-wd                                                                                      0.0s
```

3. After running the setup, a new docker image named `USERNAME-wd` with a bunch of files will be created.

```bash
meetesh@server:~/docker-scripts$ ls
commit.sh  Dockerfile  restartIsolated.sh  restart.sh  SETUP.sh  startIsolated.sh  start.sh  stop.sh
meetesh@server:~/docker-scripts$ docker image list
REPOSITORY            TAG            IMAGE ID       CREATED         SIZE
meetesh-wd            latest         742d38e55749   4 hours ago     433MB
ubuntu                22.04          8a3cdc4d1ad3   2 months ago    77.9MB
hello-world           latest         d2c94e258dcb   17 months ago   13.3kB
```

#### `start.sh`
This script is used to start a container in non-isolated mode.
The CPU cores from the `docker` core group will be accessible to the container.

```bash
meetesh@server:~/docker-scripts$ bash start.sh 
Error response from daemon: No such container: meetesh-wd
2a18c8a9dc9ea95241df7c748bd51f809e98fb764f01a5e9c1d7a14a964e6077
Started container
CONTAINER ID   IMAGE          COMMAND                CREATED        STATUS                  PORTS     NAMES
2a18c8a9dc9e   meetesh-wd     "/bin/bash"            1 second ago   Up Less than a second             meetesh-wd
3347d79ae95d   a4e8983e9734   "/bin/bash"            10 hours ago   Up 10 hours                       anadi-wd
378598a5ff63   preet-wd       "entrypoint.sh bash"   27 hours ago   Up 27 hours                       preet-wd
d3d1e0d2625e   lorenzo-wd     "/bin/bash"            4 days ago     Up 4 days                         lorenzo-wd
```

#### `stop.sh`
This script is used to stop a container.

```bash
meetesh@server:~/docker-scripts$ bash stop.sh 
meetesh-wd
WARNING! This will remove all stopped containers.
Are you sure you want to continue? [y/N] y
Total reclaimed space: 0B
```

#### `restart.sh`
Stops and starts a running container.

```bash
meetesh@server:~/docker-scripts$ bash restart.sh 
meetesh-wd
WARNING! This will remove all stopped containers.
Are you sure you want to continue? [y/N] y
Total reclaimed space: 0B
Error response from daemon: No such container: meetesh-wd
1c0ab26b088312ce8698d09bc3acb0d81ba55d8a867dfc387a4a2b528e220c4c
Started container
CONTAINER ID   IMAGE          COMMAND                CREATED        STATUS                  PORTS     NAMES
1c0ab26b0883   meetesh-wd     "/bin/bash"            1 second ago   Up Less than a second             meetesh-wd
3347d79ae95d   a4e8983e9734   "/bin/bash"            11 hours ago   Up 11 hours                       anadi-wd
378598a5ff63   preet-wd       "entrypoint.sh bash"   27 hours ago   Up 27 hours                       preet-wd
d3d1e0d2625e   lorenzo-wd     "/bin/bash"            4 days ago     Up 4 days                         lorenzo-wd
```

#### `startIsolated.sh`
This script is used to start a container in isolated mode.
It lists the 
The CPU cores from the `selected` core group will be accessible to the container.

```bash
meetesh@server:~/docker-scripts$ bash startIsolated.sh 
Available cgroups:
Name | Subs
c16_1 |  0
c16_2 |  0
c16_3 |  0
c16_4 |  0
c16_5 |  0
c16_6 |  0
c16_7 |  0
c16_8 |  0
c32_1 |  0
c32_2 |  0
Enter cgroup name: c16_1
Selected cgroup: c16_1
Error response from daemon: No such container: meetesh-wd
878c6ae6b53be2ab1ee3836429513e943e11dd89968709797b0a758164c01d1d
Started container
CONTAINER ID   IMAGE          COMMAND                CREATED        STATUS                  PORTS     NAMES
878c6ae6b53b   meetesh-wd     "/bin/bash"            1 second ago   Up Less than a second             meetesh-wd
3347d79ae95d   a4e8983e9734   "/bin/bash"            11 hours ago   Up 11 hours                       anadi-wd
378598a5ff63   preet-wd       "entrypoint.sh bash"   28 hours ago   Up 28 hours                       preet-wd
d3d1e0d2625e   lorenzo-wd     "/bin/bash"            4 days ago     Up 4 days                         lorenzo-wd
```

4. Once you start a container it starts in the background, you can log into the container's terminal at any time using `docker exec` command. The following commands will create a `helloFile` from inside the container within the `wd` folder. Recall that this folder is shared between the host and your container. 

```bash
meetesh@server:~/docker-scripts$ docker exec -it meetesh-wd bash
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

meetesh@878c6ae6b53b:~$ echo "Hello inside the container" > wd/helloFile
meetesh@server:~/docker-scripts$ cd ~/docker-wd/
meetesh@server:~/docker-wd$ ls
helloFile
meetesh@server:~/docker-wd$ cat helloFile 
Hello inside the container
```


### How do I know my docker is running in isolated mode?

Let us say you started a container using `startIsolated.sh` and selected core group c16_1 as such:

```bash
meetesh@server:~/docker-scripts$ bash startIsolated.sh 
Available cgroups:
Name | Subs
c16_1 |  0
c16_2 |  0
c16_3 |  0
c16_4 |  0
c16_5 |  0
c16_6 |  0
c16_7 |  0
c16_8 |  0
c32_1 |  0
c32_2 |  0
Enter cgroup name: c16_1
Selected cgroup: c16_1
Error response from daemon: No such container: meetesh-wd
878c6ae6b53be2ab1ee3836429513e943e11dd89968709797b0a758164c01d1d
Started container
CONTAINER ID   IMAGE          COMMAND                CREATED        STATUS                  PORTS     NAMES
878c6ae6b53b   meetesh-wd     "/bin/bash"            1 second ago   Up Less than a second             meetesh-wd
3347d79ae95d   a4e8983e9734   "/bin/bash"            11 hours ago   Up 11 hours                       anadi-wd
378598a5ff63   preet-wd       "entrypoint.sh bash"   28 hours ago   Up 28 hours                       preet-wd
d3d1e0d2625e   lorenzo-wd     "/bin/bash"            4 days ago     Up 4 days                         lorenzo-wd
```

We can check the cgroup parent of our newly created container using `docker inspect`.

```bash
meetesh@server:/sys/fs/cgroup/cpu/docker$ docker inspect --format '{{.HostConfig.CgroupParent}}' 878c6ae6b53b
/c16_1
```

If we look at the output of `cset set -r` we can see a docker sub task scheduled under the core group `/c16_1`.

```bash
meetesh@server:~/docker-wd$ cset set
cset: 
         Name       CPUs-X    MEMs-X Tasks Subs Path
 ------------ ---------- - ------- - ----- ---- ----------
         root      0-255 y     0-1 y  2193   13 /
        c16_3    160-175 n       0 n     0    0 /c16_3
        c32_2     96-127 n       0 n     0    0 /c32_2
        c16_1    128-143 n       0 n     0    1 /c16_1  <-- Notice the 1 in Subs
        c16_8    240-255 n       0 n     0    0 /c16_8
                   0-255 n     0-1 n     0    0 / 
       docker       0-63 n       0 n     0    2 /docker
        c16_6    208-223 n       0 n     0    0 /c16_6
       system       0-63 n       0 n   963    5 /system
        c16_4    176-191 n       0 n     0    0 /c16_4
        c16_2    144-159 n       0 n     0    0 /c16_2
        c32_1      64-95 n       0 n     0    0 /c32_1
        c16_7    224-239 n       0 n     0    0 /c16_7
        c16_5    192-207 n       0 n     0    0 /c16_5

meetesh@server:~/docker-wd$ cset set -r # We can use -r to recursively list all the sub groups
cset: 
         Name       CPUs-X    MEMs-X Tasks Subs Path
 ------------ ---------- - ------- - ----- ---- ----------
         root      0-255 y     0-1 y  2193   13 /
        c16_3    160-175 n       0 n     0    0 /c16_3
        c32_2     96-127 n       0 n     0    0 /c32_2
        c16_1    128-143 n       0 n     0    1 /c16_1
        c16_8    240-255 n       0 n     0    0 /c16_8
                   0-255 n     0-1 n     0    0 / 
       docker       0-63 n       0 n     0    2 /docker
        c16_6    208-223 n       0 n     0    0 /c16_6
       system       0-63 n       0 n   959    5 /system
        c16_4    176-191 n       0 n     0    0 /c16_4
        c16_2    144-159 n       0 n     0    0 /c16_2
        c32_1      64-95 n       0 n     0    0 /c32_1
        c16_7    224-239 n       0 n     0    0 /c16_7
        c16_5    192-207 n       0 n     0    0 /c16_5
 878c6ae6b53be2ab1ee3836429513e943e11dd89968709797b0a758164c01d1d    128-143 n       0 n     1    0 /c16_1/878c6ae6b53...89968709797b0a758164c01d1d
 ...
```

We see that our docker container has access to the core group `c16_1`, which means we have access to cores 128-143. But how do we know it is working?

#### Diving Deeper into isolation

Inside the docker container we will run a script that generates load for N=20 cores.
Two things should be observed, firstly, the generated load should be distributed only across cores numbered 128-143.
Secondly, as we have more threads than cores, some processes will share some of the cores.

We first run the following load generation script from within the container.

**load_generator.sh**
```bash
#!/bin/bash

# Number of CPU cores to use
NUM_CORES=$1

# Function to generate random CPU load
generate_load() {
    core=$1
    while :; do
        # Create some load, then sleep for a random interval between 0 and 1 second
        taskset -c "$core" dd if=/dev/urandom of=/dev/null bs=1M count=1024 &> /dev/null
        sleep $(awk -v min=0 -v max=1 'BEGIN{srand(); print min+rand()*(max-min)}')
    done
}

# Check if a valid number of cores is provided
if ! [[ "$NUM_CORES" =~ ^[0-9]+$ ]] || [ "$NUM_CORES" -le 0 ]; then
    echo "Usage: $0 <number_of_cores>"
    exit 1
fi

echo "Generating random CPU load on $NUM_CORES cores..."

# Spawn load processes for each core
for ((i = 0; i < NUM_CORES; i++)); do
    generate_load "$i" &
done

# Trap to clean up background processes on exit
trap "killall dd; exit" SIGINT SIGTERM

# Wait indefinitely
wait
```

Now we login into the from a different terminal window and check the processes that exist on the server, we can easily find the processes relevant to the generated load using `ps -aux | grep load_generator.sh`. Finally all we need to do is check the core ID assigned to each of these processes. We can use a `pid-check.sh` to do this.

```bash
#!/bin/bash

# Find all PIDs of the 'load_generator.sh' processes using ps and grep
PIDS=$(ps -aux | grep '[l]oad_generator.sh' | awk '{print $2}')

# Check if any 'load_generator.sh' processes are running
if [ -z "$PIDS" ]; then
    echo "No 'load_generator.sh' processes are running."
    exit 1
fi

# Loop through each PID and print the core it's running on
echo "PID  ->  Core ID"
for pid in $PIDS; do
    core=$(awk '{print $39}' /proc/$pid/stat)
    echo "$pid  ->  Core $core"
done
```

Notice all our isolation seems to be working as expected ;)
```bash
meetesh@server:~$ bash pid-check.sh 
PID  ->  Core ID
205367  ->  Core 143
205368  ->  Core 142
205369  ->  Core 136
205370  ->  Core 135
205372  ->  Core 140
205374  ->  Core 135
205376  ->  Core 135
205378  ->  Core 129
205380  ->  Core 131
205382  ->  Core 133
205384  ->  Core 128
205386  ->  Core 137
205389  ->  Core 131
205393  ->  Core 143
205396  ->  Core 142
205399  ->  Core 143
205401  ->  Core 139
205405  ->  Core 130
205407  ->  Core 129
205410  ->  Core 140
205412  ->  Core 143
```
If we try to list the PIDs after stopping the container, we find nothing.
```bash
meetesh@server:~$ docker stop meetesh-wd 
meetesh-wd
meetesh@server:~$ bash pid-check.sh 
No 'load_generator.sh' processes are running.
```


## Notes

1. Listing docker images      : `docker image list`
2. Listing docker containers  : `docker ps -a`
3. Stoppong a container       : `docker stop USERNAME-wd`
4. Deleting closed containers : `docker container prune`
