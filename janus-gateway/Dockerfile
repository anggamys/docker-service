FROM ubuntu:22.04 AS builder
ENV DEBIAN_FRONTEND=noninteractive

# Instal dependensi build
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential autoconf automake libtool cmake pkg-config \
    git gengetopt wget ca-certificates \
    libmicrohttpd-dev libjansson-dev libssl-dev libsrtp2-dev libnice-dev \
    libglib2.0-dev libopus-dev libogg-dev libcurl4-openssl-dev \
    libwebsockets-dev libsofia-sip-ua-dev liblua5.3-dev \
    libconfig-dev zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN git clone --branch v1.3.1 --depth 1 https://github.com/meetecho/janus-gateway.git

WORKDIR /opt/janus-gateway
RUN sh autogen.sh \
    && ./configure \
    --prefix=/usr/local \
    --disable-rabbitmq \
    --disable-mqtt \
    --disable-plugin-sip \
    --disable-plugin-lua \
    --disable-plugin-textroom \
    --disable-plugin-echotest \
    && make -j"$(nproc)" \
    && make install \
    && make configs \
    && strip /usr/local/bin/janus

# --- Stage produksi ---
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates tini \
    libmicrohttpd12 libjansson4 libssl3 libsrtp2-1 libnice10 \
    libglib2.0-0 libopus0 libogg0 libcurl4 libwebsockets16 \
    libsofia-sip-ua0 liblua5.3-0 libconfig9 zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Salin hasil build
COPY --from=builder /usr/local /usr/local

# Jalankan via tini agar clean shutdown
ENTRYPOINT ["/usr/bin/tini", "--"]

# Environment & expose port
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib/x86_64-linux-gnu
EXPOSE 8088/tcp 8188/tcp 10000-10200/udp
CMD ["/usr/local/bin/janus", "-F", "/usr/local/etc/janus"]
