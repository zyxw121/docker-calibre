FROM ubuntu:18.04 

# set version label
ARG BUILD_DATE
ARG VERSION
ARG CALIBRE_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

ENV APPNAME="Calibre" UMASK_SET="022"

RUN \
 echo "**** install runtime packages ****" && \
 apt-get update && \
 apt-get install -y --no-install-recommends \
	dbus \
	fcitx-rime \
	fonts-wqy-microhei \
	jq \
	libqpdf21 \
	libxkbcommon-x11-0 \
	libxcb-icccm4 \
	libxcb-image0 \
	libxcb-keysyms1 \
	libxcb-randr0 \
	libxcb-render-util0 \
	libxcb-xinerama0 \
  libgl1-mesa-glx \
  libxcomposite-dev \
  libnss3 \
  libxi6 \
	python3 \
	python3-xdg \
	ttf-wqy-zenhei \
	wget \
	xz-utils 
COPY /calibre-tarball.txz /tmp
RUN \
 echo "**** install calibre ****" && \
 mkdir -p \
	/opt/calibre && \
 CALIBRE_VERSION="5.5.0" && \
 echo $CALIBRE_RELASE && \
 CALIBRE_URL="https://download.calibre-ebook.com/${CALIBRE_VERSION}/calibre-${CALIBRE_VERSION}-x86_64.txz" && \
 echo "$CALIBRE_URL" && \
 # wget --no-check-certificate "$CALIBRE_URL" -O /tmp/calibre-tarball.txz && \
 tar xvf /tmp/calibre-tarball.txz -C \
	/opt/calibre && \
 /opt/calibre/calibre_postinstall && \
 dbus-uuidgen > /etc/machine-id  
RUN \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/* && \
  mkdir /home/calibre && \
  mkdir /home/Books 

# add local files
#COPY / /home/calibre/
RUN addgroup --gid 1024 mygroup
RUN adduser --disabled-password --gecos "" --force-badname --ingroup mygroup cal 
USER cal

ENV CALIBRE_DEVELOP_FROM=/home/calibre/src

#RUN calibre-server /home/Books

#docker run -v .../calibre:/home/calibre .../books:/home/Books 
  
