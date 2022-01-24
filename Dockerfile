FROM jupyter/pyspark-notebook:013a42fff3df
COPY notebooks ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}