FROM ubuntu:16.04

# jq for parsing JSON
# curl for requestion ISTEX API and loading data into elasticsearch
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update && apt-get -y install vim curl jq

COPY ./wait-for-elasticsearch-to-be-ready.sh /bin/wait-for-elasticsearch-to-be-ready.sh
COPY ./create-index-mapping.sh       /bin/create-index-mapping.sh
COPY ./load-random-istex-doc.sh      /bin/load-random-istex-doc.sh
COPY ./load-random-istex-doc-bulk.sh /bin/load-random-istex-doc-bulk.sh
COPY ./docker-entrypoint.sh          /bin/docker-entrypoint.sh

ENTRYPOINT [ "docker-entrypoint.sh" ]
