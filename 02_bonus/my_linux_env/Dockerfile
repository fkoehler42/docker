FROM ubuntu

ARG UNAME="fkoehler"
ARG CONFIG_REPO="git@github.com:fkoehler42/config.git"

SHELL [ "/bin/bash", "-c" ]

RUN apt-get update && \
	apt-get install -y sudo git vim gcc cmake curl wget locales man && \
	locale-gen en_US.UTF-8 && \
	adduser --disabled-password --gecos "" ${UNAME} && \
	passwd -d ${UNAME}

WORKDIR /home/${UNAME}

ADD .ssh/ .ssh/

RUN chown -R ${UNAME}:${UNAME} /home/${UNAME}/.ssh

USER fkoehler

RUN git clone ${CONFIG_REPO} && \
	cp config/.gitconfig . && \
	cp config/linux/.vimrc . && \
	cat config/linux/.bashrc >> .bashrc && \
	mkdir projects

ENTRYPOINT [ "passwd" ]