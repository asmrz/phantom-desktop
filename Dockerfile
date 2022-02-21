FROM ubuntu:20.04
ARG USERNAME=phantom
ARG PASSWORD=password

### Environment ###
ENV USERNAME=$USERNAME
ENV PASSWORD=$PASSWORD
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt upgrade -y

### Install VNC server ###
RUN apt install -y tigervnc-standalone-server curl wget python3-websockify vim

### Install GUI desktop ###
RUN apt-get install -y --no-install-recommends \
 ubuntu-mate-desktop mate-tweak mate-menu sudo \
 ubuntu-mate-themes ubuntu-mate-default-settings ubuntu-mate-wallpapers-legacy ubuntu-mate-artwork \
 caja-open-terminal caja-wallpaper caja-rename caja-mediainfo fonts-ubuntu fonts-liberation \
 mate-applet-brisk-menu mate-hud gnome-menus seahorse indicator-notifications dconf-editor eom

### Install basic apps ###
RUN apt-get install -y --no-install-recommends \
 firefox transmission pluma libreoffice-calc libreoffice-writer atril uget
RUN apt install -y ssh iputils-ping telnet traceroute bind9-dnsutils

### Setup HTTP server ###
ADD server.py /
RUN apt install -y python && chmod 0755 /server.py

### Setup noVNC ###
ADD https://github.com/novnc/noVNC/archive/refs/tags/v1.3.0.tar.gz /
RUN tar xvf v1.3.0.tar.gz && mv v1.3.0.tar.gz noVNC-v1.3.0.tar.gz && mv noVNC-1.3.0 novnc && cp /novnc/vnc.html /novnc/index.html

### Setup VNC user ###
RUN useradd -ms /bin/bash "${USERNAME}"
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers
RUN chown -R "${USERNAME}:${USERNAME}" "/home/${USERNAME}"
ADD entrypoint.sh /
COPY default_home.tar.gz /
RUN chmod 0755 /entrypoint.sh && chmod 0666 /default_home.tar.gz
USER "${USERNAME}"
WORKDIR "/home/${USERNAME}"

### Docker settings ###
VOLUME /home/${USERNAME}
EXPOSE 5900
EXPOSE 8000
EXPOSE 7000
ENTRYPOINT "/entrypoint.sh"
