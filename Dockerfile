FROM jupyter/pyspark-notebook:2ba4fb6b1227
COPY notebooks ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}