# JASMINE source catalog

JASMINE source catalog contains infrared point sources around the Galactic center region. The catalog involves 2MASS Point Source Catalog, SIRIUS Galactic Center Catalog, and VVV Infrared Astrometric Catalogue.


## How to access the database

``` sh
psql -h localhost -p 15432 -d jasmine -U jasmine
```

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

``` sql
SELECT * FROM merged_sources
  WHERE (glon BETWEEN -0.1 AND 0.1) AND (glat BETWEEN -0.05 AND 0.05);
```

``` sql
SELECT * FROM merged_sources
  WHERE q3c_radial_query(glon, glat, 0.0, 0.0, 0.1);
```

``` sql
SELECT * FROM merged_sources
  WHERE within_jasmine_field(glon, glat);
```

![Overview of the JASMINE field.](./image/jasmine_field.png)
