# Minecraft Server (Bedrock) for Docker

A Docker image and docker-compose file to run one or more instances of a native Minecraft Bedrock server using codehz/mcpeserver in an ArchLinux environment wth systemd.


## Background

My kids wanted a Minecraft (Bedrock) server so that they can play the same worlds on any of their devices at home.  We stumbled upon mcpelauncher (https://github.com/MCMrARM/mcpelauncher-linux) and then mcpeserver (https://github.com/codehz/mcpeserver).

This worked well for a single server, but my kids each have their own worlds they want to serve.  The only existing option for multiple servers would be to change the ports, at which point I would need to teach my kids how to add a server manually (which isn't even an available option on some platforms).

My initial instinct was to run a VM for each server, but as I started to add up the resources needed for all the servers my kids wanted, I quickly realized this wouldn't scale well.  So I decided it was time to teach myself about Docker.

The biggest challenge was to figure out how to get systemd running on an ArchLinux, as that was required for codehz/mcpeserver.  Now, I realize that running systemd in Docker is generally considered a no-no, but I was in a hurry and didn't want to reverse engineer mcpeserver to run it without systemd (saving that for a future project).

*So this is my first Docker project.  Don't be too hard on me if I'm doing something terribly wrong.*


## Prerequisites

- Docker
- docker-compose (if you want to use the instructions for  multiple servers)
- A Minecraft x86 .apk file (e.g. use mcpelauncher to access the Minecraft apk file)

## Instructions

### Single-server / New world

*To build/run a single server with a new world on the host:*

1. Save the latest Minecraft x86 apk file over minecraft.apk in the main project folder.
2. Build docker image.

```
docker build -t karlrees/mcserver_archsystemd .
```

3. Start docker container (replacing worldname with whatever you named the Minecraft world folder)

```
docker run --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v worlds:/srv/mcpeserver/worlds -d --network="host" --restart always karlrees/mcserver_archsystemd
```

### Single-server / Existing world

*To build/run a single server using a pre-existing Bedrock world folder:*

1. Save your Minecraft world folder under the "worlds" folder.
2. Optionally, rename your Minecraft world folder to "worldname" or some other appropriate name
3. Create or locate default.cfg file and save it in the worlds folder (this is in the same format as server.properties)
 - if you renamed the world folder, be sure to replace the level-name and level-dir attribute values with "worldname" (or whatever you named the Minecraft world folder), and change the name of the file to worldname.cfg instead of default.cfg. 
4. Save the latest minecraft x86 apk file over Minecraft.apk in the main project folder.
5. Build docker image.

```
docker build -t karlrees/mcserver_archsystemd .
```

6. Start docker container as in step 3 of the first instructions.  Or if you renamed the worlds folder, use the following, replacing worldname with whatever you named the Minecraft world folder:

```
docker run --privileged -e WORLD=worldname -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /path/to/worlds:/srv/mcpeserver/worlds -d --network="host" --restart always karlrees/mcserver_archsystemd
```

### Multiple existing worlds / docker-compose

*To run multiple servers using multiple pre-existing Bedrock worlds, each running at a separate IP address:*

1. For each of your Minecraft worlds, save the Minecraft world folder with a different name under the "worlds" folder.
2. For each world, create or locate a default.cfg (server.properties) file, being sure to replace the level-name and level-dir attribute values with "worldname" (or whatever you named the Minecraft world folder).
3. Save each world's default.cfg or server.properties file in the worlds folder as worldname.cfg (or whatever you named the Minecraft world folder).
4. Save the latest minecraft x86 apk file over minecraft.apk in the docker project folder.
5. Edit envirnonment variables as needed (e.g. change the IP Prefix to match your subnet, eth0 to match your network interface, etc.)
6. Edit the docker-compose file to include a separate section for each server.  Be sure to change the name for each server to match what you used in step 2.  Be sure to use a different IP address or each server as well.
7. Run docker-cmpose

```
docker-compose up -d
```


*Sorry for any confusing instructions.  Just thought it'd be better to share with terse instructions than not at all.*
