FROM debian:wheezy

RUN apt-get update -qq && \
    apt-get install -y apt-utils && \
    apt-get install -y build-essential && \
    apt-get install -y bash && \
    apt-get install -y ruby ruby-dev rubygems && \
    apt-get install -y curl
RUN curl -q http://repos.sensuapp.org/apt/pubkey.gpg | apt-key add -
RUN echo "deb http://repos.sensuapp.org/apt sensu main" > /etc/apt/sources.list.d/sensu.list
RUN apt-get update && \
    apt-get install -qy sensu=0.19.2-1

ADD fpm_build.sh /fpm_build.sh
ENTRYPOINT ["/fpm_build.sh"]
