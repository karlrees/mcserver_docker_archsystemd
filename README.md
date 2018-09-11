# Minecraft Server (Bedrock) for Docker

A Docker image and docker-compose file to run one or more instances of a native Minecraft Bedrock server using codehz/mcpeserver in an ArchLinux environment wth systemd.


## Changes in this version

### v0.2-alpha
- Moved the unpacking of the minecraft.apk file to run time instead of build time so that the project can be used without having to rebuild it.
- Changed the stucture I was using to link external volumes to be more user-friendly (I think)
- Various other enhancements

## Background

My kids wanted a Minecraft (Bedrock) server so that they can play the same worlds on any of their devices at home.  We stumbled upon mcpelauncher (https://github.com/MCMrARM/mcpelauncher-linux) and then mcpeserver (https://github.com/codehz/mcpeserver).

This worked well for a single server, but my kids each have their own worlds they want to serve, and they want to be able to bring these up and down quickly.  Long story short, for various reasons, I decided it was time to teach myself about Docker, and run the servers in a docker image.

The biggest challenge was to figure out how to get systemd running on an ArchLinux, as that was required for codehz/mcpeserver.  Now, I realize that running systemd in Docker is generally considered a no-no, but I was in a hurry and didn't want to reverse engineer mcpeserver to run it without systemd (saving that for a future project).

*So this is my first Docker project.  Don't be too hard on me if I'm doing something terribly wrong.*


## Prerequisites

- Docker
- docker-compose (if you want to use the instructions for  multiple servers)
- A Minecraft x86 .apk file (e.g. use mcpelauncher to access the Minecraft apk file)

## Instructions

### Single-server / New world

*To build/run a single server with a new world on the host:*

1. Download the latest Minecraft x86 apk file.
2. Save the file as "minecraft.apk" to a folder in which you wish to store your Minecraft data.
3. Pull the docker image.

```
docker pull karlrees/mcserver_archsystemd .
```

4. Start the docker container, replacing "/path/to/resource/folder" with the folder in which you stored the apk file in step 1. 

```
docker run --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /path/to/resource/folder:/mcresources -d --network="host" karlrees/mcserver_docker_archsystemd
```

### Single-server / Existing world

*To build/run a single server using a pre-existing Bedrock world folder:*

1. Complete steps 1-3 above.
2. Create a "worlds" subdirectory in the folder in which you saved the apk file
3. Save your Minecraft world folder under the "worlds" subdirectory
4. Choose a name for your existing world (e.g. "worldname").
5. Rename your Minecraft world folder to the new name you chose (e.g. "worldname")
6. Create or locate the default.cfg file for your world (this is in the same format as server.properties)
7. Save the default.cfg file as "worldname.cfg" in the worlds folder, where worldname is the name you chose in step 4
8. Change the level-name and level-dir attribute values from "world" to "worldname" (or whatever name you chose in step 4)
9. Start docker container as shown below, replacing "worldname" with whatever you named the Minecraft world folder, and "/path/to" with the absolute path to your worlds folder:

```
docker run --privileged -e WORLD=worldname -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /path/to/resource/folder:/mcresources -d --network="host" karlrees/mcserver_docker_archsystemd
```

### Multiple existing worlds / docker-compose

*To run multiple servers using multiple pre-existing Bedrock worlds, each running at a separate IP address:*

1. Download the source code from git

```
git clone https://github.com/karlrees/mcserver_docker_archsystemd
```

2. Complete steps 1-8 above, using the resource folder in the source code to store the apk file and worlds.  Repeat steps 3-8 for each world you wish to run.
3. Edit envirnonment variables as needed (e.g. change the IP Prefix to match your subnet, eth0 to match your network interface, etc.)
4. Edit the docker-compose file to include a separate section for each server.  Be sure to change the name for each server to match what you used in step 2.  Be sure to use a different IP address or each server as well.
5. Run docker-compose

```
docker-compose up -d
```


*Sorry for any confusing instructions.  Just thought it'd be better to share with terse instructions than not at all.*

## To-do list

- Run multiple servers off a single docker image
- Change ports (limited support already in place)
- Auto-detect apk file name and use latest version unless explicitly overridden
- See if I can get away from systemd
