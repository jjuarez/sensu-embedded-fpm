FROM debian:wheezy
MAINTAINER Tuenti.com <jjuarez@tuenti.com>

ARG fpm_version='1.6.0'
ARG sensu_version='0.19.2-1'

RUN apt-get update  -qqy
RUN apt-get upgrade -qqy
RUN apt-get install -qqy apt-utils
RUN apt-get install -qqy build-essential wget ruby ruby-dev rubygems rake

RUN wget -q -O - http://repos.sensuapp.org/apt/pubkey.gpg | apt-key add -
RUN echo "deb http://repos.sensuapp.org/apt sensu main" > /etc/apt/sources.list.d/sensu.list
RUN apt-get update -y && \
    apt-get install -y sensu=$sensu_version

RUN gem install --no-ri --no-rdoc fpm --version=$fpm_version

ADD pack.sh /usr/local/bin/pack.sh
ENTRYPOINT ["/usr/local/bin/pack.sh"]

