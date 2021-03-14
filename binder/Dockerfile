FROM jupyter/pyspark-notebook:d990a62010ae
COPY notebooks ${HOME}
COPY binder ${HOME}/binder
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}