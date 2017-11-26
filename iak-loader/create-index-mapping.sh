#!/bin/bash
 
wait-for-elasticsearch-to-be-ready.sh

CORPUS_LIST=$(curl -s $IAK_ISTEX_API_URL/corpus/ | jq -r '.[].key')

for CORPUS in $CORPUS_LIST
do
  echo '
    {
      "mappings": {
        "doc": {
          "properties": {
            "host": {
              "properties": {
                "publicationDate": {
                  "type": "date"
                },
                "copyrightDate": {
                  "type": "date"
                }
              }
            },
            "publicationDate": {
              "type": "date"
            },
            "copyrightDate": {
              "type": "date"
            }          
          }
        }
      }
    }
  ' | curl -s -H 'Content-Type: application/json' \
           -XPUT "$ELASTICSEARCH_URL/istex-corpus-${CORPUS}?pretty" \
           -d @- \
    | jq -r '"Mapping created for this index: \(.index)"'
done