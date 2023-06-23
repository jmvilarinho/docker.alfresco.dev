include vars
SUBDIRS =	queres.postfix-alpine queres.httpd-proxy-alfresco-alpine \
					queres.base-alfresco-4.1        queres.alfresco-4.1 queres.alfresco-solr-4.1 \
					queres.base-alfresco-4.2        queres.alfresco-4.2 queres.alfresco-solr-4.2 \
					queres.base-alfresco-5.1-alpine queres.alfresco-5.1 queres.alfresco-solr4-5.1 \
					queres.base-alfresco-5.2-alpine queres.alfresco-5.2 queres.alfresco-solr4-5.2 queres.alfresco-solr6\

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build: ## Build the container in subdirectories
	@for d in $(SUBDIRS); do \
		( $(MAKE) -C $$d $@ ) || exit $$?; \
	done

clean:  ## Remove unused images
	-docker volume rm `docker volume ls -qf dangling=true`
	-docker rm `docker ps -a -q`
	-docker rmi `docker images -f dangling=true -q`

remove:  ## Remove all data
	-docker ps -q | xargs docker stop
	-docker rm -f `docker ps -a -q`
	-docker rmi -f `docker images -q`
	-docker volume rm -f `docker volume ls -q`

awslogin: ## Get login command in Amazon AWS with local credentials file
	docker run -v ~/.aws:/root/.aws cgswong/aws:latest aws ecr get-login --region eu-west-1

awsloginwin: ## Get login command in Amazon AWS with local credentials file
	docker run -v C:/Users/jvilfig/.aws:/root/.aws cgswong/aws:latest aws ecr get-login --region eu-west-1
	
	

push: ## Build the container in subdirectories
	@for d in $(SUBDIRS); do \
		( $(MAKE) -C $$d $@ ) || exit $$?; \
	done

stopall: ## Stop all containers
	docker ps -q | xargs docker stop

alf41: ## Run Alfresco 4.1
	docker-compose -p alfresco41 -f ./docker-compose-alfresco-4.1.10.4-platform.yml up

alf42: ## Run Alfresco 4.2
	docker-compose -p alfresco42 -f ./docker-compose-alfresco-4.2.4.20-platform.yml up

alf51: ## Run Alfresco 5.1
	docker-compose -p alfresco51 -f ./docker-compose-alfresco-5.1.3.2-platform.yml up

alf52: ## Run Alfresco 5.2
	docker-compose -p alfresco52 -f ./docker-compose-alfresco-5.2.1-platform.yml up

solr6: ## Run Alfresco 5.2 with solr6
	docker-compose -p solr6 -f ./docker-compose-alfresco-solr6-5.2.1-platform.yml up
