FROM mysql

ENV MYSQL_ROOT_PASSWORD=password

RUN apt-get update && apt-get install -y && apt-get update \
    && apt-get install vim -y \
    && apt-get install cron -y 

RUN echo '0 17 * * 1 mysqldump -u root --password=password --all-databases | gzip -9 > /backup/all_databases_`date +"\%Y-\%m-\%d_"`.sql.gz' >> /var/spool/cron/crontabs/root
