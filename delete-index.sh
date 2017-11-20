#!/bin/bash

curl -XDELETE 'localhost:9200/istex-corpus-*?pretty' -H 'Content-Type: application/json'