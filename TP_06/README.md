# TP06

## 1/Créez une fichier Docker-compose.yml qui lance deux instances MariaDB

Fichier `docker-compose.yml` :

```
version: '3.7'

services:
  maria_master:
    image: mariadb:10.5

  maria_slave:
    image: mariadb:10.5

```

## 2/ Ajoutez les fichiers de configurations pour les serveurs Master et Slave

Pour les fichiers de configuration j'ai créé un dossier pour chaque conteneur (à leur nom) avec un fichier de configuration (master.cnf et slave.cnf). J'ai également ajouté un dossier data à l'intérieur de chaque dossier qui contiendra les différents fichiers/dossiers liés à mysql. Pour pouvoir ensuite me connecter à mysql sur les instances mariaDb j'ai défini un mot de passe dans la variable d'environnement `MYSQL_ROOT_PASSWORD`. J'ai également ajouté les ports 3306 aux conteneurs ainsi qu'un réseau `myNetwork`.

Fichier `docker-compose.yml` :

```
version: '3.7'

services:
  master:
    image: mariadb:10.5
    environment:
      MYSQL_ROOT_PASSWORD: password
    ports:
      - 4406:3306
    volumes:
      - ./master/data:/var/lib/mysql
      - ./backups:/backups
      - ./master/master.cnf:/etc/mysql/mariadb.conf.d/master.cnf
      - ./scripts:/scripts
    networks:
      - overlay

  slave:
    image: mariadb:10.5
    environment:
      MYSQL_ROOT_PASSWORD: password
    ports:
      - 5506:3306
    volumes:
      - ./slave/data:/var/lib/mysql
      - ./backups:/backups
      - ./slave/slave.cnf:/etc/mysql/mariadb.conf.d/slave.cnf
      - ./scripts:/scripts
    networks:
      - overlay

networks:
  overlay:

```

## 3/ Créez un script pour ajouter l'utilisateur avec les droits de replication sur master

Fichier `commandes.sql` qui se trouve dans le dossier scripts :

```
CREATE USER IF NOT EXISTS 'replicant'@'%' identified by 'myPassword';

grant replication slave on *.* to replicant;

flush privileges;
```

Pour lancer cette commande dans le conteneur master j'ai éxecuté la commande `mysql -u root -p < /scripts/commandes.sql`/

## 4/ Assurez vous que les deux instances de base de données contiennent les mêmes données

=> C'est ok !

## 5/ Démarrez le serveur master

Lorsqu'on lance la commande `docker-compose up` les deux conteneurs se lance automatiquement. Pour rentrer à l'intérieur du conteneur master on peut exécuter la commande `docker exec -it tp6_master_1 sh`.

## 6/ Ajoutez le master au slave

Pour ajouter le master au slave on se connecte à mysql sur le conteneur slave : `mysql -u root -p`. Ensuite on va exécuter la commande suivant :

```
CHANGE MASTER TO
MASTER_HOST='master',
MASTER_USER='replicant',
MASTER_PASSWORD='myPassword',
MASTER_PORT=3306,
MASTER_LOG_FILE='master1-bin.000011',
MASTER_LOG_POS=1260,
MASTER_CONNECT_RETRY=10;
```

## 7/ Démarrez et vérifiez l'état du slave

Pour démarrer l'état du slave on tape la commande `START SLAVE` puis on peut regarder l'état de celui-ci avec la commande `SHOW SLAVE STATUS`. Aucune erreur s'affiche et on peut lire que celui-ci attend des modifications dans la base de données master.

## 8/ Créez une nouvelle base de données et une nouvelle table sur le serveur Master et vérifier que les données sont présentes sur le serveur slave

=> C'est ok, à chaque ajout dans la base master, les données sont également présentes sur le slave.
