FROM yimura/crackerjack-docker:hashcat AS hashcat-builder
FROM yimura/crackerjack-docker:wordlists AS wordlist-fetcher

FROM nvidia/cuda:12.3.1-devel-ubuntu22.04 AS prod

ARG DEBIAN_FRONTEND=noninteractive
ARG HASHCAT_INSTALL_DIR=/tmp/hashcat_install

ENV ADDRESS 0.0.0.0
ENV PORT 8080

EXPOSE $PORT

COPY --from=hashcat-builder $HASHCAT_INSTALL_DIR /

RUN apt update &&\
    apt install -y -q git screen sqlite3 python3 python3-pip cron &&\
    pip install --upgrade pip

RUN apt update &&\
    apt install -y -q pocl-opencl-icd intel-opencl-icd clinfo

COPY --from=wordlist-fetcher /opt/wordlists /opt/wordlists
COPY --from=wordlist-fetcher /opt/rules /opt/rules

WORKDIR /opt/crackerjack

RUN git clone https://github.com/sadreck/crackerjack.git . --depth=1 &&\
    pip install -r requirements.txt

COPY entrypoint.sh .
RUN chmod +x ./entrypoint.sh

# fix for windows newlines
RUN sed -i -e 's/\r$//' ./entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]
