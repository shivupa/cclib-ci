FROM condaforge/mambaforge:22.9.0-2@sha256:a508942c46f370f2bebd94801d6094d0d5be77c4f36ad0edd608b118998fbca8 as install

LABEL org.opencontainers.image.authors="Shiv Upadhyay <shivnupadhyay@gmail.com>, Eric Berquist <eric.berquist@gmail.com>"

SHELL ["/bin/bash", "-l", "-i", "-c"]
ENV SHELL /bin/bash

ENV HOME /root
WORKDIR "$HOME"

COPY ./condarc "$HOME"/.condarc
COPY ./environment.yml .

RUN apt-get update && \
    apt-get install -y -qq --no-install-recommends \
      build-essential \
      curl \
      gcc \
      git \
      swig \
    && rm -rf /var/lib/apt/lists/*

RUN mamba info -a
RUN --mount=type=cache,target=/opt/conda/pkgs mamba env create --file="$HOME"/environment.yml --name=cclib
RUN mamba init && \
    echo "mamba activate cclib" >> "$HOME"/.bashrc && \
    curl -o requirements.txt \
    https://raw.githubusercontent.com/cclib/cclib/master/requirements.txt && \
    mamba run -n cclib python -m pip install --no-cache-dir -r requirements.txt

FROM install as test

SHELL ["/bin/bash", "-l", "-i", "-c"]
WORKDIR "$HOME"
RUN git clone https://github.com/cclib/cclib.git
WORKDIR "$HOME"/cclib
COPY test.bash .
RUN ./test.bash
WORKDIR "$HOME"
