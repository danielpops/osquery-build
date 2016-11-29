# Configure a trusty build environment for osquery
FROM ubuntu:trusty
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
        vim \
        wget \
        zlib1g-dev \
    && apt-get clean

RUN localedef -i en_US -f UTF-8 en_US.UTF-8

RUN git config --global http.sslVerify false
RUN git clone https://github.com/facebook/osquery.git /osquery/osquery
RUN chown nobody:nogroup -R /osquery

WORKDIR /osquery/osquery

USER nobody

ENV SKIP_DISTRO_MAIN=true
RUN make deps
RUN make

# Hack to fix the packaging script:
#  Use whichever fpm is found in the path
#  Make sure a file actually exists before calling realpath
RUN sed -i 's/FPM=.*$/FPM="fpm"/g' ./tools/deployment/make_linux_package.sh
RUN sed -i 's/^\(\s*\)\(.*\)`realpath\s\(.*\)`/\1touch \3\n\1\2`realpath \3`/g' ./tools/deployment/make_linux_package.sh
RUN make packages

ENTRYPOINT ["/bin/bash"]
