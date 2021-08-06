FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install -y acpica-tools
RUN apt-get install -y gcc-aarch64-linux-gnu
RUN apt-get install -y python3-distutils
RUN apt-get install -y uuid-dev
RUN apt-get install -y git
RUN apt-get install -y build-essential
RUN apt-get install -y gcc-9 g++-9
RUN apt-get install -y make
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 0
RUN apt-get install -y python
RUN apt-get install -y curl
