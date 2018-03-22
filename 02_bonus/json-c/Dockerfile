FROM debian

ARG PROJECT_DIR='/opt/sample_project/'

ENV JSON_C_DIR='/usr/local/lib/json-c/'

ADD sample ${PROJECT_DIR}

RUN apt-get update && \
	apt-get install -y curl git autoconf automake libtool clang gcc make vim && \
	git clone https://github.com/json-c/json-c.git ${JSON_C_DIR}

WORKDIR ${JSON_C_DIR}

RUN sh autogen.sh && \
	./configure && \
	make && \
	make install

RUN rm /usr/local/lib/libjson-c.so.4 /usr/local/lib/libjson-c.so.4.0.0

WORKDIR ${PROJECT_DIR}

RUN gcc json_create.c -I $JSON_C_DIR -L $JSON_C_DIR -ljson-c -o json_create