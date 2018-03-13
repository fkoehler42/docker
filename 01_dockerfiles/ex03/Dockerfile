FROM debian

RUN apt-get update -y && \
	apt-get install -y build-essential zlib1g-dev libyaml-dev libssl1.0-dev libgdbm-dev libre2-dev libreadline-dev libncurses5-dev libffi-dev curl openssh-server checkinstall libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev logrotate rsync python-docutils pkg-config cmake git-core ca-certificates

WORKDIR /tmp/ruby

RUN curl --remote-name --progress https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.6.tar.gz && \
	echo '4e6a0f828819e15d274ae58485585fc8b7caace0  ruby-2.3.6.tar.gz' | shasum -c - && \
	tar xzf ruby-2.3.6.tar.gz

WORKDIR ./ruby-2.3.6

RUN ./configure --disable-install-rdoc && \
	make && make install && \
	gem install bundler --no-ri --no-rdoc && \
	apt-get install -y golang-go nodejs yarn postgresql postgresql-client libpq-dev postgresql-contrib && \
	service postgresql restart && \
	adduser --disabled-login --gecos 'GitLab' gituser

USER postgres

RUN psql -d template1 -c "CREATE USER gituser CREATEDB;" && \
	psql -d template1 -c "CREATE DATABASE gitlabhq_production OWNER gituser;"

USER root

RUN	apt-get install -y redis-server && \
	sed 's/^port .*/port 0/' /etc/redis/redis.conf.orig | tee /etc/redis/redis.conf && \
	echo 'unixsocket /var/run/redis/redis.sock' | tee -a /etc/redis/redis.conf && \
	echo 'unixsocketperm 770' | tee -a /etc/redis/redis.conf && \
	mkdir /var/run/redis && \
	chown redis:redis /var/run/redis && \
	chmod 755 /var/run/redis && \
	if [ -d /etc/tmpfiles.d ]; then echo 'd /var/run/redis 0755 redis redis 10d -' | tee -a /etc/tmpfiles.d/redis.conf; fi && \
	service redis-server restart && \
	usermod -aG redis gitlab

USER gituser

RUN git clone https://gitlab.com/gitlab-org/gitlab-ce.git gitlab

WORKDIR /home/gituser/gitlab

RUN cp config/gitlab.yml.example config/gitlab.yml


EXPOSE 443
EXPOSE 80
EXPOSE 22