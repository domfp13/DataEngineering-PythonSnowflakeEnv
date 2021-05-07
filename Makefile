# -*- coding: utf-8 -*-
# Created by Luis Enrique Fuentes Plata

SHELL = /bin/bash

.DEFAULT_GOAL := help

FILE_DIR := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))
FILE_DIR_NEW := $(subst /,\,$(FILE_DIR))

.PHONY: setup
setup: ## 1.-Create Docker Image based on Dockerfile
	@ echo "********** Building image **********"
	docker image build --rm -t python-runner .
	@ echo "********** Cleaning old version **********"
	docker image prune -f

.PHONY: build
build: ## 2.-Create containers in a virtual network
	@ echo "spinning up containers"
	docker-compose up -d

.PHONY: start
start: ## 3.-Setup and Build
	@ echo "Creating and Starting services"
	@ $(MAKE) setup
	@ $(MAKE) build

.PHONY: run-code-windows
run-code-w: ## 4.1.-Run main.py in Windows Git-Bash
	@ echo "Running python main"
	winpty docker exec -it docker-agent bash -c "python /usr/src/app/src/main.py"

.PHONY: run-code-linux
run-code-l: ## 4.2.-Run main.py in Unix System
	@ echo "Running"
	docker exec -it docker-agent bash -c "python /usr/src/app/src/main.py"

.PHONY: stop
stop: ## 5.-Stop and destroy services
	@ echo "Removing services"
	docker-compose down --rmi local

.PHONY: load-local
load-local: ## 6.- Runs .sql file (e.g. ´make load-local DATA="AP_TERMS.csv" SCRIPT="local_stage.sql"´)
	split -l 10 ./data/${DATA} ./data/pages
	snowsql -c developer -f .\stage_load\${SCRIPT}
	rm -rf ./data/pages*

.PHONY: load-cloud
load-cloud: ## 7.- Runs .sql file (e.g. ´make load-cloud SCRIPT="s3_stage.sql"´)
	snowsql -c developer -f .\stage_load\${SCRIPT}

help: ## 8.-display this help message
	@ echo "Please use \`make <target>' where <target> is one of"
	@ perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-25s\033[0m %s\n", $$1, $$2}'
