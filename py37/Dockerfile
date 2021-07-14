# create new

FROM ubuntu:20.04
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

MAINTAINER Shiv Upadhyay <shivnupadhyay@gmail.com>

RUN apt-get update
RUN apt-get install -y -qq git swig wget gcc
RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 
RUN conda install python=3.7
RUN conda --version \
    && conda config --add channels conda-forge \
    && conda config --add channels http://conda.anaconda.org/psi4 \
    && conda config --set always_yes true --set changeps1 false --set channel_priority flexible --set quiet true \
    && conda info -a
RUN wget \
    https://raw.githubusercontent.com/cclib/cclib/master/requirements.txt \
    && cat requirements.txt 
RUN conda install numpy scipy
RUN python -m pip install -r requirements.txt
RUN rm -f requirements.txt
RUN conda install ci-psi4 psi4 openbabel pytest-cov pytest-shutil h5py \
    && python -m pip install pyscf \
    && python -m pip install qc-iodata \
    && conda list 
