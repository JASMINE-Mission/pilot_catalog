FROM postgres:13
ENV DEBIAN_FRONTEND noninteractive

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

RUN apt-get install -y \
      python3-psycopg2 \
      python3-dateutil

COPY conf/pg_hba.conf /etc/pg_hba.conf
COPY conf/postgresql.conf /etc/postgresql.conf
COPY sql /docker-entry-point-initdb.d
