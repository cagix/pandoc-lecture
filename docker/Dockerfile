## Ubuntu LTS
## provide similar functionality as pandoc/extra, but for linux/arm64
## (pandoc/extra is currently only available for linux/amd64)
FROM ubuntu:latest


## Versions
ARG ARCH=arm64
# set ARCH="amd64" or ARCH="arm64" externally
ENV XDG_DATA_HOME="/usr/local/share"
ENV DEBIAN_FRONTEND=noninteractive


## Ubuntu
COPY install-packages-ubuntu.sh  /root/install-packages-ubuntu.sh
RUN /root/install-packages-ubuntu.sh  &&  rm -rf /root/install-packages-ubuntu.sh


## Install Pandoc and Pandoc-Lecture
COPY install-pandoc.sh  /root/install-pandoc.sh
RUN /root/install-pandoc.sh  &&  rm -rf /root/install-pandoc.sh

COPY install-pandoc-lecture.sh  /root/install-pandoc-lecture.sh
RUN /root/install-pandoc-lecture.sh  &&  rm -rf /root/install-pandoc-lecture.sh


## Install Hugo and Hugo Relearn Theme
COPY install-hugo.sh  /root/install-hugo.sh
RUN /root/install-hugo.sh  &&  rm -rf /root/install-hugo.sh

COPY install-relearn.sh  /root/install-relearn.sh
RUN /root/install-relearn.sh  &&  rm -rf /root/install-relearn.sh


## TexLive and extra packages
COPY install-texlive.sh  /root/install-texlive.sh
RUN /root/install-texlive.sh  &&  rm -rf /root/install-texlive.sh

#COPY install-texlive-extra.sh  /root/install-texlive-extra.sh
#RUN /root/install-texlive-extra.sh  &&  rm -rf /root/install-texlive-extra.sh


## Entrypoint
ENTRYPOINT ["sh", "-c"]
