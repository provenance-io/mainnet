NET = pio-mainnet-1

all:

docker-build:
	docker build -t provenanceio/node:$(NET)-archive --build-arg CHAIN_ID=$(NET) -f docker/node/archive/Dockerfile . && \
	docker build -t provenanceio/node:$(NET) --build-arg CHAIN_ID=$(NET) -f docker/node/visor/Dockerfile .

docker-push:
	docker push provenanceio/node:$(NET)-archive && \
	docker push provenanceio/node:$(NET)

docker-run: docker-build
	docker run -it provenanceio/node:$(NET)
