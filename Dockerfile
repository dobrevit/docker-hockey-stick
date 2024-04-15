FROM alpine:3.19 as sources

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
    mkdir -p /lua/lib && \
    cp -r /tmp/haproxy-lua-utils-*/src/lib /lua && \
    cp -r /tmp/haproxy-lua-dnsbl-*/src/* /lua

FROM mclueppers/haproxy-lua-base:latest

RUN mkdir -p /etc/haproxy/lua/

COPY --from=sources /lua /etc/haproxy/lua
COPY haproxy.cfg /etc/haproxy/haproxy.cfg
