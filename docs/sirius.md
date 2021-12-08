# SIRIUS Galactic Center catalog


## Schema

``` sql
CREATE TABLE IF NOT EXISTS sirius_sources_orig (
  source_id          BIGSERIAL PRIMARY KEY,
  glon               FLOAT(10) NOT NULL,
  glat               FLOAT(10) NOT NULL,
  ra                 FLOAT(10) NOT NULL,
  dec                FLOAT(10) NOT NULL,
  position_j_x       FLOAT(10),
  position_j_y       FLOAT(10),
  phot_j_mag         FLOAT(10),
  phot_j_mag_error   FLOAT(10),
  position_h_x       FLOAT(10),
  position_h_y       FLOAT(10),
  phot_h_mag         FLOAT(10),
  phot_h_mag_error   FLOAT(10),
  position_ks_x      FLOAT(10),
  position_ks_y      FLOAT(10),
  phot_ks_mag        FLOAT(10),
  phot_ks_mag_error  FLOAT(10),
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
Sirius Galactic Center catalog is obtained from Kataza-san. The original catalog is given in a text table format. To import the catalog into the PostgreSQL database, the catalog is converted into the CSV format.

A Python script `convert_sirius.py` is available to convert the Sirius catalog. The usage of the script is as follows.

```
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

The Sirius GC catalog contains about 12230000 objects. The conversion takes a goo amount of time. I recommend to use `screen` for conversion. The following command launches a background screen environment that runs a job to convert the catalog.

``` sh
screen -dmS sirius \
  python script/convert_sirius.py sirius_WGCCatAll.dat sirius_WGCCatAll.csv
```

The converted CSV file is imported into the database by `COPY` command.

``` sh
psql -h localhost -p 15432 -d jasmine -U admin \
  -c "COPY sirius_sources_orig \
  (glon,glat,ra,dec,position_j_x,position_j_y,phot_j_mag,\
   phot_j_mag_error,position_h_x,position_h_y,phot_h_mag,\
   phot_h_mag_error,position_ks_x,position_ks_y,phot_ks_mag,\
   phot_ks_mag_error,plate_name) \
  FROM '/data/catalog/sirius_WGCCatAll.csv' \
  DELIMITER ',' CSV HEADER;"
```

The original catalog contains objects outside of the nominal field. The `sirius_sources` is a view of `sirius_sources_orig`, where objects outside of the JASMINE field are removed.
