FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y lm-sensors curl && \
    rm -rf /var/lib/apt/lists/*

# Install gosu
ARG GOSU_VERSION=1.16
RUN set -eux; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates wget gnupg; \
    rm -rf /var/lib/apt/lists/*; \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
    command -v gpgconf && gpgconf --kill all || :; \
    rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
    apt-mark auto '.*' > /dev/null; \
    [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark > /dev/null; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    chmod +x /usr/local/bin/gosu; \
    gosu --version; \
    gosu nobody true

# Install node_exporter
ADD https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz /tmp/
RUN tar -xzf /tmp/node_exporter-1.5.0.linux-amd64.tar.gz -C /tmp/ && \
    mv /tmp/node_exporter-1.5.0.linux-amd64/node_exporter /usr/local/bin/ && \
    rm -rf /tmp/node_exporter-1.5.0.linux-amd64*

COPY cpu_temp.sh /usr/local/bin/cpu_temp.sh
RUN chmod +x /usr/local/bin/cpu_temp.sh

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the ownership and permissions of the textfile collector directory
RUN mkdir -p /var/lib/node_exporter/textfile_collector && \
    chown nobody:nogroup /var/lib/node_exporter/textfile_collector && \
    chmod 777 /var/lib/node_exporter/textfile_collector

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
