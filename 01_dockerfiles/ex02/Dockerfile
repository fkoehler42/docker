FROM debian

SHELL [ "/bin/bash", "-c" ]
ENV RUBY_PACKAGES="ruby-dev ruby"
ENV DEPS_AND_UTILS="curl procps gpg nodejs"

RUN apt-get update && apt-get install -y $RUBY_PACKAGES $DEPS_AND_UTILS

RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import - && curl -sSL https://get.rvm.io | bash -s stable

RUN source /etc/profile.d/rvm.sh && rvm install 2.4.1 && rvm use 2.4.1 --default

RUN gem install --no-ri --no-rdoc bundler rails

CMD [ "/bin/bash" ]
