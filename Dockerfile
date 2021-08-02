### Stage 0 - Build for MUSL

FROM python:3.9.6-alpine3.14 as builder

WORKDIR /install

RUN apk --no-cache add \
    autoconf \
    automake \
    build-base \
    boost-dev \
    curl \
    cmake \
    g++ \
    gcc \
    git \
    gmp-dev \
    libffi-dev \
    libsodium-dev \
    libsodium-static \
    make \
    nasm \
    openssl-dev \
    openssl-libs-static \
    pkgconf \
    py3-wheel \
    samurai \
    yasm

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    source $HOME/.cargo/env && \
    OPENSSL_NO_VENDOR=1 pip install --prefix="/install" \
    git+https://github.com/petanix/chia-blockchain@1.2.3-petanix


### Stage 1 - Final Image

FROM python:3.9.6-alpine3.14

COPY --from=builder /install /usr/local
