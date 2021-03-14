FROM jupyter/pyspark-notebook:d990a62010ae
COPY notebooks ${HOME}
USER root
RUN apt-get -y update && \
    apt-get -y install mariadb-server && \
    /etc/init.d/mysql start && \
    wget https://github.com/datacharmer/test_db/archive/master.zip && \
    unzip master.zip && \
    cd test_db-master && mysql -u root < employees.sql && cd .. && rm master.zip && rm -rf test_db-master && \
    mysql -u root -Bse "use mysql;CREATE USER 'admin'@'localhost' IDENTIFIED BY 'Admin_01';GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost';FLUSH PRIVILEGES;" && \
    echo "${NB_USER} ALL=/sbin//etc/init.d/mysql start" >> /etc/sudoers && \
    echo "${NB_USER} ALL=/sbin//etc/init.d/mysql stop" >> /etc/sudoers && \
    echo "${NB_USER} ALL=/sbin//etc/init.d/mysql restart" >> /etc/sudoers
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}