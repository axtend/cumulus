# This file is sourced from https://github.com/axiatech/axia/blob/master/scripts/dockerfiles/axia/axia_builder.Dockerfile
# This is the build stage for Axia-collator. Here we create the binary in a temporary image.
FROM docker.io/axiatech/ci-linux:production as builder

WORKDIR /cumulus
COPY . /cumulus

RUN cargo build --release --locked -p axia-collator

# This is the 2nd stage: a very small image where we copy the Axia binary."
FROM docker.io/library/ubuntu:20.04

LABEL io.axia.image.type="builder" \
    io.axia.image.authors="devops-team@axia.io" \
    io.axia.image.vendor="Axia Technologies" \
    io.axia.image.description="Multistage Docker image for Axia-collator" \
    io.axia.image.source="https://github.com/axiatech/axia/blob/${VCS_REF}/docker/test-allychain-collator.dockerfile" \
    io.axia.image.documentation="https://github.com/axiatech/cumulus"

COPY --from=builder /cumulus/target/release/axia-collator /usr/local/bin

RUN useradd -m -u 1000 -U -s /bin/sh -d /cumulus axia-collator && \
    mkdir -p /data /cumulus/.local/share && \
    chown -R axia-collator:axia-collator /data && \
    ln -s /data /cumulus/.local/share/axia-collator && \
# unclutter and minimize the attack surface
    rm -rf /usr/bin /usr/sbin && \
# check if executable works in this container
    /usr/local/bin/axia-collator --version

USER axia-collator

EXPOSE 30333 9933 9944 9615
VOLUME ["/data"]

ENTRYPOINT ["/usr/local/bin/axia-collator"]
