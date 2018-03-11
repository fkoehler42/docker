FROM debian

ENV TS3SERVER_LICENSE=accept

RUN apt-get update && apt-get install -y bzip2 ca-certificates && \
	adduser teamspeak --disabled-password --gecos ""

WORKDIR /home/teamspeak

ADD http://dl.4players.de/ts/releases/3.1.1/teamspeak3-server_linux_amd64-3.1.1.tar.bz2 ./

RUN tar -jxf teamspeak3-server_linux_amd64-3.1.1.tar.bz2 && \
	rm teamspeak3-server_linux_amd64-3.1.1.tar.bz2

USER teamspeak

EXPOSE 9987/udp
EXPOSE 30033
EXPOSE 10011

CMD [ "/bin/bash", "-c", "~/teamspeak3-server_linux_amd64/ts3server_minimal_runscript.sh" ]
