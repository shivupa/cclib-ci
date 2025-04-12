FROM quay.io/condaforge/miniforge3:26.1.1-3@sha256:a2f0bbf13a13535e8f286c049a05da80701b63fa8cd268d3e4ec33e671203c71  as install

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
      gpg \
      openssh-client \
      swig \
    && rm -rf /var/lib/apt/lists/*

ARG PYTHON_VERSION_DIR
COPY ./condarc "$HOME"/.condarc
COPY "${PYTHON_VERSION_DIR}"/environment.yml .

RUN mamba info
RUN --mount=type=cache,target=/opt/conda/pkgs,sharing=locked \
    mamba env create --file="$HOME"/environment.yml --name=cclib
RUN mamba shell init
RUN echo "mamba activate cclib" >> "$HOME"/.bashrc && \
    git clone https://github.com/cclib/cclib.git
WORKDIR "$HOME"/cclib
COPY ./patch_for_openbabel.bash /tmp/patch_for_openbabel.bash
RUN /tmp/patch_for_openbabel.bash && \
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
