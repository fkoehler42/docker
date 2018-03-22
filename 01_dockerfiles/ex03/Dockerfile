FROM debian

RUN apt-get update && \
	apt-get install -y sudo build-essential zlib1g-dev libyaml-dev libssl1.0-dev libgdbm-dev libre2-dev libreadline-dev libncurses5-dev libffi-dev curl openssh-server checkinstall libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev logrotate rsync python-docutils pkg-config cmake git-core ca-certificates

WORKDIR /tmp/ruby

# INSTALL STEPS #
RUN curl --remote-name --progress https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.6.tar.gz && \
	echo '4e6a0f828819e15d274ae58485585fc8b7caace0  ruby-2.3.6.tar.gz' | shasum -c - && \
	tar xzf ruby-2.3.6.tar.gz

WORKDIR ./ruby-2.3.6

RUN ./configure --disable-install-rdoc && \
	make && make install && \
	gem install bundler --no-ri --no-rdoc && \
	curl --location https://deb.nodesource.com/setup_8.x | sudo bash - && \
	apt-get install -y nodejs golang && \
	curl --silent --show-error https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
	apt-get update && \
	apt-get install -y yarn postgresql postgresql-client libpq-dev postgresql-contrib && \
	yes password | adduser --gecos 'GitLab' git && \
# PostgreSQL install #
	sudo -u postgres -H service postgresql restart && \
	sudo -u postgres -H psql -d template1 -c "CREATE USER git CREATEDB PASSWORD 'password';" && \
	sudo -u postgres -H psql -d template1 -c "CREATE EXTENSION IF NOT EXISTS pg_trgm;" && \
	sudo -u postgres -H psql -d template1 -c "CREATE DATABASE gitlabhq_production OWNER git;" && \
# Redis-server install #
	apt-get install -y redis-server && \
	cp /etc/redis/redis.conf /etc/redis/redis.conf.orig && \
	sed 's/^port .*/port 0/' /etc/redis/redis.conf.orig | tee /etc/redis/redis.conf && \
	echo 'unixsocket /var/run/redis/redis.sock' | tee -a /etc/redis/redis.conf && \
	echo 'unixsocketperm 770' | tee -a /etc/redis/redis.conf && \
	mkdir /var/run/redis && \
	chown redis:redis /var/run/redis && \
	chmod 755 /var/run/redis && \
	if [ -d /etc/tmpfiles.d ]; then echo 'd /var/run/redis 0755 redis redis 10d -' | tee -a /etc/tmpfiles.d/redis.conf; fi && \
	usermod -aG redis git && \
	sudo -u git -H git clone https://gitlab.com/gitlab-org/gitlab-ce.git /home/git/gitlab

WORKDIR /home/git/gitlab

# CONFIGURATION STEPS #
RUN sudo -u git -H cp config/gitlab.yml.example config/gitlab.yml && \
	sudo -u git -H cp config/secrets.yml.example config/secrets.yml && \
	chmod 0600 config/secrets.yml && \
	chmod -R u+rwX,go-w log/ && \
	chmod -R u+rwX tmp/ && \
	chmod -R u+rwX tmp/pids/ && \
	chmod -R u+rwX tmp/sockets/ && \
	sudo -u git -H mkdir public/uploads/ && \
	chmod 0700 public/uploads && \
	chmod -R u+rwX builds/ && \
	chmod -R u+rwX shared/artifacts/ && \
	chmod -R ug+rwX shared/pages/ && \
	sudo -u git -H cp config/unicorn.rb.example config/unicorn.rb && \
	sudo -u git -H cp config/initializers/rack_attack.rb.example config/initializers/rack_attack.rb && \
	sudo -u git -H git config --global core.autocrlf input && \
	sudo -u git -H git config --global gc.auto 0 && \
	sudo -u git -H git config --global repack.writeBitmaps true && \
	sudo -u git -H git config --global receive.advertisePushOptions true && \
	sudo -u git -H cp config/resque.yml.example config/resque.yml && \
	sudo -u git -H cp config/database.yml.postgresql config/database.yml && \
	chown -R git:git . && \
	sed -i 's/secure password/password/' ./config/database.yml && \ 
	sudo -u git -H chmod o-rwx config/database.yml && \
# BUNDLE INSTALL GEMS #
	sudo -u git -H bundle install --deployment --without development test mysql aws kerberos && \
	service postgresql restart && \
	service redis-server restart && \
	sudo -u git -H bundle exec rake gitlab:shell:install REDIS_URL=unix:/var/run/redis/redis.sock RAILS_ENV=production SKIP_STORAGE_VALIDATION=true && \
	sudo -u git -H bundle exec rake "gitlab:workhorse:install[/home/git/gitlab-workhorse]" RAILS_ENV=production && \
	yes yes | sudo -u git -H bundle exec rake gitlab:setup RAILS_ENV=production && \
	cp lib/support/init.d/gitlab /etc/init.d/gitlab && \
	update-rc.d gitlab defaults 21 && \
	chown -R git:git . && \
	sudo -u git -H bundle exec rake "gitlab:gitaly:install[/home/git/gitaly]" RAILS_ENV=production && \
	chmod 0700 /home/git/gitlab/tmp/sockets/private && \
	chown git /home/git/gitlab/tmp/sockets/private && \
	cp lib/support/logrotate/gitlab /etc/logrotate.d/gitlab && \
	sudo -u git -H bundle exec rake gitlab:env:info RAILS_ENV=production && \
	sudo -u git -H bundle exec rake gettext:compile RAILS_ENV=production && \
	sudo -u git -H yarn install --production --pure-lockfile && \
	sudo -u git -H bundle exec rake gitlab:assets:compile RAILS_ENV=production NODE_ENV=production && \
	chown -R git:git /home/git/ && \
	apt-get install -y nginx && \
	cp lib/support/nginx/gitlab /etc/nginx/sites-available/gitlab && \
	sed -i -e '30,62d' /etc/nginx/sites-available/gitlab && \
	sed -i '51s+gitlab_access;+;+' /etc/nginx/sites-available/gitlab && \
	ln -s /etc/nginx/sites-available/gitlab /etc/nginx/sites-enabled/gitlab && \
	rm -f /etc/nginx/sites-enabled/default && \
	sed -i '582s/# ssh_port: 22/ssh_port: 30022/' /home/git/gitlab/config/gitlab.yml && \
	mkdir /run/sshd

ADD config /home/git/.ssh/

CMD /usr/sbin/sshd && service postgresql start && service redis-server start && service gitlab start && service nginx start && bash

EXPOSE 80
EXPOSE 30022