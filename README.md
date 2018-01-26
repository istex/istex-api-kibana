# istex-api-kibana

[![trello board](https://user-images.githubusercontent.com/328244/32807531-72d5f4ca-c990-11e7-961e-8e06d34e2ef7.png)](https://trello.com/b/BBKDj5Dd/istex-api-kibana) [![Build Status](https://travis-ci.org/istex/istex-api-kibana.svg?branch=master)](https://travis-ci.org/istex/istex-api-kibana) [![Docker Pulls](https://img.shields.io/docker/pulls/istex/istex-api-kibana.svg)](https://registry.hub.docker.com/u/istex/istex-api-kibana/)

Dashboard kibana des données disponibles en production sur la [plateforme ISTEX](http://www.istex.fr).

https://api-kibana.istex.fr (prochainement disponible)

Pour :
- proposer une vitrine orientée données aux utilisateurs finaux,
- permettre de visuellement naviguer dans les données de la plateforme ISTEX pour des besoins internes de compréhension et de diagnostiques afin de mieux cibler les chantiers de curration et d'amélioration des données.

Ces même données sont également accessibles programatiquement à travers l'[API ISTEX](https://api.istex.fr).

![anim](https://user-images.githubusercontent.com/328244/32807575-9651c5c8-c990-11e7-9610-4cbb19dd6734.gif)


## Pré-requis

- [Docker](https://docs.docker.com/engine/installation/) (Version ⩾ 17.05.0)
- [Docker Compose](https://docs.docker.com/compose/install/) (Version ⩾ 1.17.0)
- vm.max_map_count ⩾ 262144 ([see elasticsearch doc](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html#docker-cli-run-prod-mode))

## Lancer l'application en développement

```shell
IAK_ADMIN_USERNAME="istex-api-kibana" \
IAK_ADMIN_PASSWORD="changeme" \
make run-debug
```

Ouvrez alors un nouveau terminal et initialisez les données en lançant ce script :

```shell
make load-istex-data
```
(laissez la tourner en tache de fond pour charger 1000 documents)

Rendez alors sur http://127.0.0.1:8080/app/kibana et si c'est votre premier lancement, attendez un petit moment  pour qu'elasticsearch et kibana s'initialisent (cela peut prendre 2 minutes).

## Lancer l'application en production

```shell
# lancement de l'application (changez les variables nécessaires 
# comme par exemple le mot de passe)
# Notice: parameter "-Xmx10G -Xms10G" should not be set to more than 50% of available RAM
#         see https://www.elastic.co/guide/en/elasticsearch/reference/current/heap-size.html
mkdir istex-api-kibana/ && cd istex-api-kibana/
wget https://raw.githubusercontent.com/istex/istex-api-kibana/master/docker-compose.yml
mkdir -p logs/iak-rp/
mkdir -p data/elastic/data/
IAK_ADMIN_USERNAME="istex-api-kibana" \
IAK_ADMIN_PASSWORD="changeme" \
IAK_BASEURL="https://api-kibana.istex.fr" \
IAK_ELASTICSEARCH_JAVA_OPTS="-Xmx10G -Xms10G" \
IAK_ISTEX_API_URL="https://api.istex.fr" \
IAK_LOAD_10_DOC="yes" \
docker-compose up -d

# chargement des données ISTEX dans la base elasticsearch
docker exec -it iak-loader load-random-istex-doc-bulk.sh
```



Rendez alors sur ``http://<nom-du-serveur>:8080/`` ou sur https://api-kibana.istex.fr (nécessite la configuration préalable du reverse proxy), et attendez un petit moment  pour qu'elasticsearch et kibana s'initialisent (cela peut prendre 2 minutes), vous aurez alors le Kibana qui s'affichera. Suivez les instructions de la section suite au premier démarrage.

En cas de souci au démarrage, ``docker-compose logs`` pourra vous aiguiller.

## Configurer l'application à son premier lancement

Une fois que vous arrivez à afficher Kibana sur votre URL locale http://127.0.0.1:8080/app/kibana vous avez plusieurs opérations à réaliser manuellement (qui ne seront pas à réaliser au prochain redémarrage).

1) Configurer un "index pattern" au niveau du kibana, il faudra indiquer ``istex-corpus-*`` et ne pas séléctionner de champs pour le "Time filter". Cf copie d'écran :

![image](https://user-images.githubusercontent.com/328244/33234970-a257d37e-d22f-11e7-95e6-6b2826956695.png)

2) Vous devez ensuite importer manuellement le modèle de tableau de bord Kibana en vous rendant dans "Management"

![Management](https://user-images.githubusercontent.com/328244/32851436-3a80c0fa-ca35-11e7-8744-bc7ec552aa0c.png) 



puis en cliquant sur

![Import](https://user-images.githubusercontent.com/328244/32851531-778dd172-ca35-11e7-8fa7-b7ca0c8bc7d9.png) 



et finalement en sélectionnant le fichier ``export.json`` présent dans le répertoire ``data/kibana/export.json`` :



![](https://user-images.githubusercontent.com/328244/32851512-69f484fc-ca35-11e7-91a2-4881022c37fc.png)



Ces deux opérations ne sont à faire qu'une fois après le premier lancement de l'application. Notez également que kibana vous demandera de vous authentifier et vous aurez alors besoin du login/mot de passe défini dans les variables ``IAK_ADMIN_USERNAME`` et ``IAK_ADMIN_PASSWORD``.

## Chargement des données

Vous pouvez à tout moment charger de nouvelles données dans votre Kibana en lançant cette commande dans un autre terminal une fois que l'application est lancée.

```shell
docker exec -it iak-loader load-random-istex-doc-bulk.sh
```

Cette commande va charger des documents aléatoirement trouvées sur l'API ISTEX dans L'ElasticSearch de istex-api-kibana.

## Comment sauvegarder un nouveau tableau de bord

Si vous désirez d'enrichire les tableaux de bord d'istex-api-kibana faites le depuis l'interface Kibana, pensez alors à sauvegarder vos modifications (authentification nécessaire via ``IAK_ADMIN_USERNAME`` et ``IAK_ADMIN_PASSWORD``).

La dernière étape pour que ce soit sauvegardé dans le github est de vous rendre alors dans

![Management](https://user-images.githubusercontent.com/328244/32851436-3a80c0fa-ca35-11e7-8744-bc7ec552aa0c.png)

ensuite cliquez sur

![Export Everything](https://user-images.githubusercontent.com/328244/32851462-4db5756c-ca35-11e7-820a-4994188b117d.png)

et sélectionnez l'emplacement ``data/kibana/export.json`` pour y sauvegarder le fichier ``export.json`` généré. N'oubliez pas ensuite de faire un ``git commit`` et un ``git push`` de ce fichier.
