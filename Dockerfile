FROM jupyter/minimal-notebook:latest

USER root
RUN set -xe; \
    pip install nteract_on_jupyter; \
    jupyter serverextension enable nteract_on_jupyter; \
    : disable authentication; \
    echo "c.NotebookApp.token = ''"    >> ${HOME}/.jupyter/jupyter_notebook_config.py; \
    echo "c.NotebookApp.password = ''" >> ${HOME}/.jupyter/jupyter_notebook_config.py;

USER $NB_USER
WORKDIR ${HOME}/work
EXPOSE 8888

ENTRYPOINT ["/usr/local/bin/start.sh", "jupyter", "nteract"]
CMD []
