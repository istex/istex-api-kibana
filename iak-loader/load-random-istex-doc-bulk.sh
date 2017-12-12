#!/bin/bash

DEBUG="1"
NB_CHUNK=1500
CHUNK_SIZE=500
NB_DOCS_TO_LOAD=$(($NB_CHUNK*$CHUNK_SIZE))
echo "Starting bulk loading $NB_DOCS_TO_LOAD document from $IAK_ISTEX_API_URL [$(date)]"

for CHUNK_IDX in $(seq 1 $NB_CHUNK)
do
  echo -n "-> "
  wait-for-elasticsearch-to-be-ready.sh

  if [ "$DEBUG" == "" ]; then
    echo -n "[$(($CHUNK_IDX*$CHUNK_SIZE))] Loading $CHUNK_SIZE documents from the ISTEX API, nb_loaded = "
    curl -s "$IAK_ISTEX_API_URL/document/?q=*&output=*&rankBy=random&size=${CHUNK_SIZE}&sid=istex-kibana" | \
      jq -c '.hits[] | {"index": {"_index": "istex-corpus-\(.corpusName)", "_type": "doc", "_id": .id}}, .' | \
      curl -s -H "Content-Type: application/x-ndjson" -XPOST $ELASTICSEARCH_URL/_bulk --data-binary @- | jq -c .items[].index.result | grep created | wc -l
  else
    echo "[$(($CHUNK_IDX*$CHUNK_SIZE))] Loading $CHUNK_SIZE documents from the ISTEX API (debug mode: null means no error)"
    curl -s "$IAK_ISTEX_API_URL/document/?q=*&output=*&rankBy=random&size=${CHUNK_SIZE}&sid=istex-kibana" | \
      jq -c '.hits[] | {"index": {"_index": "istex-corpus-\(.corpusName)", "_type": "doc", "_id": .id}}, .' | \
      curl -s -H "Content-Type: application/x-ndjson" -XPOST $ELASTICSEARCH_URL/_bulk --data-binary @- | jq -c '.items[] | .index.error'
  fi
done

echo "Finished bulk loading $NB_DOCS_TO_LOAD document from $IAK_ISTEX_API_URL [$(date)]"
