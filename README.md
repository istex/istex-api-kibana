# istex-api-kibana

[![trello board](https://user-images.githubusercontent.com/328244/32807531-72d5f4ca-c990-11e7-961e-8e06d34e2ef7.png)](https://trello.com/b/BBKDj5Dd/istex-api-kibana)

Dashboard kibana des données disponibles en production sur la [plateforme ISTEX](http://www.istex.fr).

https://api-kibana.istex.fr (prochainement disponible)

Pour :
- proposer une vitrine orientée données aux utilisateurs finaux,
- permettre de visuellement naviguer dans les données de la plateforme ISTEX pour des besoins internes de compréhension et de diagnostiques afin de mieux cibler les chantiers de curration et d'amélioration des données.

Ces même données sont également accessibles programatiquement à travers l'[API ISTEX](https://api.istex.fr).

![anim](https://user-images.githubusercontent.com/328244/32807575-9651c5c8-c990-11e7-9610-4cbb19dd6734.gif)


## Pré-requis

- [Docker](https://docs.docker.com/engine/installation/) (Version ⩾ 17.09.0)
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

Rendez alors sur http://128.0.0.1:8080//app/kibana et si c'est votre premier lancement, attendez un petit moment  pour qu'elasticsearch et kibana s'initialisent. 

Une fois que vous arrivez à afficher Kibana sur votre URL locale http://128.0.0.1:8080/app/kibana vous devez importer manuellement le modèle de tableau de bord Kibana en vous rendant dans ![Management](https://user-images.githubusercontent.com/328244/32851436-3a80c0fa-ca35-11e7-8744-bc7ec552aa0c.png) puis en cliquant sur ![Import](https://user-images.githubusercontent.com/328244/32851531-778dd172-ca35-11e7-8fa7-b7ca0c8bc7d9.png) et finalement en sélectionnant le fichier export.json présent dans le répertoire ``data/kibana/export.json`` :
![](https://user-images.githubusercontent.com/328244/32851512-69f484fc-ca35-11e7-91a2-4881022c37fc.png)
Cette opération est à faire une seule fois après le premier lancement de l'application. Vous aurez besoin du login/mot de passe défini dans les variables ``IAK_ADMIN_USERNAME`` et ``IAK_ADMIN_PASSWORD`` pour réaliser cela.

## Chargement des données

Vous pouvez à tout moment charger de nouvelles données dans votre Kibana en lançant cette commande dans un autre terminal une fois que l'application est lancée.

```shell
make load-istex-data
```

Cette commande va charger 1000 métadonnées de documents aléatoirement trouvées sur l'API ISTEX dans L'ElasticSearch de istex-api-kibana.

## Comment sauvegarder un nouveau tableau de bord

Si vous désirez d'enrichire les tableaux de bord d'istex-api-kibana faites le depuis l'interface Kibana, pensez alors à sauvegarder vos modifications (authentification nécessaire via ``IAK_ADMIN_USERNAME`` et ``IAK_ADMIN_PASSWORD``).

La dernière étape pour que ce soit sauvegardé dans le github est de vous rendre alors dans ![Management](https://user-images.githubusercontent.com/328244/32851436-3a80c0fa-ca35-11e7-8744-bc7ec552aa0c.png), ensuite cliquez sur ![Export Everything](https://user-images.githubusercontent.com/328244/32851462-4db5756c-ca35-11e7-820a-4994188b117d.png) et sélectionnez l'emplacement ``data/kibana/export.json`` pour y sauvegarder le fichier ``export.json`` généré. N'oubliez pas ensuite de faire un ``git commit`` et un ``git push`` de ce fichier.
