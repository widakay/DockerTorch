FROM nvidia/cuda:7.5-devel
MAINTAINER Erik M <development@yoerik.com>

RUN apt-get update && apt-get install -y curl

RUN curl https://yoerik.objects.dreamhost.com/dosources.list > /etc/apt/sources.list

RUN apt-get update && apt-get install -y wget build-essential aria2 cmake libhdf5-serial-dev software-properties-common

RUN adduser --disabled-password --gecos '' torch

RUN usermod -aG sudo torch
RUN echo "%sudo   ALL=(ALL:ALL) ALL" >> /etc/sudoers

RUN curl -s https://raw.githubusercontent.com/torch/ezinstall/master/install-deps | bash

USER torch
RUN git clone https://github.com/torch/distro.git ~/torch --recursive
RUN cd ~/torch; ./install.sh
#RUN echo "export PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:$PATH" >> ~/.bashrc;

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

