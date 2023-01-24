.PHONY: up
up: docker-networks iquidus-explorer

.PHONY: docker-networks
docker-networks:
	@docker network create local_backend > /dev/null 2>&1 || true

.PHONY: docker-network-cidr
docker-network-cidr: docker-networks
	@docker network inspect local_backend -f '{{(index .IPAM.Config 0).Subnet}}'

.PHONY: mongo
mongo:
	cd mongo && docker-compose up -d

.PHONY: nginx-proxy
nginx-proxy:
	cd nginx-proxy && docker-compose up -d

.PHONY: mincoind
mincoind:
	cidr=$$(make -s docker-network-cidr) && cd mincoind && RPC_ALLOW_IP=$$cidr docker-compose up -d

.PHONY: iquidus-explorer
iquidus-explorer: mongo mincoind nginx-proxy
	@echo -n "Please enter your Virtual Host: " ; read vhost ; \
	sed -i "s/\"address\": \"127.0.0.1:3001\",/\"address\": \"$$vhost\",/" iquidus-explorer/settings.json ; \
	cd iquidus-explorer && VIRTUAL_HOST=$$vhost docker-compose up -d --build
