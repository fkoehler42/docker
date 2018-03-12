FROM debian

SHELL [ "/bin/bash", "-c" ]
ENV RUBY_PACKAGES="ruby-dev ruby"
ENV DEPS_AND_UTILS="curl procps gpg nodejs"

RUN apt-get update && \
	apt-get install -y $RUBY_PACKAGES $DEPS_AND_UTILS && \
	curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
	curl -sSL https://get.rvm.io | bash -s stable && \
	source /etc/profile.d/rvm.sh && \
	rvm install 2.5.0 && \
	rvm use 2.5.0 --default && \
	gem install --no-ri --no-rdoc bundler rails

ONBUILD COPY app /opt/app/

ONBUILD WORKDIR /opt/app

ONBUILD RUN bundle install && \
			rails db:migrate && \
			rails db:seed

CMD [ "/bin/bash" ]
