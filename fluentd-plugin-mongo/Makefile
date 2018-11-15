NAME = necbaas/fluentd-plugin-mongo

all: image

image: Dockerfile
	docker build -t $(NAME) .

clean:
	-/bin/rm Dockerfile

rmi:
	docker rmi $(NAME)

bash:
	docker run -it --rm $(NAME) /bin/bash

start:
	docker run -d $(PORT_OPTS) $(VOLUME_OPTS) $(NAME)

push:
	docker push $(NAME)
