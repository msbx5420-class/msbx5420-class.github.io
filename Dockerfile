FROM jupyter/pyspark-notebook:3395de4db93a
COPY notebooks ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}