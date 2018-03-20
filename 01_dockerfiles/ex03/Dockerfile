FROM debian

RUN apt-get update && \
	apt-get install -y build-essential zlib1g-dev libyaml-dev libssl1.0-dev libgdbm-dev libre2-dev libreadline-dev libncurses5-dev libffi-dev curl openssh-server checkinstall libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev logrotate rsync python-docutils pkg-config cmake git-core ca-certificates

WORKDIR /tmp/ruby

# INSTALL STEPS #
RUN curl --remote-name --progress https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.6.tar.gz && \
	echo '4e6a0f828819e15d274ae58485585fc8b7caace0  ruby-2.3.6.tar.gz' | shasum -c - && \
	tar xzf ruby-2.3.6.tar.gz

WORKDIR ./ruby-2.3.6

RUN ./configure --disable-install-rdoc && \
	make && make install && \
	gem install bundler --no-ri --no-rdoc && \
	apt-get install -y golang-go nodejs yarn postgresql postgresql-client libpq-dev postgresql-contrib && \
	adduser --disabled-login --gecos 'GitLab' git

USER postgres

RUN service postgresql restart && \
	psql -d template1 -c "CREATE USER git CREATEDB;" && \
	psql -d template1 -c "CREATE DATABASE gitlabhq_production OWNER git;"

USER root

RUN	apt-get install -y redis-server && \
	sed 's/^port .*/port 0/' /etc/redis/redis.conf.orig | tee /etc/redis/redis.conf && \
	echo 'unixsocket /var/run/redis/redis.sock' | tee -a /etc/redis/redis.conf && \
	echo 'unixsocketperm 770' | tee -a /etc/redis/redis.conf && \
	mkdir /var/run/redis && \
	chown redis:redis /var/run/redis && \
	chmod 755 /var/run/redis && \
	if [ -d /etc/tmpfiles.d ]; then echo 'd /var/run/redis 0755 redis redis 10d -' | tee -a /etc/tmpfiles.d/redis.conf; fi && \
	#service redis-server && \
	usermod -aG redis git && \
	git clone https://gitlab.com/gitlab-org/gitlab-ce.git /home/git/gitlab && \
	chown -R git:git /home/git/gitlab

WORKDIR /home/git/gitlab

USER git

# CONFIGURATION STEPS #
RUN cp config/gitlab.yml.example config/gitlab.yml && \
# edit gitlab.yml here to enable https (or import your own instead of copying the example one) 
	cp config/secrets.yml.example config/secrets.yml && \
	chmod 0600 config/secrets.yml && \
#	chown -R git log/ && \
#	chown -R git tmp/ && \
	chmod -R u+rwX,go-w log/ && \
	chmod -R u+rwX tmp/ && \
	chmod -R u+rwX tmp/pids/ && \
	chmod -R u+rwX tmp/sockets/ && \
	mkdir public/uploads/ && \
	chmod 0700 public/uploads && \
	chmod -R u+rwX builds/ && \
	chmod -R u+rwX shared/artifacts/ && \
	chmod -R ug+rwX shared/pages/ && \
	cp config/unicorn.rb.example config/unicorn.rb && \
	cp config/initializers/rack_attack.rb.example config/initializers/rack_attack.rb && \
	git config --global core.autocrlf input && \
	git config --global gc.auto 0 && \
	git config --global repack.writeBitmaps true && \
	git config --global receive.advertisePushOptions true && \
	cp config/resque.yml.example config/resque.yml && \
	cp config/database.yml.postgresql config/database.yml && \
	chmod o-rwx config/database.yml && \
# BUNDLE INSTALL GEMS #
	bundle install --deployment --without development test mysql aws kerberos && \
	bundle exec rake gitlab:shell:install REDIS_URL=unix:/var/run/redis/redis.sock RAILS_ENV=production SKIP_STORAGE_VALIDATION=true && \
	bundle exec rake "gitlab:workhorse:install[/home/git/gitlab-workhorse]" RAILS_ENV=production && \
	bundle exec rake gitlab:setup RAILS_ENV=production && \
	cp lib/support/init.d/gitlab /etc/init.d/gitlab && \
	update-rc.d gitlab defaults 21

RUN	yes | bundle exec rake "gitlab:gitaly:install[/home/git/gitaly]" RAILS_ENV=production && \
	chmod 0700 /home/git/gitlab/tmp/sockets/private && \
	chown git /home/git/gitlab/tmp/sockets/private && \
	cp lib/support/logrotate/gitlab /etc/logrotate.d/gitlab && \
	bundle exec rake gitlab:env:info RAILS_ENV=production && \
	bundle exec rake gettext:compile RAILS_ENV=production && \
	yarn install --production --pure-lockfile && \
	bundle exec rake gitlab:assets:compile RAILS_ENV=production NODE_ENV=production && \
	service gitlab start

EXPOSE 443
EXPOSE 80
EXPOSE 22