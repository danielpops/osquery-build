# Configure a xenial build environment for osquery
FROM ubuntu:xenial
MAINTAINER danielpops@gmail.com

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bison \
        build-essential \
        curl \
        doxygen \
        flex \
        gettext \
        git-core \
        libgdbm-dev \
        libncurses5-dev \
        libreadline6-dev \
        libssl-dev \
        libtool \
        libyaml-dev \
        make \
        pkg-config \
        python-dev \
        python2.7 \
        openssl \
        realpath \
        ruby2.3-dev \
        sudo \
        vim \
        wget \
        zlib1g-dev \
    && apt-get clean

RUN gem install fpm

RUN git config --global http.sslVerify false
RUN git clone https://github.com/facebook/osquery.git /osquery/osquery
RUN chown nobody:nogroup -R /osquery

WORKDIR /osquery/osquery
# Give nobody passwordless sudo so that it can run brew-install commands
RUN echo "nobody ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/nobody
RUN chmod 0440 /etc/sudoers.d/nobody

RUN mkdir -p /usr/local/osquery/
RUN chown nobody:nogroup -R /usr/local/osquery/

USER nobody

RUN make deps
RUN make

RUN make packages

ENTRYPOINT ["/bin/bash"]
