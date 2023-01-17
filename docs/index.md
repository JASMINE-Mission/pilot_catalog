# JASMINE source catalog

JASMINE source catalog contains infrared point sources around the Galactic center region. The catalog involves 2MASS Point Source Catalog, SIRIUS Galactic Center Catalog, and VVV Infrared Astrometric Catalogue.


## How to access the database
After [the database is successfully built][build], you can start the database using `docker-compose`. Use `-d` option if you want to run the database as a background process.

``` console
$ docker-compose up
```

[build]: /build


In default, the database uses the port `15432` (not `5432`). Type the following command to access the database via the PostgreSQL command line interface. The password is the same as the username.

``` console
$ psql -h localhost -p 15432 -d jasmine -U jasmine
```

Here is a Python sample code to access the database.

``` python
import psycopg2 as sql

login = {
    'host': 'localhost',
    'port': 15432,
    'database': 'jasmine',
    'user': 'jasmine',
    'password': 'jasmine',
}
with sql.connect(**login) as connect:
    with connect.cursor() as cur:
    query = "SELECT * FROM merged_sources LIMIT 10;"
    cur.execute(query)
    for rec in cur: print(rec) # print each record as tuple
```


## How to use the database
A main table (`merged_sources`) is defined as follows. See [the overview page][overview] for detailed information and statistics of the merged catalog.

[overview]: /overview

``` sql
CREATE TABLE merged_sources (
  source_id          BIGSERIAL PRIMARY KEY,
  tmass_source_id    BIGINT,
  sirius_source_id   BIGINT,
  vvv_source_id      BIGINT,
  glon               FLOAT(10),
  glat               FLOAT(10),
  ra                 FLOAT(10),
  dec                FLOAT(10),
  position_source    VARCHAR(1),
  phot_hw_mag        FLOAT(10),
  phot_hw_mag_error  FLOAT(10),
  phot_hw_mag_source VARCHAR(1),
  phot_j_mag         FLOAT(10),
  phot_j_mag_error   FLOAT(10),
  phot_j_mag_source  VARCHAR(1),
  phot_h_mag         FLOAT(10),
  phot_h_mag_error   FLOAT(10),
  phot_h_mag_source  VARCHAR(1),
  phot_ks_mag        FLOAT(10),
  phot_ks_mag_error  FLOAT(10),
  phot_ks_mag_source VARCHAR(1)
);
```


There are some sample queries.

``` sql
SELECT * FROM merged_sources
  WHERE (glon BETWEEN -0.1 AND 0.1) AND (glat BETWEEN -0.05 AND 0.05);
```


*q3c* indeces are implemented. Sophisticated *q3c* search functions are available. Refer to [the official q3c page][q3c] for detailed usage of the q3c functions.

``` sql
SELECT * FROM merged_sources
  WHERE q3c_radial_query(glon, glat, 0.0, 0.0, 0.1);
```

[q3c]: https://github.com/segasai/q3c


The JASMINE field is defined as `within_jasmine_field()`. Sources within the latest JASMINE observation field are extracted using the following query.

``` sql
SELECT * FROM merged_sources
  WHERE within_jasmine_field(glon, glat);
```

![Overview of the JASMINE field.](./image/jasmine_field.png)
