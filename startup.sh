#!/bin/bash

# unpack minecraft apk into image
if [ -s "/mcresources/${MCAPKFILE}" ]; then
  cd /srv/mcpeserver && mcpeserver unpack --apk "/mcresources/${MCAPKFILE}" &>/dev/null
 else 
  echo "WARNING!!! No minecraft apk file. Build will not work unless you place a x86 minecraft apk file in the mcresources folder!"
  exit
fi

# if world folder does not exist, create it
mkdir -p -- "/mcresources/worlds/${WORLD}"

# link world folder to /srv/mcpeserver
mkdir -p -- "/srv/mcpeserver/worlds"
if ! [ -e "/srv/mcpeserver/worlds/${WORLD}" ]; then
 ln -s "/mcresources/worlds/${WORLD}" "/srv/mcpeserver/worlds/${WORLD}" 
fi

# if no existing cfg file, copy over default cfg file
if ! [ -f "/mcresources/worlds/${WORLD}.cfg" ]; then
 mv "/srv/mcpeserver/configtemplate.cfg" "/mcresources/worlds/${WORLD}.cfg"
fi

# fix cfg file world location and port, if needed
sed -i -e "s/=world/=$WORLD/g" "/mcresources/worlds/${WORLD}.cfg"
sed -i -e "s/=19132/=$MCPORT/g" "/mcresources/worlds/${WORLD}.cfg"

# link custom cfg file if not already linked
# commenting out and switching to just making a copy because it seemed to have probelms when in Windows
#if ! [ -f "/srv/mcpeserver/${WORLD}.cfg" ]; then
# ln -s "/mcresources/worlds/${WORLD}.cfg" "/srv/mcpeserver/${WORLD}.cfg" 
#fi

cp "/mcresources/worlds/${WORLD}.cfg" "/srv/mcpeserver/${WORLD}.cfg"

# enable mcpeserver service
systemctl enable mcpeserver@${WORLD} &>/dev/null

# fix permission problems
# theres got to be a less nuclear option here.  got to figure it out.
chmod -R 777 /mcresources/worlds/${WORLD}
chmod -R 777 /srv/mcpeserver/worlds

echo "STARTING MCPESERVER: ${WORLD} on ${HOSTNAME}:${MCPORT} ..."

# init systemd (replacing pid 1)
exec /lib/systemd/systemd

