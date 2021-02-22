FROM jupyter/pyspark-notebook:42f4c82a07ff
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}