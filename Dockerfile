FROM ubuntu:22.04

MAINTAINER Daniel Adorno Gomes <adornogomes@gmail.com>

COPY miniconda3_bashrc.txt /tmp

SHELL ["/bin/sh", "-c"]

RUN apt-get update && \
    apt-get install -y wget && \
    cd /root && \
    wget https://github.com/terrimporter/MetaWorks/releases/download/v1.12.0/MetaWorks1.12.0.zip && \
    unzip MetaWorks1.12.0.zip && \
	wget wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    ./Miniconda3-latest-Linux-x86_64.sh -b && \
    cat /tmp/miniconda3_bashrc.txt >> /root/.bashrc && \
	conda init bash
    . ~/.bashrc && \
    cd MetaWorks1.12.0 && \
    conda env create -f environment.yml
CMD ["conda", "activate", "MetaWorks_v1.12.0"]