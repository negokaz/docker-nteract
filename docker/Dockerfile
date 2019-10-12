FROM jupyter/minimal-notebook:latest

ARG NTERACT_ON_JUPYTER_VERSION="2.1.3"

RUN set -xe; \
    pip install nteract_on_jupyter==${NTERACT_ON_JUPYTER_VERSION}; \
    jupyter serverextension enable nteract_on_jupyter; \
    : disable authentication; \
    echo "c.NotebookApp.token = ''"    >> ${HOME}/.jupyter/jupyter_notebook_config.py; \
    echo "c.NotebookApp.password = ''" >> ${HOME}/.jupyter/jupyter_notebook_config.py;

WORKDIR ${HOME}/work
EXPOSE 8888

ENTRYPOINT ["/usr/local/bin/start.sh", "jupyter"]
CMD ["nteract"]
