# ---------- build stage ----------
FROM ubuntu:22.04 AS builder
ENV DEBIAN_FRONTEND=noninteractive

# Tambah ca-certificates agar git clone HTTPS tidak gagal
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential autoconf automake libtool cmake pkg-config \
    git gengetopt wget ca-certificates \
    libmicrohttpd-dev libjansson-dev libssl-dev libsrtp2-dev libnice-dev \
    libglib2.0-dev libopus-dev libogg-dev libcurl4-openssl-dev \
    libwebsockets-dev libsofia-sip-ua-dev liblua5.3-dev \
    libconfig-dev zlib1g-dev \
    && update-ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
# Jika mau pin versi:
RUN git clone --branch v1.3.1 --depth 1 https://github.com/meetecho/janus-gateway.git
WORKDIR /opt/janus-gateway

RUN sh autogen.sh \
    && ./configure \
    --prefix=/usr/local \
    --disable-rabbitmq \
    --disable-mqtt \
    # --disable-data-channels    # (opsional) kalau tidak perlu SCTP/usrsctp
    && make -j"$(nproc)" \
    && make install \
    && make configs

# ---------- runtime stage ----------
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# Runtime libs yang dibutuhkan Janus (tanpa -dev)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libmicrohttpd12 libjansson4 libssl3 libsrtp2-1 libnice10 \
    libglib2.0-0 libopus0 libogg0 libcurl4 libwebsockets16 \
    libsofia-sip-ua0 liblua5.3-0 libconfig9 zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Salin hasil build
COPY --from=builder /usr/local /usr/local

# Set LD_LIBRARY_PATH tanpa warning jika kosong
ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib/x86_64-linux-gnu

EXPOSE 8088/tcp 8188/tcp 10000-10200/udp
CMD ["/usr/local/bin/janus", "-F", "/usr/local/etc/janus"]
