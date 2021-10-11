NETS = pio-mainnet-1

all:

docker-build:
	for i in $(NETS); do \
		docker build --pull -t provenanceio/node:$$i-archive --build-arg CHAIN_ID=$$i -f docker/node/archive/Dockerfile .; \
		docker build --pull -t provenanceio/node:$$i --build-arg CHAIN_ID=$$i -f docker/node/visor/Dockerfile .; \
	done

docker-push:
	for i in $(NETS); do \
		docker push provenanceio/node:$$i-archive; \
		docker push provenanceio/node:$$i; \
	done
