# -*- coding: utf-8 -*-
# Created by Luis Enrique Fuentes Plata

SHELL = /bin/bash

.DEFAULT_GOAL := help

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

help: ## 6.-display this help message
	@ echo "Please use \`make <target>' where <target> is one of"
	@ perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-25s\033[0m %s\n", $$1, $$2}'
