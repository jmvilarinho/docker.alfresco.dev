include ../vars

NAME = queres/httpd-proxy-alfresco-alpine
VERSION = latest

APP_NAME=$(shell echo "$(NAME)" | tr -cd '[[:alnum:]]')_$(VERSION)

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build: Dockerfile ## Build the container
	docker build --build-arg FILESERVER_PASSWORD=$(FILESERVER_PASSWORD) -t $(NAME):$(VERSION) .

run: ## Run container
	docker run -p 81:80  -p 444:443 -e "MEMBERS=nodo1,nodo2" -d --name="$(APP_NAME)" $(NAME):$(VERSION)

logs: ## Get shell inside container
	docker logs "$(APP_NAME)" -f

shell: ## Get shell inside container
	docker exec -it "$(APP_NAME)" /bin/bash

stop: ## Stop running containers
	docker stop "$(APP_NAME)"
	docker rm "$(APP_NAME)"

up: build run ## Build and run

push: build ## Push image to Amazon
	docker tag "$(NAME):$(VERSION)"  $(REPOSITORY)/$(NAME):$(VERSION)
	docker push $(REPOSITORY)/$(NAME):$(VERSION)
	docker tag "$(NAME):$(VERSION)"  $(REPOSITORY)/$(NAME):2.0
	docker push $(REPOSITORY)/$(NAME):2.0
