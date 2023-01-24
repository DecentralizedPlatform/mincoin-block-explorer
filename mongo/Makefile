.PHONY: up
up:
	docker-compose up -d

.PHONY: cli
cli:
	docker run --rm -it --net local_backend mongo:3.2.16 mongo mongodb://root:root@mongo:27017/admin
