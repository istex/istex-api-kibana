#!/bin/bash

for DOC_IDX in $(seq 1 100000)
do
  ISTEX_JSON_DOC=$(curl -s "https://api.istex.fr/document/?q=*&output=*&rankBy=random&size=1&sid=istex-kibana" | jq '.hits[0]')
  ISTEX_ID=$(echo $ISTEX_JSON_DOC | jq -r .id)
  ISTEX_CORPUS=$(echo $ISTEX_JSON_DOC | jq -r .corpusName)
  echo $ISTEX_JSON_DOC | curl -s -XPUT -H 'Content-Type: application/json' "http://localhost:9200/istex-corpus-$ISTEX_CORPUS/doc/$ISTEX_ID" -d @- | \
    jq -r "\"Document #$DOC_IDX $ISTEX_ID ($ISTEX_CORPUS): \(.result)\""
done
