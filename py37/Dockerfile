FROM condaforge/mambaforge:latest as conda

LABEL authors="Shiv Upadhyay <shivnupadhyay@gmail.com>, Eric Berquist <eric.berquist@gmail.com>"

COPY ./condarc /root/.condarc
COPY ./environment.yml /tmp/

RUN mamba info -a
RUN --mount=type=cache,target=/opt/conda/pkgs mamba env create -f /tmp/environment.yml -p /env

RUN apt-get update && \
    apt-get install -y -qq \
      curl \
      gcc \
      git \
      swig \
      wget
RUN wget \
    https://raw.githubusercontent.com/cclib/cclib/master/requirements.txt \
    && cat requirements.txt
RUN conda run -p /env python -m pip install -r requirements.txt

RUN rm -f /tmp/environment.yml
RUN rm -f requirements.txt
RUN rm -rf /root/.cache/pip
RUN rm -rf /var/lib/apt/lists/*

RUN rm -f /env/bin/perl
RUN rm -f /env/bin/perl5.30.0
RUN rm -rf /env/conda-meta
RUN rm -rf /env/share/man
RUN rm -rf /env/share/terminfo
RUN find /env -name '__pycache__' -type d -exec rm -rf '{}' '+'
RUN find /env -name '*.a' -type f -exec rm -f '{}' '+'
