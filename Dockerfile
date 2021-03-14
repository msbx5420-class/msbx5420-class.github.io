FROM jupyter/pyspark-notebook:d990a62010ae
COPY notebooks ${HOME}
USER root
RUN apt-get -y update
RUN apt-get -y install mariadb-server
RUN /etc/init.d/mysql start
RUN chmod 777 /var/run/mysqld/mysqld.sock
RUN ln -s /tmp/mysql.sock /var/lib/mysql/mysql.sock
RUN service mysql restart
RUN wget https://github.com/datacharmer/test_db/archive/master.zip
RUN unzip master.zip
RUN mysql -u root < test_db-master/employees.sql
RUN mysql -u root -Bse "use mysql;CREATE USER 'admin'@'localhost' IDENTIFIED BY 'Admin_01';GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost';FLUSH PRIVILEGES;"
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}