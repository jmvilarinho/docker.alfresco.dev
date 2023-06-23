include ../vars

NAME = queres/alfresco-4.1
ALFRESCO_VERSION=4.1.10.4


APP_NAME=$(shell echo "$(NAME)" | tr -cd '[[:alnum:]]')_latest

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build: ## Build the container
	docker build --build-arg FILESERVER_PASSWORD=$(FILESERVER_PASSWORD) --build-arg ALFRESCO_VERSION=$(ALFRESCO_VERSION) -t $(NAME):latest .

run: ## Run container
	docker run --name="$(APP_NAME)" $(NAME):latest

logs: ## Show log
	docker logs "$(APP_NAME)" -f

shell: ## Get shell inside container
	docker exec -it "$(APP_NAME)" /bin/bash

stop: ## Stop running containers
	docker stop "$(APP_NAME)"
	docker rm "$(APP_NAME)"

up: build run ## Build and run

push: build ## Push image to Amazon
	docker tag "$(NAME):latest"  $(REPOSITORY)/$(NAME):latest
	docker push $(REPOSITORY)/$(NAME):latest
	docker tag "$(NAME):latest"  $(REPOSITORY)/$(NAME):$(ALFRESCO_VERSION)
	docker push $(REPOSITORY)/$(NAME):$(ALFRESCO_VERSION)
