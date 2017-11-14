.PHONY: help
.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## build localy docker images needed by istex-kibana
	docker-compose -f ./docker-compose.debug.yml build

run-prod: ## run istex-kibana with prod parameters
	docker-compose up -d rp

run-debug: ## run istex-kibana with debug parameters
	docker-compose -f ./docker-compose.debug.yml up

load-istex-data: ## load 100 random istex documents in the elasticsearch
	./load-100-random-istex-doc.sh

