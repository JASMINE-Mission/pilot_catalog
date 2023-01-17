# Gaia DR3 catalog

## Schema

``` sql
CREATE TABLE IF NOT EXISTS gdr3_sources (
  source_id          BIGINT PRIMARY KEY,
  ra                 FLOAT NOT NULL,
  dec                FLOAT NOT NULL,
  glon               FLOAT NOT NULL,
  glat               FLOAT NOT NULL,
  elon               FLOAT NOT NULL,
  elat               FLOAT NOT NULL,
  parallax           FLOAT,
  parallax_error     FLOAT,
  ruwe               FLOAT,
  pm                 FLOAT,
  pmra               FLOAT,
  pmra_error         FLOAT,
  pmdec              FLOAT,
  pmdec_error        FLOAT,
  rv                 FLOAT,
  rv_error           FLOAT,
  phot_g_mag         FLOAT,
  phot_g_mag_error   FLOAT,
  phot_bp_mag        FLOAT,
  phot_bp_mag_error  FLOAT,
  phot_rp_mag        FLOAT,
  phot_rp_mag_error  FLOAT,
  phot_variable_flag VARCHAR(32),
  non_single_star    INTEGER,
  distance           FLOAT,
  distance_lower     FLOAT,
  distance_upper     FLOAT,
  ag                 FLOAT,
  ag_lower           FLOAT,
  ag_upper           FLOAT,
  a0                 FLOAT,
  a0_lower           FLOAT,
  a0_upper           FLOAT
);
```

## Source

The Gaia DR3 catalog is obtained from the [Gaia Archive][gaia]. The advanced query mode is used to extract the source around the Galactic center. The extraction constrains are as follows:

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

The converted CSV file is hosted in [the catalog download page][download].

[download]: http://exoplanets.sakura.ne.jp/jasmine/
[gaia]: https://gea.esac.esa.int/archive/
