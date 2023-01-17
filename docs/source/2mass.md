# 2MASS Point-Source Catalog


## Schema

``` sql
CREATE TABLE IF NOT EXISTS tmass_sources (
  source_id          BIGSERIAL PRIMARY KEY,
  ra                 FLOAT(10) NOT NULL,
  dec                FLOAT(10) NOT NULL,
  designation        VARCHAR(32) NOT NULL,
  phot_j_mag         FLOAT(10),
  phot_j_cmsig       FLOAT(10),
  phot_j_mag_error   FLOAT(10),
  phot_j_snr         FLOAT(10),
  phot_h_mag         FLOAT(10),
  phot_h_cmsig       FLOAT(10),
  phot_h_mag_error   FLOAT(10),
  phot_h_snr         FLOAT(10),
  phot_ks_mag        FLOAT(10),
  phot_ks_cmsig      FLOAT(10),
  phot_ks_mag_error  FLOAT(10),
  phot_ks_snr        FLOAT(10),
  quality_flag       VARCHAR(3) NOT NULL,
  contaminated       INT NOT NULL,
  glon               FLOAT(10) NOT NULL,
  glat               FLOAT(10) NOT NULL,
  rd_flg             VARCHAR(3) NOT NULL,
  color_j_h          FLOAT(10),
  color_h_ks         FLOAT(10),
  color_j_ks         FLOAT(10)
);
```

## Source
### 2mass Point-Source catalog
2MASS Point-Source catalog can be obtained from the [Gator catalog query][gator] in [IRSA][irsa]. The extraction constrains are as follows:

- Galactic longitude between -2.5 and 1.2 degree.
- Galactic latitude between -1.2 and 1.2 degree.
- Not flagged as minor planets.

``` sql
mp_flg =0 and glon >=-2.5 and glon <=1.2 and glat >=-1.2 and glat <=1.2
```

The original 2mass catalog is not compatible with the database, and the precisions of `glon` and `glat` records are not sufficient. Use `convert_2mass.py` to reformat the original CSV catalog. The usage of the `convert_2mass.py` is as follows.

``` sh
$ ./script/convert_2mass.py -h
usage: convert_2mass.py [-h] [-f] src csv

Reformat 2MASS catalog

positional arguments:
  src              input CSV catalog
  csv              output CSV catalog

optional arguments:
  -h, --help       show this help message and exit
  -f, --overwrite  overwrite if the output file exists.
```

The following command reformats `2mass_gccat.csv`.

``` sh
python script/convert_2mass.py 2mass_gccat.csv 2mass_gccat.mod.csv
```

The revised CSV file is imported into the database by `COPY` command.

``` sh
psql -h localhost -p 15432 -d jasmine -U admin \
  -c "COPY tmass_sources \
  (ra,dec,designation,\
   phot_j_mag,phot_j_cmsig,phot_j_mag_error,phot_j_snr,\
   phot_h_mag,phot_h_cmsig,phot_h_mag_error,phot_h_snr,\
   phot_ks_mag,phot_ks_cmsig,phot_ks_mag_error,phot_ks_snr,\
   quality_flag,contaminated,glon,glat,rd_flg,\
   color_j_h,color_h_ks,color_j_ks) \
  FROM '/data/catalog/2mass_gccat.mod.csv' \
  DELIMITER',' CSV HEADER;"
```

[gator]: https://irsa.ipac.caltech.edu/cgi-bin/Gator/nph-dd?catalog=fp_psc
[irsa]: https://irsa.ipac.caltech.edu/frontpage/
