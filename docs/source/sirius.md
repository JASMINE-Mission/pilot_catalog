# SIRIUS Galactic Center catalog


## Schema

``` sql
CREATE TABLE IF NOT EXISTS sirius_sources_orig (
  source_id          BIGSERIAL PRIMARY KEY,
  glon               FLOAT NOT NULL,
  glat               FLOAT NOT NULL,
  ra                 FLOAT NOT NULL,
  dec                FLOAT NOT NULL,
  position_j_x       FLOAT,
  position_j_y       FLOAT,
  phot_j_mag         FLOAT,
  phot_j_mag_error   FLOAT,
  position_h_x       FLOAT,
  position_h_y       FLOAT,
  phot_h_mag         FLOAT,
  phot_h_mag_error   FLOAT,
  position_ks_x      FLOAT,
  position_ks_y      FLOAT,
  phot_ks_mag        FLOAT,
  phot_ks_mag_error  FLOAT,
  plate_name         VARCHAR(16) NOT NULL
);
```

``` sql
DROP VIEW IF EXISTS sirius_sources CASCADE;
CREATE MATERIALIZED VIEW sirius_sources AS
SELECT
  *
FROM
  sirius_sources_orig
WHERE
  (glon BETWEEN -2.5 AND 1.2) AND (glat BETWEEN -1.2 AND 1.2);
```

## Source
SIRIUS Galactic Center catalog is obtained from private communication. The original catalog is given in a text table format. To import the catalog into the PostgreSQL database, the catalog is converted into the CSV format.

A Python script `convert_sirius.py` is available to convert the SIRIUS catalog. The usage of the script is as follows.

``` console
$ ./script/convert_sirius.py -h
usage: convert_sirius.py [-h] [-f] src csv

Reshape SIRIUS catalog to CSV format

positional arguments:
  src              input text catalog
  csv              output CSV catalog file

optional arguments:
  -h, --help       show this help message and exit
  -f, --overwrite  overwrite if the output file exists.
```

The SIRIUS GC catalog contains about 12230000 objects. The conversion takes a good amount of time. I recommend to use `screen` for conversion. The following command launches a background screen environment that runs a job to convert the catalog.

``` console
$ screen -dmS sirius \
    python script/convert_sirius.py sirius_WGCCatAll.dat sirius_jasmine_field.csv
```

The converted CSV file is hosted in [the catalog download page][download].

[download]: http://exoplanets.sakura.ne.jp/jasmine/
