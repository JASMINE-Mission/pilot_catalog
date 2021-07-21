#!/bin/bash -x
set -e # exit on error

cd $(dirname $(readlink -f $0))
container=$(docker-compose ps -q jasmine_catalog)

docker cp jasmine_user.sql $container:/tmp/jasmine_user.sql
docker exec $container psql -U admin -d jasmine -f /tmp/jasmine_user.sql
