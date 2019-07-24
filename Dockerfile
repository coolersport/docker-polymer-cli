FROM node:8.15.1-alpine

RUN apk upgrade && \
    addgroup -g 10000 jenkins && \
    adduser -u 10000 -G jenkins -s /bin/sh -D jenkins && \
    apk add --no-cache bash curl dpkg git && \
    # install gosu
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
    curl -fsSL "https://github.com/tianon/gosu/releases/download/1.10/gosu-$dpkgArch" -o /usr/local/bin/gosu && \
    chmod +x /usr/local/bin/gosu && \
    gosu nobody true && \
    # complete gosu
    npm install -g bower gulp polymer-cli --unsafe-perm && \
    mkdir /src && chown node:node /src && \
    # entrypoint script
    echo $'#!/bin/bash\n\
if [[ -z "$@" ]]; then echo No command provided; exit 1; fi\n\
cd ${SRC_DIR:-/src}\n\
exec gosu ${GOSU_USER:-node} "$@"' > /entrypoint.sh && \
    chmod +x /entrypoint.sh && \
    # clean up
    apk del curl dpkg && \
    rm -rf /apk /tmp/* /var/cache/apk/*

WORKDIR /src
ENTRYPOINT ["/entrypoint.sh"]
CMD ["echo", "Pass the command to run."]
