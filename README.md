# JASMINE source catalog

JASMINE source catalog contains infrared point sources around the Galactic center region. The catalog involves 2MASS Point Source Catalog, SIRIUS Galactic Center Catalog, and VVV Infrared Astrometric Catalogue.


## Schema

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