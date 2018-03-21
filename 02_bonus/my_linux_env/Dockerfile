FROM ubuntu

ARG uname="fkoehler"
ARG base_repo="git@github.com:fkoehler42/"
ARG config_repo="config"
ARG extra_repo="libft"

SHELL [ "/bin/bash", "-c" ]

RUN apt-get update && \
	apt-get install -y sudo git vim gcc cmake curl wget locales man && \
	locale-gen en_US.UTF-8 && \
	adduser --disabled-password --gecos "" ${uname} && \
	passwd -d ${uname}

WORKDIR /home/${uname}

ADD .ssh/ .ssh/

RUN chown -R ${uname}:${uname} /home/${uname}/.ssh

USER fkoehler

RUN git clone ${base_repo}${config_repo}".git" && \
	cp config/.gitconfig . && \
	cp config/linux/.vimrc . && \
	cat config/linux/.bashrc >> .bashrc && \
	mkdir projects && \
	git clone ${base_repo}${extra_repo}".git" projects/${extra_repo}

ENTRYPOINT [ "/bin/bash" ]