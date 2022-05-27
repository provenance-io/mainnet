# Buildtime container
FROM debian:bullseye-slim
ARG CHAIN_ID
ENV CHAIN_ID=$CHAIN_ID PIO_HOME=/home/provenance

# Check for mandatory build arguments
RUN if [ -z "${CHAIN_ID}" ]; then echo "Build argument needs to be set and non-empty"; exit 1; fi

ADD $CHAIN_ID/genesis-version.txt /$CHAIN_ID/genesis-version.txt

RUN apt update && \
    apt install -y ca-certificates unzip wget jq libleveldb-dev && \
    ln -s /usr/lib/x86_64-linux-gnu/libleveldb.so.1d /usr/lib/x86_64-linux-gnu/libleveldb.so.1

RUN GENESIS_VERSION="$(cat /$CHAIN_ID/genesis-version.txt)" && \
    PIO_URL="https://github.com/provenance-io/provenance/releases/download/${GENESIS_VERSION}" && \
    PIO_ZIP="provenance-linux-amd64-${GENESIS_VERSION}.zip" && \
    echo "Fetching ${PIO_URL}/${PIO_ZIP}" && \
    mkdir -p "${PIO_HOME}/data" && \
    wget "${PIO_URL}/${PIO_ZIP}" && \
    unzip "${PIO_ZIP}" && \
    mv ./bin/provenanced /usr/bin/ && \
    mv ./bin/libwasmvm.so /usr/lib

ADD $CHAIN_ID /$CHAIN_ID/
ADD docker/node/archive/docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["sh", "-c", "/usr/bin/provenanced start $(cat /$CHAIN_ID/extra-args.txt)"]
