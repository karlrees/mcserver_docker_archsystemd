#!/bin/bash

ln -s /srv/mcpeserver/worlds/${WORLD}.cfg /srv/mcpeserver/${WORLD}.cfg
systemctl enable mcpeserver@${WORLD}
exec /lib/systemd/systemd
