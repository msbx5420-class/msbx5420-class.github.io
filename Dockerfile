FROM jupyter/pyspark-notebook:d990a62010ae
COPY notebooks ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}