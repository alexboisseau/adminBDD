# TP00

## Première partie (consigne)

1- Créez un nouveau dashboard  
2- Ajoutez un panel avec un graphique du taux d'opérations READ  
3- Ajoutez un panel qui affiche simplement le nombre total de tentatives de connexion refusées  
4- Ajoutez un panel sous forme de compteur (gauge) qui affiche le temps nécessaire à l'exporter pour scrapper les données liées aux connections depuis le serveur MariaDB, trouvez un format et des limites adaptées.

## Première partie (rendu)

### Création des fichiers de config. 📂

Pour `grafana`, j'ai récupéré la configuration par défault officielle juste ici : https://github.com/grafana/grafana/blob/master/conf/defaults.ini

Pour ce qui est de la configuration de `prometheus` j'ai repris exactement la même que pour le [TP08](./TP_08/README.md). On aura évidemment un service `mysql-exporter` qui sera connecté à la base de données du service `mariadb` sur son port `3306` et qui sera également lié à `prometheus`.

Ces quatre services seront lancés à l'aide d'un fichier `docker-compose`. Cela permet également que les services seront automatiquement dans le même réseau.

### Indiquer à Grafana où récupérer les données. 🎯

Après avoir lancé les containers, on peut vérifier que notre service `prometheus` est bien lancé et lit bien les données en provenance du container `mysql-exporter`. Si c'est bien le cas, on va pouvoir ajouter à Grafana grâce à son interface une source de données. Pour cela il suffit de se rendre dans l'onglet `Configurations` puis `Data Sources`. Grafana nous permet d'ajouter une source en provenance de `Prometheus, c'est exactement ce dont on a besoin !

### A nous de jouer 😎

Une fois la source de données ajoutée on va enfin pouvoir commencer à utiliser Grafana. On créé premièrement un dashboard. Par défault on a un graphique comme visualisation et c'est ce qu'on veut donc on laisse ça comme ça. Pour avoir le taux d'opérations READ on va ajouter la metrics suivante `mysql_global_status_commands_total{command="select"}`. Bon ici j'ai un peu triché car je m'ais connecté avec l'utilisateur `root`, c'est pas vraiment conseillé mais bon 🤭. Le nombre de requête select est gros 1882 pour être exact lorsque j'écris ce README, voir la photo ci-dessous !

![Opération read sur la base de données "db" avec le user root](./images/operation-read.png?raw=true)
