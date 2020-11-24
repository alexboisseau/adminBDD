# TP08

## Première partie (consigne)

Créez un fichier docker-compose qui réunit

- Un serveur mariaDB
- Un serveur prometheus
- Un serveur mysql-exporter

Et relier les entre eux.

## Première partie (rendu)

Pour cette première partie j'ai tout simplement créé un docker-compose avec trois services :

- mariadb : notre serveur de base de données
- prometheus : notre serveur d'agrégation de données
- mysql-exporter : exporter mysql connecté à notre base données, source de données du serveur prometheus.

Le service `mariaDb` est instancié sur le port `3306`, `l'exporter mysql` sur le port `9104` avec une connexion au serveur mariadb. Pour cette connexion j'aurai pû créer un nouvel utilisateur pour me connecter à la bdd, ici je me connecte directement avec root. Puis enfin, le service `prometheus` qui est instancié sur le port `9090` mais qui est aussi connecté au port `9090` de mon `localhost`.

Pour ce qui est de les relier entre eux, on aurait pû créer un réseau avec Docker et leur assigner mais par défaut, avec `docker-compose`, les containers seront dans le même réseau. On pourra donc utiliser leur nom comme nom d'hôte, docker s'occupera de faire les résolutions d'addresses IPs comme un grand 😎.

## Deuxième partie (consigne)

1- Créez un graphique qui affiche toutes les opérations de lectures et d'écritures.  
2- Créez un graphique qui affiche la variation du taux d'opérations de lectures et d'écritures en prenant en compte la moyenne sur les 5 dernières minutes

## Deuxième partie (rendu)

Jusqu'ici, à aucun moment on indique une source de données au service Prometheus. On va donc commencer par ajouter un volume à ce service dans le fichier `docker-compose`. Ce volume permettra au container d'accéder à un nouveau fichier : `prometheus.yml`. Dans celui-ci on va trouver quelques données basiques mais essentielles au bon fonctionnement de tout ce système. Premièrement on indique l'intervalle de temps d'analyse des données, ensuite on indique la destination d'envoi des données (ici ça sera sur le `localhost:9090`) puis enfin la source des données, ce qui correspond au service `exporter-mysql`, accessible au `mysql-exporter:9104`.

#### Graphique avec les opérations de lecture & écriture

Je me suis rendu compte que j'aurai sûrement dû utiliser un autre utilisateur que root pour des soucis de visibilité. J'ai l'impression que l'utilisateur `root` effectue des requêtes que l'on ne voit pas directement.

[Lectures & Ecritures](./images/lectures-ecritures.png?raw=true)  
[variation du taux d'opérations de lectures et d'écritures (moyenne de 5min)](./images/moyenne.png?raw=true)
