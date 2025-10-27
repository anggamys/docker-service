FROM ubuntu:22.04 AS builder
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential autoconf automake libtool cmake pkg-config \
    git gengetopt wget ca-certificates \
    libmicrohttpd-dev libjansson-dev libssl-dev libsrtp2-dev libnice-dev \
    libglib2.0-dev libopus-dev libogg-dev libcurl4-openssl-dev \
    libwebsockets-dev libsofia-sip-ua-dev liblua5.3-dev \
    libconfig-dev zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/janus-gateway
RUN git clone --branch v1.3.1 --depth 1 https://github.com/meetecho/janus-gateway.git .
RUN sh autogen.sh && \
    ./configure --prefix=/usr/local \
      --disable-rabbitmq \
      --disable-mqtt \
      --disable-plugin-sip \
      --disable-plugin-videocall && \
    make -j"$(nproc)" && make install && make configs

# Stage runtime
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates tini \
    libmicrohttpd12 libjansson4 libssl3 libsrtp2-1 libnice10 \
    libglib2.0-0 libopus0 libogg0 libcurl4 libwebsockets16 \
    libsofia-sip-ua0 liblua5.3-0 libconfig9 zlib1g \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local /usr/local
COPY conf /usr/local/etc/janus

ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib/x86_64-linux-gnu
WORKDIR /usr/local/etc/janus

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/local/bin/janus", "-F", "/usr/local/etc/janus"]

EXPOSE 8088 8188 10000-10200/udp

