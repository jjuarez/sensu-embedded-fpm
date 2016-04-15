FROM debian:wheezy

RUN apt-get update
RUN apt-get install -y wget
RUN wget -q http://repos.sensuapp.org/apt/pubkey.gpg -O- | apt-key add -
RUN echo "deb http://repos.sensuapp.org/apt sensu main" > /etc/apt/sources.list.d/sensu.list
RUN apt-get update
RUN apt-get install -qqy sensu
RUN apt-get install -qqy build-essential
RUN apt-get install -qqy ruby ruby-dev rubygems
RUN apt-get install -qqy postgresql-9.1 postgresql-client-9.1 postgresql-server-dev-9.1 libpq libpq-dev

RUN gem install fpm --no-ri --no-rdoc
ADD fpm_build.sh /fpm_build.sh

ENTRYPOINT ["/fpm_build.sh"]

