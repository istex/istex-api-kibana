#!/bin/bash
 
wait-for-elasticsearch-to-be-ready.sh

CORPUS_LIST=$(curl -s $IAK_ISTEX_API_URL/corpus/ | jq -r '.[].key')

for CORPUS in $CORPUS_LIST
do
  curl -XPUT "$ELASTICSEARCH_URL/istex-corpus-${CORPUS}?pretty" -H 'Content-Type: application/json' -d'
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
  '
done