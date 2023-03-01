## Alpine + Pandoc + TexLive + Eisvogel
## available only for linux/amd64
FROM pandoc/extra:3.1


## Versions
ARG ARCH=amd64
ARG PANDOC=3.1
ARG HUGO=0.110.0


## Alpine: install extra packages
COPY docker/install-packages-alpine.sh  /root/install-packages-alpine.sh
RUN /root/install-packages-alpine.sh  &&  rm -rf /root/install-packages-alpine.sh


## TexLive and extra packages
COPY docker/install-texlive-extras.sh  /root/install-texlive-extras.sh
RUN /root/install-texlive-extras.sh  &&  rm -rf /root/install-texlive-extras.sh


## Entrypoint
ENTRYPOINT ["sh", "-c"]
