# JASMINE master source catalog


### Sirius Galactic Center catalog
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


### 2mass Point-Source catalog
2MASS Point-Source catalog can be obtained from the [Gator catalog query][gator] in [IRSA][irsa].

[gator]: https://irsa.ipac.caltech.edu/cgi-bin/Gator/nph-dd?catalog=fp_psc
[irsa]: https://irsa.ipac.caltech.edu/frontpage/

The constrains are as follows:

- Galactic longitude between -2.5&degree; and 1.2&degree;.
- Galactic latitude between -1.2&degree; and 1.2&degree;.
- Not flagged as minor planets.

``` sql
mp_flg =0 and glon >=-2.5 and glon <=1.2 and glat >=-1.2 and glat <=1.2
```

The original 2mass catalog is not compatible with the database.

``` sh
sed 's/\r$//;s/null//g;s/,-,-,/,,,/;s/,-,/,,/;s/,-$/,/' \
    2mass_gccat.csv > 2mass_gccat.mod.csv
```

The revised CSV file is imported into the database by `COPY` command.

``` sh
psql -h localhost -p 15432 -d jasmine -U admin \
  -c "COPY tmass_sources (ra,dec,designation,phot_j_mag,phot_j_cmsig,phot_j_mag_error,phot_j_snr,phot_h_mag,phot_h_cmsig,phot_h_mag_error,phot_h_snr,phot_k_mag,phot_k_cmsig,phot_k_mag_error,phot_k_snr,quality_flag,contaminated,glon,glat,rd_flg,color_j_h,color_h_k,color_j_k) FROM '/data/catalog/2mass_gccat.mod.csv' DELIMITER',' CSV HEADER;"
```