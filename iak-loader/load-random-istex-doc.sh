#!/bin/bash
# Load 10 random document from the ISTEX API into the IAK elasticsearch

for DOC_IDX in $(seq 1 10)
do
  wait-for-elasticsearch-to-be-ready.sh

  ISTEX_JSON_DOC=$(curl -s "$IAK_ISTEX_API_URL/document/?q=*&output=*&rankBy=random&size=1&sid=istex-kibana" | jq '.hits[0]')
  ISTEX_ID=$(echo $ISTEX_JSON_DOC | jq -r .id)
  ISTEX_CORPUS=$(echo $ISTEX_JSON_DOC | jq -r .corpusName)
  echo $ISTEX_JSON_DOC | curl -s -XPUT -H 'Content-Type: application/json' "$ELASTICSEARCH_URL/istex-corpus-$ISTEX_CORPUS/doc/$ISTEX_ID" -d @- | \
    jq -r "\"Document #$DOC_IDX $ISTEX_ID ($ISTEX_CORPUS): \(.result)\""
done
