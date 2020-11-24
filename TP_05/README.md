# TP05

## Consigne

Utilisez la configuration docker-compose précédente afin d'instancier un serveur MySQL et un serveur MariaDB qui partagent un dossier /backups commun.

Connectez vous en premier au serveur MySQL, créez une base de données avec au moins une table qui contient quelques données.

Exportez cette base de données dans le dossier /backups.

Connectez vous au serveur MariaDB et importez la base que vous venez d'exporter.

## Rendu

Pour réaliser le TP j'ai :

- Créé un fichier docker-compose.yaml avec le même contenu que dans le slide. (Permet de créer deux conteneurs, un mysql et un mariadb avec un volume partagé)
- Exécuté ce fichier avec la commande `docker-compose build`
- Exécuté la commande `docker-compose up -d` pour lancer les deux container
- Lancé la commande `docker-compose exec mysql sh` pour me connecter au shell du conteneur msql.
- Créé une base de donnée que j'ai nommé `TP05` en y ajoutant la table `first_name` ainsi que quelques données.
- Dumpé la table (`mysqldump -u root -p TP05 > /backups/backup.sql`), dans le dossier `backups` qui correspond au volume partagé par les deux conteneurs. Je me suis ensuite déconnecté du conteneur avec la commande `exit`.

- Lancé la commande `docker-compose exec maria sh` pour me connecter au shell du conteneur maria.
- Créé une base de donnés que j'ai nommé `TP05`.
- Exécuté la commande `mariadb -u root -p TP05 < /backups/backup.sql`

### Docker-compose.yaml

```
version: '3.7'

services:
  mysql:
    image: mysql:5.7
    restart: on-failure
    environment:
      MYSQL_ROOT_PASSWORD: password
    volumes:
      - ./mysql:/var/lib/mysql
      - ./backups:/backups

  maria:
    image: mariadb:10.4
    restart: on-failure
    environment:
      MYSQL_ROOT_PASSWORD: password
    volumes:
      - ./maria:/var/lib/mysql
      - ./backups:/backups

```
