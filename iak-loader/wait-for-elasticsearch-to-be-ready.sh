#!/bin/bash
# Script looping until the elasticsearch cluster is ready 

ret=1
while [ $ret -gt 0 ]
do
  ES_STATUS=$(curl -s "$ELASTICSEARCH_URL/_cluster/health?wait_for_status=yellow&timeout=5s" | jq -r .status)
  if [ "${ES_STATUS}" == "red" ] || [ "${ES_STATUS}" == "" ] ; then
    # echo -n "."
    sleep 1s
    ret=1
  else
    ret=0
  fi
done
