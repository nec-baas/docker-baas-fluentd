NAME = necbaas/baas-fluentd

all: image

image: Dockerfile
	docker build -t $(NAME) .

rmi:
	docker image rm $(NAME)

bash:
	docker container run -it --rm --entrypoint /bin/bash $(NAME)

start:
	docker container run -d $(PORT_OPTS) $(VOLUME_OPTS) $(NAME)

push:
	docker image push $(NAME)
