RED=\033[0;31m
NC=\033[0m

.PHONY: help
.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## build localy docker images needed by istex-kibana
	docker-compose -f ./docker-compose.debug.yml build

check-sysctl:
	@if [ "$$(/sbin/sysctl -n vm.max_map_count)" -lt "262144" ]; then echo "${RED}You have to set vm.max_map_count greater than 262144 or elasticsearch will not start${NC}"; echo "${RED}see: https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#docker-cli-run-prod-mode${NC}"; exit 1; fi

run-prod: check-sysctl ## run istex-kibana with prod parameters
	docker-compose up -d rp

run-debug: check-sysctl ## run istex-kibana with debug parameters
	google-chrome http://127.0.0.1:8080/ &
	docker-compose -f ./docker-compose.debug.yml up

load-istex-data: ## load random istex documents in the elasticsearch
	./load-random-istex-doc.sh

cleanup-data: ## destroy all the elasticsearch data the hard way
	docker-compose -f ./docker-compose.debug.yml kill
	rm -rf data/elastic/data/*

change-password: ## modify elastic and kibana default password
	docker exec -it iak-elastic bin/x-pack/setup-passwords interactive