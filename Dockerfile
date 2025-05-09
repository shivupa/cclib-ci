FROM docker.io/condaforge/mambaforge:22.9.0-2@sha256:a508942c46f370f2bebd94801d6094d0d5be77c4f36ad0edd608b118998fbca8 AS install

LABEL org.opencontainers.image.authors="Shiv Upadhyay <shivnupadhyay@gmail.com>, Eric Berquist <eric.berquist@gmail.com>"

SHELL ["/bin/bash", "-l", "-i", "-c"]
ENV SHELL=/bin/bash

ENV HOME=/root
WORKDIR "$HOME"

RUN apt-get update && \
    apt-get install -y -qq --no-install-recommends \
      build-essential \
      curl \
      gcc \
      git \
      swig \
    && rm -rf /var/lib/apt/lists/*

ARG PYTHON_VERSION_DIR
COPY ./condarc "$HOME"/.condarc
COPY "${PYTHON_VERSION_DIR}"/environment.yml .

RUN mamba info -a
RUN --mount=type=cache,target=/opt/conda/pkgs,sharing=locked \
    mamba env create --file="$HOME"/environment.yml --name=cclib
RUN mamba init && \
    echo "mamba activate cclib" >> "$HOME"/.bashrc && \
    git clone https://github.com/cclib/cclib.git
WORKDIR "$HOME"/cclib
# Installing the Open Babel Python package only works when it is able to link
# against system-installed Open Babel compiled libraries.  The conda package
# provides both.
RUN sed -i '/openbabel/d' pyproject.toml && \
    pip-compile --all-extras pyproject.toml && \
    python -m pip install --no-cache-dir -r requirements.txt && \
    mv requirements.txt $HOME && \
    if [ -f requirements-bridges.txt ]; then python -m pip install --no-cache-dir -r requirements-bridges.txt; fi && \
    if [ -f requirements-dev.txt ]; then python -m pip install --no-cache-dir -r requirements-dev.txt; fi

FROM install AS test

SHELL ["/bin/bash", "-l", "-i", "-c"]
WORKDIR "$HOME"/cclib
COPY ./test.bash .
# Needed to fix slow test coverage performance with Python 3.12+:
# https://github.com/cclib/cclib/issues/1347 and
# https://github.com/nedbat/coveragepy/issues/1665
ENV COVERAGE_CORE=sysmon
RUN ./test.bash
WORKDIR "$HOME"

FROM install AS ci

SHELL ["/bin/bash", "-l", "-i", "-c"]
WORKDIR $HOME
RUN rm -r cclib
