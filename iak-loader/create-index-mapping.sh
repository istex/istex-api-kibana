#!/bin/bash
 
wait-for-elasticsearch-to-be-ready.sh

echo -n "Only one node so do not replicate anything:"
echo '{
    "index.number_of_replicas" : "0"
}' | curl -s -H 'Content-Type: application/json' \
          -XPUT "$ELASTICSEARCH_URL/_all/_settings?preserve_existing=true" \
          -d @-
echo ""

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


  # only one node so do not replicate anything
  echo '{
      "index.number_of_replicas" : "0"
  }' | curl -s -H 'Content-Type: application/json' \
            -XPUT "$ELASTICSEARCH_URL/istex-corpus-${CORPUS}/_settings" \
            -d @- \
    | jq -r '"Replicas set to 0 because only one node: \(.acknowledged)"'
done