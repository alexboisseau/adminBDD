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

