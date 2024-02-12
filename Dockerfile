ARG DEBIAN_FRONTEND=noninteractive
ARG HASHCAT_INSTALL_DIR=/tmp/hashcat_install

FROM ubuntu:jammy AS hashcat-builder

ARG DEBIAN_FRONTEND
ARG HASHCAT_INSTALL_DIR
ARG HASHCAT_VERSION=v6.2.6

RUN apt update &&\
    apt install -y -q git make gcc g++ linux-headers-generic

WORKDIR /opt/hashcat

RUN git clone https://github.com/hashcat/hashcat.git . -b $HASHCAT_VERSION --depth=1 &&\
    make &&\
    make install DESTDIR=$HASHCAT_INSTALL_DIR

FROM ubuntu:jammy AS wordlist-fetcher

RUN apt update &&\
    apt install -y -q git

WORKDIR /opt/wordlists
RUN git clone https://github.com/danielmiessler/SecLists.git --depth 1 &&\
    find . -type f -iname '*.tar.gz' -exec tar -xf {} \;

WORKDIR /opt/rules
RUN git clone https://github.com/NotSoSecure/password_cracking_rules.git --depth=1

# FROM ubuntu:jammy AS prod
FROM nvidia/cuda:12.3.1-devel-ubuntu22.04 AS prod

ARG DEBIAN_FRONTEND
ARG HASHCAT_INSTALL_DIR

ARG USER=crackerjack
ENV HOME /home/$USER

ENV ADDRESS 0.0.0.0
ENV PORT 8080

EXPOSE $PORT

COPY --from=hashcat-builder $HASHCAT_INSTALL_DIR /

RUN apt update &&\
    apt install -y -q git screen sqlite3 python3 python3-pip cron &&\
    pip install --upgrade pip

RUN apt update &&\
    apt install -y -q pocl-opencl-icd intel-opencl-icd clinfo

SHELL ["/bin/bash", "-c"]
ARG ADD_WORDLIST_N_RULES=false

WORKDIR /opt/wordlists
RUN [[ "$ADD_WORDLIST_N_RULES" == "true" ]] && git clone https://github.com/danielmiessler/SecLists.git --depth 1 &&\
    find . -type f -iname '*.tar.gz' -exec tar -xf {} \;
COPY --from=wordlist-fetcher /opt/wordlists /opt/wordlists

WORKDIR /opt/rules
RUN [[ "$ADD_WORDLIST_N_RULES" == "true" ]] && git clone https://github.com/NotSoSecure/password_cracking_rules.git --depth=1
COPY --from=wordlist-fetcher /opt/rules /opt/rules

WORKDIR /opt/crackerjack

RUN git clone https://github.com/sadreck/crackerjack.git . --depth=1 &&\
    pip install -r requirements.txt
# botched patches
RUN find . -type f -iname '*.py' -exec sed -i "s|settings.get('hashcat_binary', '')|settings.get('hashcat_binary', '/usr/local/bin/hashcat')|g" {} \;

COPY entrypoint.sh .
RUN chmod +x ./entrypoint.sh

RUN apt install bash -y

RUN sed -i -e 's/\r$//' ./entrypoint.sh

SHELL ["/bin/bash", "-c"]

ENTRYPOINT [ "/bin/bash", "-c", "./entrypoint.sh" ]
# ENTRYPOINT [ "ls" ]
