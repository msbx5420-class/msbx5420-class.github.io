FROM jupyter/pyspark-notebook:d990a62010ae
COPY notebooks ${HOME}
USER root
RUN apt-get update -y
RUN apt-get -y install mysql-server
RUN /etc/init.d/mysql start
RUN wget https://github.com/datacharmer/test_db/archive/master.zip
RUN unzip master.zip
RUN cd test_db-master/
RUN mysql -t < employees.sql
RUN cd ~
RUN mysql -u root -Bse "use mysql;CREATE USER 'admin'@'localhost' IDENTIFIED BY 'Admin_01';GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost';FLUSH PRIVILEGES;"
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}