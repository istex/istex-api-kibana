# istex-kibana

[![trello board](https://raw.githubusercontent.com/Inist-CNRS/ezmaster/master/doc/trello_20x20.png)](https://trello.com/b/BBKDj5Dd/istex-kibana)

Dashboard kibana des données de la plateforme ISTEX.

Pour :
- proposer une vitrine orientée données aux utilisateurs finaux et,
- permettre de visuellement naviguer dans les données de la plateforme ISTEX pour des besoins internes de compréhension et de diagnostiques afin de mieux cibler les chantiers de curration et d'amélioration des données.


## Pré-requis

- [Docker](https://docs.docker.com/engine/installation/) (Version ⩾ 17.09.0)
- [Docker Compose](https://docs.docker.com/compose/install/) (Version ⩾ 1.17.0)

## Lancer l'application

```shell
make run-debug
```

## Initialisation des données

A faire dans un autre terminal une fois que l'application est lancée.

```shell
make load-istex-data
```
