FROM node:8.15.1-alpine

RUN apk upgrade && \
    addgroup -g 10000 jenkins && \
    adduser -u 10000 -G jenkins -s /bin/sh -D jenkins && \
    apk add --no-cache curl dpkg git && \
    # install gosu
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
    curl -fsSL "https://github.com/tianon/gosu/releases/download/1.10/gosu-$dpkgArch" -o /usr/local/bin/gosu && \
    chmod +x /usr/local/bin/gosu && \
    gosu nobody true && \
    # complete gosu
    npm install -g bower polymer-cli --unsafe-perm && \
    mkdir /src && chown node:node /src && \
    # clean up
    apk del curl dpkg && \
    rm -rf /apk /tmp/* /var/cache/apk/*

WORKDIR /src
ENTRYPOINT ["gosu", "node"]
CMD ["echo", "Pass the command to run."]
