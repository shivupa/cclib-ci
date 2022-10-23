FROM condaforge/mambaforge:4.11.0-4 as conda

LABEL authors="Shiv Upadhyay <shivnupadhyay@gmail.com>, Eric Berquist <eric.berquist@gmail.com>"

COPY ./condarc /root/.condarc
COPY ./environment.yml /tmp/

RUN mamba info -a
RUN --mount=type=cache,target=/opt/conda/pkgs mamba env create -f /tmp/environment.yml -p /env

RUN apt-get update && \
    apt-get install -y -qq --no-install-recommends \
      curl \
      gcc \
      git \
      swig \
      wget \
    && rm -rf /var/lib/apt/lists/*
RUN wget \
    https://raw.githubusercontent.com/cclib/cclib/master/requirements.txt \
    && cat requirements.txt
RUN conda run -p /env python -m pip install -r requirements.txt

RUN rm -f /tmp/environment.yml && \
    rm -f requirements.txt && \
    rm -rf /root/.cache/pip && \
    rm -f /env/bin/perl && \
    rm -f /env/bin/perl5.30.0 && \
    rm -rf /env/conda-meta && \
    rm -rf /env/share/man && \
    rm -rf /env/share/terminfo && \
    find /env -name '__pycache__' -type d -exec rm -rf '{}' '+' && \
    find /env -name '*.a' -type f -exec rm -f '{}' '+'
