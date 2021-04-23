ARG CHAIN_ID

# Pull cosmovisor binary
FROM provenanceio/cosmovisor as visor

# Build out the specific cosmovisor archive node
FROM provenanceio/node:${CHAIN_ID}-archive as node
ENV CHAIN_ID=$CHAIN_ID

ENV PIO_HOME=/home/provenance \
    DAEMON_NAME=provenanced \
    DAEMON_HOME=/home/provenance \
    DAEMON_ALLOW_DOWNLOAD_BINARIES=true \
    DAEMON_RESTART_AFTER_UPGRADE=true \
    DAEMON_BACKUP_DATA_DIR=/home/provenance/data \
    LD_LIBRARY_PATH=/home/provenance/cosmovisor/current/bin

COPY --from=visor /usr/bin/cosmovisor /usr/bin/cosmovisor

# Docker entrypoint slightly differs from node's.
ADD docker/node/visor/docker-entrypoint.sh /docker-entrypoint.sh

# Create the daemon user
RUN useradd -ms /bin/bash -U provenance
RUN chown -R provenance:provenance /home/provenance

# Drop root privileges.
USER provenance:provenance
WORKDIR /home/provenance

# Mount the application's home dir.
VOLUME ["/home/provenance"]

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["sh", "-c", "/usr/bin/cosmovisor start $(cat /$CHAIN_ID/extra-args.txt)"]
