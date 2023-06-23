NAME = queres/alfresco-5.1.3.2-sergas
VERSION = latest

APP_NAME=$(shell echo "$(NAME)" | tr -cd '[[:alnum:]]')_$(VERSION)

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build: ## Build the container
	docker build -t $(NAME):$(VERSION) ./alfresco-5.1.3.2-sergas

mount: ## Mount nestead filesystems
	-sudo mount nfs.queres.loc:/home/alfre1/compartido  /home/docker/queres.alfresco-5.1.3.2.calculon/nfs -t nfs -o rw,soft,timeo=3,retrans=6,intr,noatime
	-sudo mount nfs.queres.loc:/home/alfre1/sscc/volumen00000000  /home/docker/queres.alfresco-5.1.3.2.calculon/nfs/sscc/volumen00000000 -t nfs -o rw,soft,timeo=3,retrans=6,intr,noatime
	-sudo mount nfs.queres.loc:/home/alfre1/sscc/volumen00000001  /home/docker/queres.alfresco-5.1.3.2.calculon/nfs/sscc/volumen00000001 -t nfs -o rw,soft,timeo=3,retrans=6,intr,noatime
	-sudo mount nfs.queres.loc:/home/alfre1/sscc/volumen00000002  /home/docker/queres.alfresco-5.1.3.2.calculon/nfs/sscc/volumen00000002 -t nfs -o rw,soft,timeo=3,retrans=6,intr,noatime
	-sudo mount nfs.queres.loc:/home/alfre1/sscc/volumen00000003  /home/docker/queres.alfresco-5.1.3.2.calculon/nfs/sscc/volumen00000003 -t nfs -o rw,soft,timeo=3,retrans=6,intr,noatime
	-sudo mount nfs.queres.loc:/home/alfre1/eoxi_santiago/volumen00000000 /home/docker/queres.alfresco-5.1.3.2.calculon/nfs/eoxi_santiago/volumen00000000 -t nfs -o rw,soft,timeo=3,retrans=6,intr,noatime
	-sudo mount nfs.queres.loc:/home/alfre1/eoxi_santiago/volumen00000001 /home/docker/queres.alfresco-5.1.3.2.calculon/nfs/eoxi_santiago/volumen00000001 -t nfs -o rw,soft,timeo=3,retrans=6,intr,noatime
	-sudo mount nfs.queres.loc:/home/alfre1/eoxi_santiago/volumen00000002 /home/docker/queres.alfresco-5.1.3.2.calculon/nfs/eoxi_santiago/volumen00000002 -t nfs -o rw,soft,timeo=3,retrans=6,intr,noatime
	-sudo mount nfs.queres.loc:/home/alfre1/eoxi_santiago/volumen00000003 /home/docker/queres.alfresco-5.1.3.2.calculon/nfs/eoxi_santiago/volumen00000003 -t nfs -o rw,soft,timeo=3,retrans=6,intr,noatime
	-sudo mount nfs.queres.loc:/home/alfre1/our/volumen00000000  /home/docker/queres.alfresco-5.1.3.2.calculon/nfs/our/volumen00000000  -t nfs -o rw,soft,timeo=3,retrans=6,intr,noatime
	-sudo mount nfs.queres.loc:/home/alfre1/hula/volumen00000000  /home/docker/queres.alfresco-5.1.3.2.calculon/nfs/hula/volumen00000000  -t nfs -o rw,soft,timeo=3,retrans=6,intr,noatime
	-sudo mount nfs.queres.loc:/home/alfre1/hula/volumen00000001  /home/docker/queres.alfresco-5.1.3.2.calculon/nfs/hula/volumen00000001 -t nfs -o rw,soft,timeo=3,retrans=6,intr,noatime
	-sudo mount nfs.queres.loc:/home/alfre1/chus/volumen00000000  /home/docker/queres.alfresco-5.1.3.2.calculon/nfs/chus/volumen00000000 -t nfs -o rw,soft,timeo=3,retrans=6,intr,noatime
	-sudo mount nfs.queres.loc:/home/alfre1/chus/volumen00000001  /home/docker/queres.alfresco-5.1.3.2.calculon/nfs/chus/volumen00000001 -t nfs -o rw,soft,timeo=3,retrans=6,intr,noatime

umount: ## Umount nestead filesystems
	-sudo umount nfs.queres.loc:/home/alfre1/compartido
	-sudo umount nfs.queres.loc:/home/alfre1/sscc/volumen00000000
	-sudo umount nfs.queres.loc:/home/alfre1/sscc/volumen00000001
	-sudo umount nfs.queres.loc:/home/alfre1/sscc/volumen00000002
	-sudo umount nfs.queres.loc:/home/alfre1/sscc/volumen00000003
	-sudo umount nfs.queres.loc:/home/alfre1/eoxi_santiago/volumen00000000
	-sudo umount nfs.queres.loc:/home/alfre1/eoxi_santiago/volumen00000001
	-sudo umount nfs.queres.loc:/home/alfre1/eoxi_santiago/volumen00000002
	-sudo umount nfs.queres.loc:/home/alfre1/eoxi_santiago/volumen00000003
	-sudo umount nfs.queres.loc:/home/alfre1/our/volumen00000000
	-sudo umount nfs.queres.loc:/home/alfre1/hula/volumen00000000
	-sudo umount nfs.queres.loc:/home/alfre1/hula/volumen00000001
	-sudo umount nfs.queres.loc:/home/alfre1/chus/volumen00000000
	-sudo umount nfs.queres.loc:/home/alfre1/chus/volumen00000001

up: ## Build and run
	docker-compose up -d --force-recreate

run: ## Run
	docker-compose up -d

logs: ## Show logs
	docker-compose logs -f

stop: ## Stop resources
	docker-compose stop

rm: ## Delete resources
	docker-compose rm -f

clean:  ## Remove images
	-docker rm -f `docker ps -a -q`
	-docker rmi -f `docker images -q`

sync: ## Get original files
	rsync -av --delete \
	--exclude /nfs* \
	--exclude /logs.nodo* \
	--exclude /amps* \
	--exclude /Makefile \
	docker@calculon.queres.loc:/home/docker/queres.alfresco-5.1.3.2.calculon/* .
