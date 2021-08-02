### Stage 0 - Build for MUSL

FROM python:3.9.6-alpine3.14 as builder

ENV CXXFLAGS=-U_FORTIFY_SOURCE
ENV OPENSSL_NO_VENDOR=1

WORKDIR /install

RUN apk --no-cache add \
    autoconf \
    automake \
    boost-dev \
    build-base \
    cmake \
    curl \
    g++ \
    gcc \
    git \
    gmp-dev \
    libffi-dev \
    libsodium-dev \
    libsodium-static \
    llvm \
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
    pip install --prefix="/install" git+https://github.com/petanix/chia-blockchain@1.2.3-petanix


### Stage 1 - Final Image

FROM python:3.9.6-alpine3.14

LABEL maintainer "PetaniX Administrator <admin@petanix.id>"
LABEL org.opencontainers.image.source https://github.com/petanix/petanix-chia-docker

COPY --from=builder /install /usr/local
