FROM debian:buster-slim

LABEL maintainer="Marlon Leerkotte <marlon@leerkotte.net>"

ARG DEBIAN_FRONTEND=noninteractive

ENV LOGSTASH_UID=51339 \
    LOGSTASH_GID=51339

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -r build -g $LOGSTASH_GID \
    && useradd --no-log-init -m -r -u $LOGSTASH_UID -g $LOGSTASH_GID logstash \
    && cd /root/ \
    && curl -LJO https://github.com/magnusbaeck/logstash-filter-verifier/releases/download/1.6.2/logstash-filter-verifier_1.6.2_linux_amd64.tar.gz \
    && tar -xzvf logstash-filter-verifier_1.6.2_linux_amd64.tar.gz \
    && chmod +x logstash-filter-verifier \
    && mv logstash-filter-verifier /usr/local/bin/logstash-filter-verifier \
    && rm /root/* \
    && apt purge -y curl \
    && apt autoremove -y

USER logstash

ENTRYPOINT ["logstash-filter-verifier"]
