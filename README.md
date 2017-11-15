# istex-api-kibana

[![trello board](https://user-images.githubusercontent.com/328244/32807531-72d5f4ca-c990-11e7-961e-8e06d34e2ef7.png)](https://trello.com/b/BBKDj5Dd/istex-api-kibana)

Dashboard kibana des données disponibles en production sur la plateforme ISTEX:
https://api-kibana.istex.fr (prochainement disponible)

Pour :
- proposer une vitrine orientée données aux utilisateurs finaux,
- permettre de visuellement naviguer dans les données de la plateforme ISTEX pour des besoins internes de compréhension et de diagnostiques afin de mieux cibler les chantiers de curration et d'amélioration des données.

Ces même données sont également accessible programatiquement sur l'[API ISTEX](https://api.istex.fr).

![anim](https://user-images.githubusercontent.com/328244/32807575-9651c5c8-c990-11e7-9610-4cbb19dd6734.gif)


## Pré-requis

- [Docker](https://docs.docker.com/engine/installation/) (Version ⩾ 17.09.0)
- [Docker Compose](https://docs.docker.com/compose/install/) (Version ⩾ 1.17.0)

## Lancer l'application

```shell
make run-debug
```

Ensuite vous devez importez manuellement le modèle de tableau de bord Kibana en vous rendant dans ![Management](https://user-images.githubusercontent.com/328244/32851436-3a80c0fa-ca35-11e7-8744-bc7ec552aa0c.png) puis en cliquant sur ![Import](https://user-images.githubusercontent.com/328244/32851531-778dd172-ca35-11e7-8fa7-b7ca0c8bc7d9.png) et finalement en sélectionnant le fichier export.json présent dans le répertoire ``data/kibana/export.json`` :
![](https://user-images.githubusercontent.com/328244/32851512-69f484fc-ca35-11e7-91a2-4881022c37fc.png)
Cette opération est à faire une seule fois après le premier lancement de l'application.

Vous devez ensuite initialiser ElasticSearch avec les données venant de l'API ISTEX (cf section suivante).

## Initialisation des données

A faire dans un autre terminal une fois que l'application est lancée.

```shell
make load-istex-data
```

Cette commande va charger 100 métadonnées de documents aléatoirement trouvées sur l'API ISTEX dans L'ElasticSearch de istex-api-kibana.

## Comment archiver un nouveau tableau de bord

Si vous désirez d'enrichire le tableau de bord istex-api-kibana, vous devez ensuite penser à sauvegarder le résultat.

Rendez vous alors dans ![Management](https://user-images.githubusercontent.com/328244/32851436-3a80c0fa-ca35-11e7-8744-bc7ec552aa0c.png) ensuite cliquez sur ![Export Everything](https://user-images.githubusercontent.com/328244/32851462-4db5756c-ca35-11e7-820a-4994188b117d.png) et sélectionnez l'emplacement ``data/kibana/export.json`` pour y sauvegarder le fichier ``export.json`` généré. N'oubliez pas ensuite de faire un ``git commit`` et un ``git push`` de ce fichier.