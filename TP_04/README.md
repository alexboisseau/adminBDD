# TP04

## Première partie (consigne)

Créez une image Docker qui contient tous les outils nécessaires pour mettre en place un système de backup automatique. Vous trouverez des ressources dans le TP 2 et 3 du cours de devops.
Vous pouvez créer votre image en local dans ce cas vous devez me faire parvenir le contenu de votre Dockerfile sinon vous pouvez vous créer un compte sur Docker Hub et uploader votre image dessus, dans ce cas veuillez me donner le lien publique vers votre image.

## Première partie (rendu)

Pour cette première partie il faut dans un premier temps créer un fichier `Dockerfile` que l'on pourra ensuite `build`. On commence par se baser sur l'image déjà existante de mysql que l'on va pull sur Docker Hub. Il va par la suite falloir ajouter les sources pour télécharger de nouvelles applications (`apt-get`), installer `vim` puis `cron` (vim est essentiel car cron a besoin de pouvoir editer son fichier de conf). Cron est l'outil qui nous permettra de plannifier le dump de nos bases de données. J'ai également rajouté une variable d'environnement dans le Dockerfile pour le mot de passe de l'utilisateur root. J'aurai aussi pû la passer lors de la commande `docker run`.

### DockerFile

[Lien vers l'image avec le tag `tp4-first-part` juste ici 🤚](https://hub.docker.com/layers/127220336/alexboissseau/admin-bdd/tp4-first-part/images/sha256-1833de7b376211e3b79a244cd7a6173da644794f9c08739b2741203b955238b7)

```
FROM mysql

ENV MYSQL_ROOT_PASSWORD=password

RUN apt-get update && apt-get install -y && apt-get update \
    && apt-get install vim -y \
    && apt-get install cron -y \
```

## Deuxième partie (consigne)

Mettez en place une stratégie de backups grâce à cron qui génère un dump de la base de données tous les lundis à 17h et génère un fichier compressé en format gzip contenant la date de création.

## Deuxième partie (rendu)

Pour cette deuxième partie j'ai repris le `Dockerfile` de la première partie. J'y ai ajouté une ligne qui va écrire dans le fichier de config de cron pour l'utilisateur root. Cette ligne fera un dump de toutes les bases de données le lundi de chaque semaine de chaque mois à 17h. Ce fichier sera compréssé avec `gzip` et portera le nom `all_databases` suivi de la date au format `Y/m/d`.

### DockerFile

[Lien vers l'image avec le tag `tp4-second-part` juste ici 🤚](https://hub.docker.com/layers/127221416/alexboissseau/admin-bdd/tp4-second-part/images/sha256-1524d483f5f75361d2c1a2a83f3565854273b572f373e95de3a49736fe53fffb)

```
FROM mysql

ENV MYSQL_ROOT_PASSWORD=password

RUN apt-get update && apt-get install -y && apt-get update \
    && apt-get install vim -y \
    && apt-get install cron -y

RUN echo '0 17 * * 1 mysqldump -u root --password=password --all-databases | gzip -9 > /backup/all_databases_`date +"\%Y-\%m-\%d_"`.sql.gz' >> /var/spool/cron/crontabs/root

```

## Troisième partie (consigne)

Mettez en place une stratégie de backups avec logrotate qui réalise un dump journalier compressé en format bz2 et qui garde les 5 derniers dumps.

## Troisième partie (rendu)

Pour cette troisième et dernière partie il faut dans un premier temps installer Logrotate. Après avoir installer cet outil, nous allons pouvoir le configurer pour qu'il fasse une backup de notre base de données chaque jour et qu'il garde les 5 derniers dumps. Pour ajouter un fichier de conf on se rend à l'emplacement `/etc/logrotate.d/`.

### Dockerfile

[Lien vers l'image avec le tag `tp4-third-part` juste ici 🤚](https://hub.docker.com/layers/127226643/alexboissseau/admin-bdd/tp4-third-part/images/sha256-fedbfe1c240c40c88c504b0cc323d5b71712eb12b0b5ea3d76e17cd97635ed4d)

```
FROM mysql

ENV MYSQL_ROOT_PASSWORD=password

# Install vim and cron tools
RUN apt-get update && apt-get install -y && apt-get update \
    && apt-get install vim -y \
    && apt-get install cron -y


# Edit cron config
RUN echo '0 17 * * 1 mysqldump -u root --password=password --all-databases | gzip -9 > /backup/all_databases_`date +"\%Y-\%m-\%d_"`.sql.gz' >> /var/spool/cron/crontabs/root

# Install logrotate
RUN apt-get install logrotate -y

# Create new fileConf
RUN echo "/backups/all_databases.sql.b2z {" >> /etc/logrotate.d/confFile
RUN echo "rotate 5" >> /etc/logrotate.d/confFile
RUN echo "daily" >> /etc/logrotate.d/confFile
RUN echo "postrotate" >> /etc/logrotate.d/confFile
RUN echo "echo mysqldump -u root --password=password --all-databases | bzip2 > /backups/all_databases.sql.b2z" >> /etc/logrotate.d/confFile
RUN echo "endscript" >> /etc/logrotate.d/confFile
RUN echo "}" >> /etc/logrotate.d/confFile


# Create backups folder and first file inside
RUN mkdir /backups && cd /backups && echo mysqldump -u root --password=password --all-databases | bzip2 > /backups/all_databases.sql.b2z


```
