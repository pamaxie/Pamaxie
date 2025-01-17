# Rust as the base image
FROM rust:latest
EXPOSE 80
EXPOSE 443

# 1. Create a new empty shell project
RUN USER=root cargo new --bin pamaxie_scan_api
WORKDIR /Pamaxie

# 2. Copy our manifests
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

# 3. We need to copy the source too here, since we can't just build the dependencies.
COPY ./src ./src

#4. Copy the target directory so we don't have to rebuild all the individual packages
COPY ./target/ ./target
RUN cargo build --release
RUN rm src/*.rs

# 4. Now that the dependency is built, copy your source code
COPY ./src ./src

# 5. Build for release.
RUN rm ./target/release/deps/pamaxie_scan_api*
RUN cargo install --path .
ENV RUST_RUNNING_IN_CONTAINER=true

CMD ["pamaxie_scan_api"]



