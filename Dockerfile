FROM jupyter/minimal-notebook:latest AS build-stage

ARG NTERACT_ON_JUPYTER_VERSION="2.0.7"

USER root
RUN set -xe; \
    npm install -g yarn; \
    wget -O nteract-on-jupyter.tar.gz https://github.com/nteract/nteract/archive/nteract-on-jupyter@${NTERACT_ON_JUPYTER_VERSION}.tar.gz; \
    tar xvf nteract-on-jupyter.tar.gz; \
    cd nteract-nteract-on-jupyter-${NTERACT_ON_JUPYTER_VERSION}; \
    yarn install; \
    cd applications/jupyter-extension/; \
    yarn build:python; \
    cp dist/nteract_on_jupyter-${NTERACT_ON_JUPYTER_VERSION}-py3-none-any.whl ${HOME}/nteract_on_jupyter.whl;

################################################################################

FROM jupyter/minimal-notebook:latest

USER $NB_USER
COPY --from=build-stage ${HOME}/nteract_on_jupyter.whl .
RUN set -xe; \
    pip install nteract_on_jupyter.whl; \
    rm nteract_on_jupyter.whl; \
    jupyter serverextension enable nteract_on_jupyter; \
    : disable authentication; \
    echo "c.NotebookApp.token = ''"    >> ${HOME}/.jupyter/jupyter_notebook_config.py; \
    echo "c.NotebookApp.password = ''" >> ${HOME}/.jupyter/jupyter_notebook_config.py;

WORKDIR ${HOME}/work
EXPOSE 8888

ENTRYPOINT ["/usr/local/bin/start.sh", "jupyter"]
CMD ["nteract"]
