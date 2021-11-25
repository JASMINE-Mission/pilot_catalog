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

The converted CSV file is imported into the database by `COPY` command.

``` sh
psql -h localhost -p 15432 -d jasmine -U admin \
  -c "COPY sirius_sources_orig (glon,glat,ra,dec,position_j_x,position_j_y,phot_j_mag,phot_j_mag_error,position_h_x,position_h_y,phot_h_mag,phot_h_mag_error,position_k_x,position_k_y,phot_k_mag,phot_k_mag_error,plate_name) FROM '/data/catalog/sirius_WGCCatAll.csv' DELIMITER',' CSV HEADER;"
```

The original catalog contains objects outside of the nominal field. The `sirius_sources` is a view of `sirius_sources_orig`, where objects outside of the JASMINE field are removed.


### VVV Band-Merged Source Catalog

``` sql
SELECT
  sourceid as source_id,
  l as glon,
  b as glat,
  ra2000 as ra,
  dec2000 as dec,
  z_1apermag4 as phot_z1_mag,
  z_1apermag4err as phot_z1_mag_error,
  z_2apermag4 as phot_z2_mag,
  z_2apermag4err as phot_z2_mag_error,
  y_1apermag4 as phot_y1_mag,
  y_1apermag4err as phot_y1_mag_error,
  y_2apermag4 as phot_y2_mag,
  y_2apermag4err as phot_y2_mag_error,
  j_1apermag4 as phot_j1_mag,
  j_1apermag4err as phot_j1_mag_error,
  j_2apermag4 as phot_j2_mag,
  j_2apermag4err as phot_j2_mag_error,
  h_1apermag4 as phot_h1_mag,
  h_1apermag4err as phot_h1_mag_error,
  h_2apermag4 as phot_h2_mag,
  h_2apermag4err as phot_h2_mag_error,
  ks_1apermag4 as phot_k1_mag,
  ks_1apermag4err as phot_k1_mag_error,
  ks_2apermag4 as phot_k2_mag,
  ks_2apermag4err as phot_k2_mag_error,
  pstar,
  psaturated
FROM
  VVV_bandMergedSourceCat_V3
WHERE
  (l < 1.2 OR 360-2.5 < l) AND (b BETWEEN -1.2 AND 1.2)
```

The requested catalog is, however, too large to retrieve. The catalog is separated into the positive and negative halfs in the galactic latitude. The obtained catalog is converted into a CSV file using `astropy.io.votable`.

``` python
import astropy.io.votable as vot
import numpy as np
import pandas as pd

votab_p = vot.parse('./vvv_bandmerged_p.votable')
votab_m = vot.parse('./vvv_bandmerged_m.votable')
table_p = votab_p.resources[0].tables[0]
table_m = votab_m.resources[0].tables[0]
df_p = pd.DataFrame(np.array(table_p.array))
df_m = pd.DataFrame(np.array(table_m.array))
df = pd.concat((df_p,df_m))
df.to_csv('./vvv_bandmerged.csv', index=False)
```

Then, the CSV file is imported to the database.

``` sh
psql -h localhost -p 15432 -d jasmine -U admin \
  -c "COPY vvv_sources_orig (source_id,glon,glat,ra,dec,phot_z1_mag,phot_z1_mag_error,phot_z2_mag,phot_z2_mag_error,phot_y1_mag,phot_y1_mag_error,phot_y2_mag,phot_y2_mag_error,phot_j1_mag,phot_j1_mag_error,phot_j2_mag,phot_j2_mag_error,phot_h1_mag,phot_h1_mag_error,phot_h2_mag,phot_h2_mag_error,phot_k1_mag,phot_k1_mag_error,phot_k2_mag,phot_k2_mag_error,pstar,psaturated) FROM '/data/catalog/vvv_bandmerged.csv' DELIMITER',' CSV HEADER;"
```

[esotap]: http://archive.eso.org/programmatic/


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
  -c "COPY tmass_sources (ra,dec,designation,phot_j_mag,phot_j_cmsig,phot_j_mag_error,phot_j_snr,phot_h_mag,phot_h_cmsig,phot_h_mag_error,phot_h_snr,phot_k_mag,phot_k_cmsig,phot_k_mag_error,phot_k_snr,quality_flag,contaminated,glon,glat,rd_flg,color_j_h,color_h_k,color_j_k) FROM '/data/catalog/2mass_gccat.mod.csv' DELIMITER',' CSV HEADER;"
```

[gator]: https://irsa.ipac.caltech.edu/cgi-bin/Gator/nph-dd?catalog=fp_psc
[irsa]: https://irsa.ipac.caltech.edu/frontpage/


### Gaia EDR3 catalog around Galactic Center

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
  -c "COPY edr3_sources (source_id,ra,dec,glon,glat,parallax,parallax_error,pm,pmra,pmra_error,pmdec,pmdec_error,phot_g_mag,phot_g_mag_error,phot_bp_mag,phot_bp_mag_error,phot_rp_mag,phot_rp_mag_error) FROM '/data/catalog/gaia_edr3_gccat.csv' DELIMITER',' CSV HEADER;"
```

[gaia]: https://gea.esac.esa.int/archive/
