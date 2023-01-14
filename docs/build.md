# Build Database
## Fetch the repository

Clone the [repository][repo] by typing the following line. Otherwise, you can download a zipped archive from the GitHub repository page.

``` console
$ git clone https://github.com/JASMINE-Mission/pilot_catalog
```

[repo]: https://github.com/JASMINE-Mission/pilot_catalog

## Install Docker

Install `Docker` in your environment. Refer to the [official page][docker].

[docker]: https://docs.docker.com/get-docker/

## Build PostgreSQL image

Build a docker image for the database. Type the following command in the project root directory. A docker image of PostgreSQL-13 is fetched, and an empty database is build.

``` console
$ make build-psql
```

``` console
$ make initialize
$ make index
$ make link
```
