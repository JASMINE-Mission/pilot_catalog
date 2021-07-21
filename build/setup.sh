#!/bin/bash -x
set -e # exit on error

cd $(dirname $(readlink -f $0))
container=$(docker-compose ps -q jasmine_catalog)

for key in q3c user;
do
  docker cp jasmine_${key}.sql ${container}:/tmp/jasmine_${key}.sql
  docker exec ${container} psql -U admin -d jasmine -f /tmp/jasmine_${key}.sql
  docker exec ${container} rm /tmp/jasmine_${key}.sql
done
