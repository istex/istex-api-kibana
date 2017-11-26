#!/bin/bash

DEBUG="1"
NB_CHUNK=1500
CHUNK_SIZE=50
NB_DOCS_TO_LOAD=$(($NB_CHUNK*$CHUNK_SIZE))
echo "Starting bulk loading $NB_DOCS_TO_LOAD document from the ISTEX API [$(date)]"

for CHUNK_IDX in $(seq 1 $NB_CHUNK)
do
  echo -n "-> "
  ret=1
  while [ $ret -gt 0 ]
  do
    ES_STATUS=$(curl -s "http://localhost:9200/_cluster/health?wait_for_status=yellow&timeout=5s" | jq -r .status)
    if [ "${ES_STATUS}" == "red" ] || [ "${ES_STATUS}" == "" ] ; then
      echo -n "."
      sleep 1s
      ret=1
    else
      ret=0
    fi
  done

  if [ "$DEBUG" == "" ]; then
    echo -n "[$(($CHUNK_IDX*$CHUNK_SIZE))] Loading $CHUNK_SIZE documents from the ISTEX API, nb_loaded = "
    curl -s "https://api.istex.fr/document/?q=*&output=*&rankBy=random&size=${CHUNK_SIZE}&sid=istex-kibana" | \
      jq -c '.hits[] | {"index": {"_index": "istex-corpus-\(.corpusName)", "_type": "doc", "_id": .id}}, .' | \
      curl -s -H "Content-Type: application/x-ndjson" -XPOST localhost:9200/_bulk --data-binary @- | jq -c .items[].index.result | grep created | wc -l
  else
    echo "[$(($CHUNK_IDX*$CHUNK_SIZE))] Loading $CHUNK_SIZE documents from the ISTEX API (debug mode: null means no error)"
    curl -s "https://api.istex.fr/document/?q=*&output=*&rankBy=random&size=${CHUNK_SIZE}&sid=istex-kibana" | \
      jq -c '.hits[] | {"index": {"_index": "istex-corpus-\(.corpusName)", "_type": "doc", "_id": .id}}, .' | \
      curl -s -H "Content-Type: application/x-ndjson" -XPOST localhost:9200/_bulk --data-binary @- | jq -c '.items[] | .index.error'
  fi
done

echo "Finished bulk loading $NB_DOCS_TO_LOAD document from the ISTEX API [$(date)]"
