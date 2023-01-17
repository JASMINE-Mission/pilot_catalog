# 2MASS Point-Source Catalog


## Schema

``` sql
CREATE TABLE IF NOT EXISTS tmass_sources (
  source_id          BIGSERIAL PRIMARY KEY,
  ra                 FLOAT NOT NULL,
  dec                FLOAT NOT NULL,
  designation        VARCHAR(32) NOT NULL,
  phot_j_mag         FLOAT,
  phot_j_cmsig       FLOAT,
  phot_j_mag_error   FLOAT,
  phot_j_snr         FLOAT,
  phot_h_mag         FLOAT,
  phot_h_cmsig       FLOAT,
  phot_h_mag_error   FLOAT,
  phot_h_snr         FLOAT,
  phot_ks_mag        FLOAT,
  phot_ks_cmsig      FLOAT,
  phot_ks_mag_error  FLOAT,
  phot_ks_snr        FLOAT,
  quality_flag       VARCHAR(3) NOT NULL,
  contaminated       INT NOT NULL,
  glon               FLOAT NOT NULL,
  glat               FLOAT NOT NULL,
  rd_flg             VARCHAR(3) NOT NULL,
  color_j_h          FLOAT,
  color_h_ks         FLOAT,
  color_j_ks         FLOAT
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

``` console
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

``` console
$ python script/convert_2mass.py 2mass_gccat.csv 2mass_psc_jasmine_field.csv
```


The converted CSV file is hosted in [the catalog download page][download].

[download]: http://exoplanets.sakura.ne.jp/jasmine/
[gator]: https://irsa.ipac.caltech.edu/cgi-bin/Gator/nph-dd?catalog=fp_psc
[irsa]: https://irsa.ipac.caltech.edu/frontpage/
