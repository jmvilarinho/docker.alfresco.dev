

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

up: ## Build and run
	docker-compose up -d --build

run: ## Run
	docker-compose up -d

logs: ## Show logs
	docker-compose logs -f

stop: ## Clear resources
	docker-compose down
	docker-compose rm -f -v

awslogin: ## Get login command in Amazon AWS with local credentials file
	docker run -v ~/.aws:/root/.aws cgswong/aws:latest aws ecr get-login --region eu-west-1 
