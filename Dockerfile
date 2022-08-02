ARG BASE_CONTAINER=condaforge/mambaforge:latest
FROM $BASE_CONTAINER

ARG python=3.9.12
ARG dask=2022.7.1

SHELL ["/bin/bash", "-c"]

ENV PATH /opt/conda/bin:$PATH
ENV PYTHON_VERSION=${python}
ENV DASK_VERSION=${dask}

RUN mamba install -y \
    python=${PYTHON_VERSION} \
    nomkl \
    cmake \
    python-blosc \
    cytoolz \
    dask==${DASK_VERSION} \
    lz4==3.1.10 \
    numpy==1.22.4 \
    pandas==1.4.3 \
    tini==0.18.0 \
    cachey \
    streamz \
    && mamba clean -tipy \
    && find /opt/conda/ -type f,l -name '*.a' -delete \
    && find /opt/conda/ -type f,l -name '*.pyc' -delete \
    && find /opt/conda/ -type f,l -name '*.js.map' -delete \
    && find /opt/conda/lib/python*/site-packages/bokeh/server/static -type f,l -name '*.js' -not -name '*.min.js' -delete \
    && rm -rf /opt/conda/pkgs
    
# Install requirements.txt defined libraries
COPY requirements.txt /tmp/
RUN apt-get update && apt-get -y install gcc iputils-ping vim nano libsqlite3-dev
RUN python -m pip install --upgrade pip \
    && pip install --requirement /tmp/requirements.txt

COPY prepare.sh /usr/bin/prepare.sh

RUN mkdir /opt/app

RUN ["chmod", "+x", "/usr/bin/prepare.sh"]
ENTRYPOINT ["tini", "-g", "--", "/usr/bin/prepare.sh"]
