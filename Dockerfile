FROM alpine:3.17 as sources

RUN apk -U --no-cache add \
        curl \
        git \
        && \
    rm -rf /var/cache/apk/* && \
    export UTILS_VERSION=$(curl --silent "https://api.github.com/repos/dobrevit/haproxy-lua-utils/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') && \
    export DNSBL_VERSION=$(curl --silent "https://api.github.com/repos/dobrevit/haproxy-lua-dnsbl/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') && \
    curl -L -o /tmp/haproxy-lua-utils.tar.gz "https://github.com/dobrevit/haproxy-lua-utils/archive/refs/tags/$UTILS_VERSION.tar.gz" && \
    curl -L -o /tmp/haproxy-lua-dnsbl.tar.gz "https://github.com/dobrevit/haproxy-lua-dnsbl/archive/refs/tags/$DNSBL_VERSION.tar.gz" && \
    tar -xzf /tmp/haproxy-lua-utils.tar.gz -C /tmp && \
    tar -xzf /tmp/haproxy-lua-dnsbl.tar.gz -C /tmp && \
    mkdir -p /app/lib && \
    cp -r /tmp/haproxy-lua-utils-*/src/lib /app && \
    cp -r /tmp/haproxy-lua-dnsbl-*/src/* /app

FROM mclueppers/haproxy-lua-base:v0.1.1

RUN mkdir -p /etc/haproxy/lua/

COPY --from=sources /app/* /etc/haproxy/lua
COPY haproxy.cfg /etc/haproxy/haproxy.cfg
