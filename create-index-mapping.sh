#!/bin/bash
 
CORPUS_LIST=$(curl -s https://api.istex.fr/corpus/ | jq -r '.[].key')

for CORPUS in $CORPUS_LIST
do
  curl -XPUT "localhost:9200/istex-corpus-${CORPUS}?pretty" -H 'Content-Type: application/json' -d'
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
          },
          "namedEntities": {
            "properties": {
              "unitex": {
                "properties": {
                  "date": {
                    "type": "date"
                  }
                }
              }
            }
          }          
        }
      }
    }
  }
  '
done