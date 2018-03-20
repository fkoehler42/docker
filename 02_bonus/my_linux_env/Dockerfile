FROM ubuntu

ARG UNAME="fkoehler"

ARG CONFIG_REPO="git@github.com:fkoehler42/config.git"

SHELL [ "/bin/bash", "-c" ]

RUN apt-get update && \
	apt-get install -y sudo git vim gcc cmake curl wget && \
	adduser --disabled-password --gecos "" ${UNAME}
#	usermod -aG sudoers fkoehler

USER fkoehler

WORKDIR /home/${UNAME}

ADD id_rsa.pub .ssh/

RUN git clone ${CONFIG_REPO} && \
	cp config/.gitconfig . && \
	cp config/linux/.vimrc . && \
	cat config/linux/.bashrc >> .bashrc && \
	mkdir projects
