# Minecraft Server (Bedrock) for Docker

A Docker image and docker-compose file to run one or more instances of a native Minecraft Bedrock server using codehz/mcpeserver in an ArchLinux environment wth systemd.


## Background

My kids wanted a Minecraft (Bedrock) server so that they can play the same worlds on any of their devices at home.  We stumbled upon mcpelauncher (https://github.com/MCMrARM/mcpelauncher-linux) and then mcpeserver (https://github.com/codehz/mcpeserver).

This worked well for a single server, but kids each have their own worlds they want to serve.  The only existing option for multiple servers would be to change the ports, at which point I would need to teach my kids how to add a server manually (which isn't even an available option on some platforms).

My initial instinct was to run a VM for each server, but as I started to add up the resources needed for all the servers my kids wanted, I quickly realized this wasn't this wouldn't scale well.  So I decided it was time to teach myself about Docker.

The biggest challenge was to figure out how to get systemd running on an ArchLinux, as that was required for codehz/mcpeserver.  Now, I realize that running systemd in Docker is generally considered a no-no, but I was in a hurry and didn't want to reverse engineer mcpeserver to run it without systemd (saving that for a future project).

*So this is my first Docker project.  Don't be too hard on me if I'm doing something terribly wrong.*


## Prerequisites

- Docker
- docker-compose
- Minecraft x86 .apk file (e.g. use mcpelauncher to access the Minecraft apk file)
- 

## Instructions

*To build/run a single server using a pre-existing Bedrock world folder:*

1. Create a root "worlds" folder.
2. Save your Minecraft world folder under the root worlds folder.
3. Rename your Minecraft world folder to "worldname" or some other appropriate name (optional) 
4. Create or locate server.properties file, being sure to replace the level-name and level-dir attribute values with "worldname" (or whatever you named the Minecraft world folder).
5. Rename server.properties to worldname.cfg (or whatever you named the Minecraft world folder).
6. Save the latest Minecraft x86 apk file as Minecraft.apk in the docker project folder.
7. Build docker image.

```
docker build -t karlrees/mcserver_archsystemd .
```

8. Start docker container (replacing worldname with whatever you named the Minecraft world folder)

```
docker run --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v worlds:/srv/mcpeserver/worlds -e WORLD='worldname' -d --restart always karlrees/mcserver_archsystemd
```

*To run multiple servers using multiple pre-existing Bedrock worlds, each running at a separate IP address:*

1. Create a root "worlds" folder.
2. For each of your Minecraft worlds, save the Minecraft world folder with a different name under the root worlds folder.
3. For each world, create or locate a server.properties file, being sure to replace the level-name and level-dir attribute values with "worldname" (or whatever you named the Minecraft world folder).
4. Save each world's server.properties as worldname.cfg (or whatever you named the Minecraft world folder).
5. Save the latest Minecraft x86 apk file as minecraft.apk in the docker project folder.
6. Edit envirnonment variables as needed (e.g. change the IP Prefix to match your subnet, eth0 to match your network interface)
7. Edit the docker-compose file to include a separate section for each server.  Be sure to change the name for each server to match what you used in step 2.  Be sure to change the IP address as well.
8. Run docker-cmpose

```
docker-compose up -d
```


*Sorry for the terse instructions.  Just thought it'd be better to share with terse instructions than not at all.*
