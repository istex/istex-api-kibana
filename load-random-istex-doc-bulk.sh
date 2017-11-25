#!/bin/bash

NB_DOCS_TO_LOAD=500

echo "Bulk loading $NB_DOCS_TO_LOAD document from the ISTEX API."
curl -s "https://api.istex.fr/document/?q=*&output=*&rankBy=random&size=${NB_DOCS_TO_LOAD}&sid=istex-kibana" | \
  jq -c '.hits[] | {"index": {"_index": "istex-corpus-\(.corpusName)", "_type": "doc", "_id": .id}}, .' | \
  curl -s -H "Content-Type: application/x-ndjson" -XPOST localhost:9200/_bulk --data-binary @- >/dev/null
echo "Bulk loading finished."