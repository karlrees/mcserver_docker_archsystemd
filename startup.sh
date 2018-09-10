#!/bin/bash

if [ -f /srv/mcpeserver/worlds/${WORLD}.cfg ] && ! [ -f /srv/mcpeserver/${WORLD}.cfg ];
then
 ln -s /srv/mcpeserver/worlds/${WORLD}.cfg /srv/mcpeserver/${WORLD}.cfg
fi

systemctl enable mcpeserver@${WORLD}
exec /lib/systemd/systemd
