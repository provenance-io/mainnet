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

RUN mkdir -p ${DAEMON_HOME}/cosmovisor/genesis/bin && \
    cp /usr/bin/provenanced /usr/lib/libwasmvm.so ${DAEMON_HOME}/cosmovisor/genesis/bin/ && \
    ln -s /home/provenance/cosmovisor/genesis /home/provenance/cosmovisor/current

COPY --from=visor /usr/bin/cosmovisor /usr/bin/cosmovisor

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["sh", "-c", "/usr/bin/cosmovisor start $(cat /$CHAIN_ID/extra-args.txt)"]
