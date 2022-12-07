# Gaia EDR3 catalog

## Schema

``` sql
CREATE TABLE IF NOT EXISTS gdr3_sources (
  source_id          BIGINT PRIMARY KEY,
  ra                 FLOAT(10) NOT NULL,
  dec                FLOAT(10) NOT NULL,
  glon               FLOAT(10) NOT NULL,
  glat               FLOAT(10) NOT NULL,
  elon               FLOAT(10) NOT NULL,
  elat               FLOAT(10) NOT NULL,
  parallax           FLOAT(10),
  parallax_error     FLOAT(10),
  ruwe               FLOAT(10),
  pm                 FLOAT(10),
  pmra               FLOAT(10),
  pmra_error         FLOAT(10),
  pmdec              FLOAT(10),
  pmdec_error        FLOAT(10),
  rv                 FLOAT(10),
  rv_error           FLOAT(10),
  phot_g_mag         FLOAT(10),
  phot_g_mag_error   FLOAT(10),
  phot_bp_mag        FLOAT(10),
  phot_bp_mag_error  FLOAT(10),
  phot_rp_mag        FLOAT(10),
  phot_rp_mag_error  FLOAT(10),
  phot_variable_flag VARCHAR(32),
  non_single_star    INT(1),
  distance           FLOAT(10),
  distance_lower     FLOAT(10),
  distance_upper     FLOAT(10),
  ag                 FLOAT(10),
  ag_lower           FLOAT(10),
  ag_upper           FLOAT(10),
  a0                 FLOAT(10),
  a0_lower           FLOAT(10),
  a0_upper           FLOAT(10)
);
```

## Source

The Gaia EDR3 catalog is obtained from the [Gaia Archive][gaia]. The advanced query mode is used to extract the source around the Galactic center. The extraction constrains are as follows:

- Galactic longitude between -2.5 and 1.2 degree.
- Galactic latitude between -1.2 and 1.2 degree.

The SQL query is described below. Note that the Galactic longitude is constraind between -180 and 180 degrees.

``` sql
SELECT
  source_id,
  ra,
  dec,
  l-360.0*floor(l/180.0) AS glon,
  b AS glat,
  ecl_lon,
  ecl_lat,
  parallax,
  parallax_error,
  ruwe,
  pm,
  pmra,
  pmra_error,
  pmdec,
  pmdec_error,
  radial_velocity,
  radial_velocity_error,
  phot_g_mean_mag AS phot_g_mag,
  2.5*log10(1+1.0/phot_g_mean_flux_over_error) AS phot_g_mag_error,
  phot_bp_mean_mag AS phot_bp_mag,
  2.5*log10(1+1.0/phot_bp_mean_flux_over_error) AS phot_bp_mag_error,
  phot_rp_mean_mag AS phot_rp_mag,
  2.5*log10(1+1.0/phot_rp_mean_flux_over_error) AS phot_rp_mag_error,
  phot_variable_flag,
  non_single_star,
  distance_gspphot,
  distance_gspphot_lower,
  distance_gspphot_upper,
  ag_gspphot,
  ag_gspphot_lower,
  ag_gspphot_upper,
  azero_gspphot,
  azero_gspphot_lower,
  azero_gspphot_upper
FROM
  gaiadr3.gaia_source
WHERE
  (l <= 1.2 OR 360-2.5 <= l) AND (b BETWEEN -1.2 AND 1.2);
```

The obtained CSV file is imported into the database by `COPY` command.

``` sh
psql -h localhost -p 15432 -d jasmine -U admin \
  -c "COPY gdr3_sources \
  (source_id,ra,dec,glon,glat,elon,elat,\
   parallax,parallax_error,ruwe,\
   pm,pmra,pmra_error,pmdec,pmdec_error,rv,rv_error,\
   phot_g_mag,phot_g_mag_error,\
   phot_bp_mag,phot_bp_mag_error,\
   phot_rp_mag,phot_rp_mag_error,\
   phot_variable_flatg,non_single_star,\
   distance,distance_lower,distance_upper,\
   ag,ag_lower,ag_upper,a0,a0_lower,a0_upper) \
  FROM '/data/catalog/gaia_dr3_gccat.csv' \
  DELIMITER',' CSV HEADER;"
```

[gaia]: https://gea.esac.esa.int/archive/
