FROM nvidia/cuda:7.5-devel
MAINTAINER Erik M <development@yoerik.com>


RUN apt-get update && apt-get install -y curl

RUN curl https://yoerik.objects.dreamhost.com/dosources.list > /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y wget build-essential aria2 cmake

RUN adduser --disabled-password --gecos '' torch

RUN curl -s https://raw.githubusercontent.com/torch/ezinstall/master/install-deps | bash

USER torch
RUN git clone https://github.com/torch/distro.git ~/torch --recursive
RUN cd ~/torch; ./install.sh
#RUN echo "export PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:$PATH" >> ~/.bashrc;

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:/usr/local/nvidia/bin:/usr/local/cuda/bin:$PATH

USER root

RUN apt-get install -y libhdf5-serial-dev



USER torch
RUN . /home/torch/torch/install/bin/torch-activate && luarocks install torch
RUN . /home/torch/torch/install/bin/torch-activate && luarocks install cutorch
RUN . /home/torch/torch/install/bin/torch-activate && luarocks install nngraph
RUN . /home/torch/torch/install/bin/torch-activate && luarocks install nn
RUN . /home/torch/torch/install/bin/torch-activate && luarocks install cunn
RUN . /home/torch/torch/install/bin/torch-activate && luarocks install rnn
RUN . /home/torch/torch/install/bin/torch-activate && luarocks install hdf5
RUN . /home/torch/torch/install/bin/torch-activate && luarocks install xlua
RUN . /home/torch/torch/install/bin/torch-activate && luarocks install optim

USER root
RUN usermod -aG sudo torch
RUN echo "%sudo   ALL=(ALL:ALL) ALL" >> /etc/sudoers

USER torch
