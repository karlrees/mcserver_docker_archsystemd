#!/bin/bash

# unpack minecraft apk into image
if [ -s "/mcresources/${MCAPKFILE}" ]; then
  cd /srv/mcpeserver && mcpeserver unpack --apk "/mcresources/${MCAPKFILE}" &>/dev/null
 else 
  echo "WARNING!!! No minecraft apk file. Build will not work unless you place a x86 minecraft apk file in the mcresources folder!"
  exit
fi

# if world folder does not exist, create it
mkdir -p -- "/srv/mcpeserver/worlds/${WORLD}"

# if no existing cfg file, use default cfg file
if ! [ -f "/mcresources/${WORLD}.cfg" ]; then
 mv "/srv/mcpeserver/configtemplate.cfg" "/mcresources/${WORLD}.cfg"
fi

# fix cfg file world location
sed -i -e "s/=world/=$WORLD/g" "/mcresources/${WORLD}.cfg"

# copy custom cfg file to correct location
cp "/mcresources/${WORLD}.cfg" "/srv/mcpeserver/${WORLD}.cfg"

# change default server port
sed -i -e "s/=19132/=$MCPORT/g" "/srv/mcpeserver/${WORLD}.cfg"

# enable mcpeserver service
systemctl enable mcpeserver@${WORLD} &>/dev/null

# fix permission problems
# theres got to be a less nuclear option here.  got to figure it out.
chmod -R 777 "/srv/mcpeserver/worlds/${WORLD}"

echo "STARTING MCPESERVER: ${WORLD} on ${HOSTNAME}:${MCPORT} ..."

# init systemd (replacing pid 1)
exec /lib/systemd/systemd

