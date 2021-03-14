FROM jupyter/pyspark-notebook:42f4c82a07ff
COPY notebooks ${HOME}
USER root
RUN echo "${NB_USER} ALL=(ALL:ALL) ALL" >> /etc/sudoers
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}