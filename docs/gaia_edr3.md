# Gaia EDR3 catalog

## Schema

``` sql
CREATE TABLE IF NOT EXISTS edr3_sources (
  source_id          BIGINT PRIMARY KEY,
  ra                 FLOAT(10) NOT NULL,
  dec                FLOAT(10) NOT NULL,
  glon               FLOAT(10) NOT NULL,
  glat               FLOAT(10) NOT NULL,
  parallax           FLOAT(10),
  parallax_error     FLOAT(10),
  pm                 FLOAT(10),
  pmra               FLOAT(10),
  pmra_error         FLOAT(10),
  pmdec              FLOAT(10),
  pmdec_error        FLOAT(10),
  phot_g_mag         FLOAT(10),
  phot_g_mag_error   FLOAT(10),
  phot_bp_mag        FLOAT(10),
  phot_bp_mag_error  FLOAT(10),
  phot_rp_mag        FLOAT(10),
  phot_rp_mag_error  FLOAT(10)
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
  parallax,
  parallax_error,
  pm,
  pmra,
  pmra_error,
  pmdec,
  pmdec_error,
  phot_g_mean_mag AS phot_g_mag,
  2.5*log10(1+1.0/phot_g_mean_flux_over_error) AS phot_g_mag_error,
  phot_bp_mean_mag AS phot_bp_mag,
  2.5*log10(1+1.0/phot_bp_mean_flux_over_error) AS phot_bp_mag_error,
  phot_rp_mean_mag AS phot_rp_mag,
  2.5*log10(1+1.0/phot_rp_mean_flux_over_error) AS phot_rp_mag_error
FROM
  gaiaedr3.gaia_source
WHERE
  (l BETWEEN -2.5 AND 1.2) AND (b BETWEEN -1.2 AND 1.2);
```

The obtained CSV file is imported into the database by `COPY` command.

``` sh
psql -h localhost -p 15432 -d jasmine -U admin \
  -c "COPY edr3_sources \
  (source_id,ra,dec,glon,glat,\
   parallax,parallax_error,pm,pmra,pmra_error,pmdec,pmdec_error,\
   phot_g_mag,phot_g_mag_error,\
   phot_bp_mag,phot_bp_mag_error,\
   phot_rp_mag,phot_rp_mag_error) \
  FROM '/data/catalog/gaia_edr3_gccat.csv' \
  DELIMITER',' CSV HEADER;"
```

[gaia]: https://gea.esac.esa.int/archive/
