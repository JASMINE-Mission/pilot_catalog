# VVV catalogue DR2

## Schema

``` sql
CRATE TABLE IF NOT EXISTS vvv_sources (
  source_id         BIGINT PRIMARY KEY,
  glon              FLOAT(10) NOT NULL,
  glat              FLOAT(10) NOT NULL,
  ra                FLOAT(10) NOT NULL,
  dec               FLOAT(10) NOT NULL,
  phot_z_flag       INTEGER(4),
  phot_z_mag        FLOAT(10),
  phot_z_mag_error  FLOAT(10),
  phot_y_flag       INTEGER(4),
  phot_y_mag        FLOAT(10),
  phot_y_mag_error  FLOAT(10),
  phot_j_flag       INTEGER(4),
  phot_j_mag        FLOAT(10),
  phot_j_mag_error  FLOAT(10),
  phot_h_flag       INTEGER(4),
  phot_h_mag        FLOAT(10),
  phot_h_mag_error  FLOAT(10),
  phot_ks_flag      INTEGER(4),
  phot_ks_mag       FLOAT(10),
  phot_ks_mag_error FLOAT(10)
);
```


## Source
[Vizier][tapvizier]

``` sql
SELECT
  srcid as source_id,
  GLON-360*FLOOR(GLON/180.0) as glon,
  GLAT as glat,
  RAJ2000 as ra,
  DEJ2000 as dec,
  Zperrbits as phot_z_flag,
  Zmag3 as phot_z_mag,
  e_Zmag3 as phot_z_mag_error,
  Yperrbits as phot_y_flag,
  Ymag3 as phot_y_mag,
  e_Ymag3 as phot_y_mag_error,
  Jperrbits as phot_j_flag,
  Jmag3 as phot_j_mag,
  e_Jmag3 as phot_j_mag_error,
  Hperrbits as phot_h_flag,
  Hmag3 as phot_h_mag,
  e_Hmag3 as phot_h_mag_error,
  Ksperrbits as phot_ks_flag,
  Ksmag3 as phot_ks_mag,
  e_Ksmag3 as phot_ks_mag_error
FROM
  "II/348/vvv2"
WHERE
   1 = CONTAINS(
         POINT('FK5', RAJ2000, DEJ2000),
         POLYGON('FK5',
           268.28239829, -28.5243427,
           265.95589414, -27.28605622,
           263.70668889, -30.41734933,
           266.07860638, -31.69475218))
```

[tapvizier]: http://tapvizier.u-strasbg.fr/adql/


```
psql -h localhost -p 15432 -d jasmine -U admin \
  -c "COPY vvv_sources \
  (source_id,glon,glat,ra,dec,\
   phot_z_flag,phot_z_mag,phot_z_mag_error,\
   phot_y_flag,phot_y_mag,phot_y_mag_error,\
   phot_j_flag,phot_j_mag,phot_j_mag_error,\
   phot_h_flag,phot_h_mag,phot_h_mag_error,\
   phot_ks_flag,phot_ks_mag,phot_ks_mag_error) \
  FROM '/data/catalog/vvv_348dr2_catalog.csv' \
  DELIMITER ',' CSV HEADER;"
```
