FROM ubuntu:jammy

ARG DEBIAN_FRONTEND=noninteractive
ARG HASHCAT_INSTALL_DIR=/tmp/hashcat_install
ARG HASHCAT_VERSION=v6.2.6

RUN apt update &&\
    apt install -y -q git make gcc g++ linux-headers-generic

WORKDIR /opt/hashcat

RUN git clone https://github.com/hashcat/hashcat.git . -b $HASHCAT_VERSION --depth=1 &&\
    make &&\
    make install DESTDIR=$HASHCAT_INSTALL_DIR
