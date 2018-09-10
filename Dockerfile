FROM base/archlinux
ENV container docker

# set minecraft world name and port
ENV WORLD='default'
ENV MCPORT=19132

EXPOSE $MCPORT

# update systemd and remove services
RUN pacman -Sy
RUN pacman --noconfirm -S systemd procps; pacman --noconfirm -Scc ;\
 (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /lib/systemd/system/graphical.target.wants/*; \
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
RUN systemctl set-default -f multi-user.target

# declare volume for systemd
VOLUME ["/sys/fs/cgroup"]

# update pacman.conf with repositories to build mcpeserver
COPY pacman.conf.update /tmp/
RUN cat /tmp/pacman.conf.update >> /etc/pacman.conf && rm -f /tmp/pacman.conf.update

# build mcpeserver
RUN pacman --noconfirm -Syu mcpeserver mcpeserver-core
RUN install -dm 0755 -o mcpeserver /srv/mcpeserver

# unpack minecraft apk into image
COPY minecraft.apk /srv/mcpeserver/minecraft.apk
RUN cd /srv/mcpeserver && mcpeserver unpack --apk minecraft.apk

# declare volume for minecraft worlds
VOLUME ["/srv/mcpeserver/worlds"]

# set up startup script
COPY startup.sh /srv/mcpeserver/
RUN chmod +x /srv/mcpeserver/startup.sh
ENTRYPOINT ["/srv/mcpeserver/startup.sh"]
