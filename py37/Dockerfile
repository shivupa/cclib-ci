FROM condaforge/mambaforge:latest

MAINTAINER Shiv Upadhyay <shivnupadhyay@gmail.com>

COPY ./condarc ~/.condarc
COPY ./environment.yml /tmp/

RUN mamba info -a && \
    mamba env create -n cclib -f /tmp/environment.yml

RUN apt-get update && \
    apt-get install -y -qq \
      git \
      gcc \
      swig \
      wget
RUN wget \
    https://raw.githubusercontent.com/cclib/cclib/master/requirements.txt \
    && cat requirements.txt
RUN echo ". /opt/conda/etc/profile.d/conda.sh && conda activate cclib" > ~/.bashrc
SHELL ["/bin/bash", "-l", "-c"]
RUN which python
RUN python -m pip install -r requirements.txt

RUN rm -f /tmp/environment.yml
RUN rm -f requirements.txt
RUN rm -rf ~/.cache/pip
RUN rm -rf /var/lib/apt/lists/*
RUN mamba clean --all

ENTRYPOINT ["/usr/bin/env"]
