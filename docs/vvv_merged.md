# VVV Band Merged Catalogue

[esonews]: https://www.eso.org/sci/publications/announcements/sciann17340.html

## Schema

``` sql
CREATE TABLE IF NOT EXISTS vvv_sources_orig (
  source_id          BIGINT PRIMARY KEY,
  glon               FLOAT(10) NOT NULL,
  glat               FLOAT(10) NOT NULL,
  ra                 FLOAT(10) NOT NULL,
  dec                FLOAT(10) NOT NULL,
  phot_z1_mag        FLOAT(10),
  phot_z1_mag_error  FLOAT(10),
  phot_z2_mag        FLOAT(10),
  phot_z2_mag_error  FLOAT(10),
  phot_y1_mag        FLOAT(10),
  phot_y1_mag_error  FLOAT(10),
  phot_y2_mag        FLOAT(10),
  phot_y2_mag_error  FLOAT(10),
  phot_j1_mag        FLOAT(10),
  phot_j1_mag_error  FLOAT(10),
  phot_j2_mag        FLOAT(10),
  phot_j2_mag_error  FLOAT(10),
  phot_h1_mag        FLOAT(10),
  phot_h1_mag_error  FLOAT(10),
  phot_h2_mag        FLOAT(10),
  phot_h2_mag_error  FLOAT(10),
  phot_ks1_mag       FLOAT(10),
  phot_ks1_mag_error FLOAT(10),
  phot_ks2_mag       FLOAT(10),
  phot_ks2_mag_error FLOAT(10),
  pstar              FLOAT(10) NOT NULL,
  psaturated         FLOAT(10) NOT NULL
);
```

``` sql
CREATE OR REPLACE VIEW vvv_sources AS
SELECT
  source_id,
  glon,
  glat,
  ra,
  dec,
  COALESCE(phot_z2_mag,phot_z1_mag) AS phot_z_mag,
  COALESCE(phot_z2_mag_error,phot_z1_mag_error) AS phot_z_mag_error,
  COALESCE(phot_y2_mag,phot_y1_mag) AS phot_y_mag,
  COALESCE(phot_y2_mag_error,phot_y1_mag_error) AS phot_y_mag_error,
  COALESCE(phot_j2_mag,phot_j1_mag) AS phot_j_mag,
  COALESCE(phot_j2_mag_error,phot_j1_mag_error) AS phot_j_mag_error,
  COALESCE(phot_h2_mag,phot_h1_mag) AS phot_h_mag,
  COALESCE(phot_h2_mag_error,phot_h1_mag_error) AS phot_h_mag_error,
  COALESCE(phot_ks2_mag,phot_ks1_mag) AS phot_ks_mag,
  COALESCE(phot_ks2_mag_error,phot_ks1_mag_error) AS phot_ks_mag_error
FROM
  vvv_sources_orig;
```

## Source
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
  ks_1apermag4 as phot_ks1_mag,
  ks_1apermag4err as phot_ks1_mag_error,
  ks_2apermag4 as phot_ks2_mag,
  ks_2apermag4err as phot_ks2_mag_error,
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
  -c "COPY vvv_sources_orig \
  (source_id,glon,glat,ra,dec,\
   phot_z1_mag,phot_z1_mag_error,phot_z2_mag,phot_z2_mag_error,\
   phot_y1_mag,phot_y1_mag_error,phot_y2_mag,phot_y2_mag_error,\
   phot_j1_mag,phot_j1_mag_error,phot_j2_mag,phot_j2_mag_error,\
   phot_h1_mag,phot_h1_mag_error,phot_h2_mag,phot_h2_mag_error,\
   phot_ks1_mag,phot_ks1_mag_error,phot_ks2_mag,phot_ks2_mag_error,\
   pstar,psaturated) \
  FROM '/data/catalog/vvv_bandmerged.csv' \
  DELIMITER',' CSV HEADER;"
```

[esotap]: http://archive.eso.org/programmatic/
