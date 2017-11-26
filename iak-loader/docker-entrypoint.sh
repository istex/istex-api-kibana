#!/bin/bash

/bin/create-index-mapping.sh

if [ "$IAK_LOAD_10_DOC" == "yes" ]; then
  echo "-> Loading 10 random documents from $IAK_ISTEX_API_URL"
  /bin/load-random-istex-doc.sh
fi

tail -f /dev/null
