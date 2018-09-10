#!/bin/bash

# link custom cfg file if exists and not already linked
if [ -f /srv/mcpeserver/worlds/${WORLD}.cfg ] && ! [ -f /srv/mcpeserver/${WORLD}.cfg ];
then
 ln -s /srv/mcpeserver/worlds/${WORLD}.cfg /srv/mcpeserver/${WORLD}.cfg
fi

# enable mcpeserver service
systemctl enable mcpeserver@${WORLD}

# check for apk file
if ! [ -s /srv/mcpeserver/minecraft.apk ];
then
 echo "Warning!!!!  The minecraft.apk file is empty.  You need to download and replace it with a real x86 apk file, then rebuild the docker image."
fi

# fix permission problems
# theres got to be a less nuclear option here.  got to figure it out.
chmod -R 777 /srv/mcpeserver/worlds

# init systemd (replacing pid 1)
exec /lib/systemd/systemd

