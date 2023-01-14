# VVV Infrared Astrometric Catalogue

## Schema

``` sql
CREATE TABLE IF NOT EXISTS virac_sources (
  source_id         BIGINT PRIMARY KEY,
  ra                FLOAT(10) NOT NULL,
  dec               FLOAT(10) NOT NULL,
  pm                FLOAT(10),
  pmra              FLOAT(10),
  pmra_error        FLOAT(10),
  pmdec             FLOAT(10),
  pmdec_error       FLOAT(10),
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
  phot_ks_mag_error FLOAT(10),
  glon              FLOAT(10) NOT NULL,
  glat              FLOAT(10) NOT NULL
);
```

## Source
[URL][tapvizier]


``` sql
SELECT
  srcid as source_id,
  RA_ICRS as ra,
  DE_ICRS as dec,
  pm,
  pmRA as pmra,
  e_pmRA as pmra_error,
  pmDE as pmdec,
  e_pmDE as pmdec_error,
  Zdetflg as phot_z_flag,
  Zmag as phot_z_mag,
  e_Zmag as phot_z_mag_error,
  Ydetflg as phot_y_flag,
  Ymag as phot_y_mag,
  e_Ymag as phot_y_mag_error,
  Jdetflg as phot_j_flag,
  Jmag as phot_j_mag,
  e_Jmag as phot_j_mag_error,
  Hdetflg as phot_h_flag,
  Hmag as phot_h_mag,
  e_Hmag as phot_h_mag_error,
  Ksmag as phot_ks_mag,
  e_Ksmag as phot_ks_mag_error
FROM
  "II/364/virac"
WHERE
   1 = CONTAINS(
         POINT('ICRS', RA_ICRS, DE_ICRS),
         POLYGON('ICRS',
           268.28239829, -28.5243427,
           265.95589414, -27.28605622,
           263.70668889, -30.41734933,
           266.07860638, -31.69475218))
```

[tapvizier]: http://tapvizier.u-strasbg.fr/adql/


``` sql
psql -h localhost -p 15432 -d jasmine -U admin \
  -c "COPY virac_sources \
  (source_id,ra,dec,pm,pmra,pmra_error,pmdec,pmdec_error,\
   phot_z_flag,phot_z_mag,phot_z_mag_error,\
   phot_y_flag,phot_y_mag,phot_y_mag_error,\
   phot_j_flag,phot_j_mag,phot_j_mag_error,\
   phot_h_flag,phot_h_mag,phot_h_mag_error,\
   phot_ks_mag,phot_ks_mag_error,glon,glat) \
  FROM '/data/catalog/vvv_virac_catalog.csv' \
  DELIMITER ',' CSV HEADER;"
```
