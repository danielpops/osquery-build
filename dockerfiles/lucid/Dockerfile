# Configure a lucid build environment for osquery
FROM ubuntu:lucid
MAINTAINER danielpops@gmail.com

# To deal with the fact that lucid is EOL distro
RUN sudo sed -i.bak -r 's/(archive|security).ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list

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
        openssl \
        realpath \
        vim \
        wget \
        zlib1g-dev \
    && apt-get clean

ENV WORKING_DIRECTORY /osquery/

# Install ruby from source, a requirement for the fpm packaging we need to do
# Again, to deal with the fact that lucid is EOL distro
ADD https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.2.tar.gz ruby-2.3.2.tar.gz
RUN  tar -xf ruby-2.3.2.tar.gz \
   && cd ruby-2.3.2 \
   && ./configure \
   && make \
   && make install
RUN gem install --verbose fpm

# Install python from source, a requirement to get Python2.7 on a lucid host
# Again, to deal with the fact that lucid is EOL distro
ADD https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tar.xz Python-2.7.9.tar.xz
RUN tar -xvf Python-2.7.9.tar.xz \
    && cd Python-2.7.9 \
    && ./configure \
    && make \
    && make install

RUN git clone https://github.com/facebook/osquery.git /osquery/osquery
RUN chown nobody:nogroup -R /osquery

WORKDIR /osquery/osquery
# Give nobody passwordless sudo so that it can run brew-install commands
RUN echo "nobody ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/nobody
RUN chmod 0440 /etc/sudoers.d/nobody

RUN mkdir -p /usr/local/osquery/ && chown nobody:nogroup -R /usr/local/osquery/
RUN mkdir -p /.cache && chown nobody:nogroup -R /.cache
RUN mkdir -p /nonexistent && chown nobody:nogroup -R /nonexistent

# distro_main is a function called during `make deps` which goes and installs a few "requirements" using apt-get install
# A few of the packages didn't exist in the ubuntu.com/old-releases.ubuntu.com package archive (git and autopoint), however
# their functionalities are available through two other packages:
#  git is not available on the "old releases" apt repository, but git-core is, and it sufficient
#  autopoint is not available on the "old releases" apt repository, but it does come bundled up inside of an older gettext package
# The distro_main function call is optional, so we can skip it by setting this flag
ENV SKIP_DISTRO_MAIN=true

# Run as nobody for `make deps`, since it uses linuxbrew and forbids running as root
USER nobody

RUN make deps
USER root
RUN make

RUN make packages

ENTRYPOINT ["/bin/bash"]
