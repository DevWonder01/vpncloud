FROM rust:1.76 as builder

WORKDIR /app
COPY . .
RUN cargo build --release

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y iproute2 && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=builder /app/target/release/vpncloud /usr/local/bin/vpncloud
COPY config.yaml /app/config.yaml

# Run as root to create TUN/TAP device
CMD ["vpncloud", "--config", "/app/config.yaml"]