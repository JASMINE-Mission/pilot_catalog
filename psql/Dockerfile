FROM postgres:10.0

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y \
      apt-utils \
      git \
      make \
      gcc

RUN apt-get install -y \
      postgresql-server-dev-13 \
      libssl-dev \
      libreadline-dev \
      libcrypto++-dev \
      zlib1g-dev \
      && \
    git clone https://github.com/segasai/q3c.git /tmp/q3c && \
    cd /tmp/q3c && \
    make all install

RUN apt-get install -y python-psycopg2 python-dateutil
