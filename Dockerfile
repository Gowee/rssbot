# Modified based on
# https://github.com/rust-lang-nursery/docker-rust-nightly/blob/master/nightly/Dockerfile
FROM buildpack-deps:stretch as builder
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=nightly-2018-06-13
RUN set -eux; \
    \
    url="https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init"; \
    wget "$url"; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --default-toolchain $RUST_VERSION; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version;
WORKDIR /usr/src/rssbot
COPY . .
RUN cargo install --path . --root /usr/local

FROM debian:stretch
RUN set -eux; \
    \
	apt-get update; \
	apt-get install -y --no-install-recommends \
        ca-certificates \
		libcurl4-openssl-dev \
		libssl-dev \
	; \
    rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local/bin/rssbot /usr/local/bin/rssbot
WORKDIR /
COPY ./entrypoint.sh /
ENTRYPOINT ["sh", "entrypoint.sh"]