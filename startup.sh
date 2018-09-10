#!/bin/bash

if [ -f /srv/mcpeserver/worlds/${WORLD}.cfg ] && ! [ -f /srv/mcpeserver/${WORLD}.cfg ];
then
 ln -s /srv/mcpeserver/worlds/${WORLD}.cfg /srv/mcpeserver/${WORLD}.cfg
fi

systemctl enable mcpeserver@${WORLD}

if ! [ -s /srv/mcpeserver/minecraft.apk ];
then
 echo "Warning!!!!  The minecraft.apk file is empty.  You need to download and replace it with a real x86 apk file, then rebuild the docker image."
fi

exec /lib/systemd/systemd
