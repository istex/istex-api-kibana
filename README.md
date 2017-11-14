# istex-kibana

[![trello board](https://raw.githubusercontent.com/Inist-CNRS/ezmaster/master/doc/trello_20x20.png)](https://trello.com/b/BBKDj5Dd/istex-kibana)

Dashboard kibana des données ISTEX.

Pour :
- proposer une vitrine orientée données aux utilisateurs finaux et,
- permettre de visuellement naviguer dans les données ISTEX pour des besoins internes de compréhension et de diagnostiques afin de mieux cibler les chantiers de curration et d'amélioration des données.







TODO packager le script permettant de charger des documents ISTEX dans l'elasticsearch : 



for DOC_IDX in $(seq 1 100)
do
  ISTEX_JSON_DOC=$(curl -s "https://api.istex.fr/document/?q=*&output=*&rankBy=random&size=1&sid=istex-kibana" | jq '.hits[0]')
  ISTEX_ID=$(echo $ISTEX_JSON_DOC | jq -r .id)
  ISTEX_CORPUS=$(echo $ISTEX_JSON_DOC | jq -r .corpusName)
  echo $ISTEX_JSON_DOC | curl -XPUT "http://localhost:9200/istex-corpus-$ISTEX_CORPUS/doc/$ISTEX_ID" -d @-
done