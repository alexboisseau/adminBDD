# TP04

## Consigne

### Première partie (consigne)

Créez une image Docker qui contient tous les outils nécessaires pour mettre en place un système de backup automatique. Vous trouverez des ressources dans le TP 2 et 3 du cours de devops.
Vous pouvez créer votre image en local dans ce cas vous devez me faire parvenir le contenu de votre Dockerfile sinon vous pouvez vous créer un compte sur Docker Hub et uploader votre image dessus, dans ce cas veuillez me donner le lien publique vers votre image.

### Première partie (rendu)

Pour cette première partie il faut dans un premier temps créer un fichier Dockerfile que l'on pourra ensuite build. On commence par se baser sur l'image déjà existante de mysql que l'on va pull sur Docker Hub. Il va par la suite falloir ajouter les sources pour télécharger de nouvelles applications (apt-get), installer vim puis cron (vim est essentiel car cron a besoin de pouvoir editer son fichier de conf). Cron est l'outil qui nous permettra de plannifier le dump de nos bases de données. J'ai également rajouté une variable d'environnement dans le Dockerfile pour le mot de passe de l'utilisateur root. J'aurai aussi pû la passer lors de la commande `docker run`.

#### DockerFile

```
FROM mysql

ENV MYSQL_ROOT_PASSWORD=password

RUN apt-get update && apt-get install -y && apt-get update \
    && apt-get install vim -y \
    && apt-get install cron -y \
```
