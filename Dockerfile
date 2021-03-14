FROM jupyter/pyspark-notebook:42f4c82a07ff
COPY notebooks ${HOME}
USER root
RUN apt-get update
RUN apt-get install mysql-server
RUN /etc/init.d/mysql start
RUN wget https://github.com/datacharmer/test_db/archive/master.zip
RUN unzip master.zip
RUN cd test_db-master/
RUN mysql -t < employees.sql
RUN cd ~
RUN mysql -u root -Bse "use mysql;CREATE USER 'admin'@'localhost' IDENTIFIED BY 'Admin_01';GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost';FLUSH PRIVILEGES;"
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}