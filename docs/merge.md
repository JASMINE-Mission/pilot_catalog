# Merged Catalog

## Catalog Overview

The structure of the merged catalog is as follows. The catalog contains the coordinates (Galactic and ICRS) and _Hw_-, _J_-, _H_-, and _Ks_-band magnitudes. Note that the Galactic Longitude is wrapped around 180&deg;. Thus, the range of `glon` is (-180&deg;, 180&deg;). Indexes are created for all the coordinates and magnitudes. The arrangement of the records are optimized for searching by (`glon`, `glat`). Use [`q3c` functions][q3c] for efficient search by coordinates.

[q3c]: https://github.com/segasai/q3c

``` sql
CREATE TABLE merged_sources (
  source_id          BIGSERIAL PRIMARY KEY, --- unique source ID
  tmass_source_id    BIGINT,                --- source ID in 2MASS table
  sirius_source_id   BIGINT,                --- source ID in SIRIUS table
  vvv_source_id      BIGINT,                --- source ID in VIRAC table
  glon               FLOAT(10),             --- Galactic Longitude (deg)
  glat               FLOAT(10),             --- Galactic Latitude (deg)
  ra                 FLOAT(10),             --- Right Ascension (deg)
  dec                FLOAT(10),             --- Declination (deg)
  position_source    VARCHAR(1),            --- position reference (V,S,2)
  phot_hw_mag        FLOAT(10),             --- Hw-band magnitude
  phot_hw_mag_error  FLOAT(10),             --- Hw-band magnitude error
  phot_hw_mag_source VARCHAR(1),            --- Hw mag. reference (V,S,2)
  phot_j_mag         FLOAT(10),             --- J-band magnitude
  phot_j_mag_error   FLOAT(10),             --- J-band magnitude error
  phot_j_mag_source  VARCHAR(1),            --- J mag. reference (V,S,2)
  phot_h_mag         FLOAT(10),             --- H-band magnitude
  phot_h_mag_error   FLOAT(10),             --- H-band magnitude error
  phot_h_mag_source  VARCHAR(1),            --- H mag. reference (V,S,2)
  phot_ks_mag        FLOAT(10),             --- Ks-band magnitude
  phot_ks_mag_error  FLOAT(10),             --- Ks-band magnitude
  phot_ks_mag_source VARCHAR(1)             --- Ks mag. reference (V,S,2)
);
```

The `link_edr3` table is prepared for a cross match with the Gaia EDR3 catalog. The structure of the table is as follows. Use this table as a link to retrieve the Gaia EDR3 sources around sources in the merged catalog.

``` sql
CREATE TABLE link_edr3 (
  link_id          BIGSERIAL PRIMARY KEY,   --- unique link ID
  merged_source_id BIGINT NOT NULL,         --- source ID in merged table
  edr3_source_id   BIGINT NOT NULL,         --- source ID in Gaia EDR3 table
  distance         FLOAT(10) NOT NULL       --- distance in arcseconds
);
```

Select sources from the merged catalog. Then, the selected sources are linked to objects in the Gaia EDR3 catalog. The following query extracts the sources in the JASMINE field. The data of the Gaia EDR3 catalog are attached if matched.

``` sql
SELECT
  m.*,
  e.*
FROM (
  SELECT * FROM merged_sources
  WHERE within_jasmine_field(glon,glat)
) as m
LEFT JOIN
  link_edr3 as l ON m.source_id = l.merged_source_id
LEFT JOIN
  edr3_sources as e ON l.edr3_source_id = e.source_id;
```


### The statistics of the sources in the JASMINE field

The merged catalog contains 2789173 sources in the JASMINE field. The number of the photometric measurements in each band is listed in the following table. The _Hw_-band magnitudes are defined for about 43 % of the sources. The ratio is limited by the number of the objects with the _J_-band magnitudes.

|Band|Number|Ratio|
|---|---|---|
|_Hw_-band|1224613|0.439|
|_J_-band |1286852|0.461|
|_H_-band |2363883|0.848|
|_Ks_-band|2692101|0.965|
|Total    |2789173|---|


The histogram of the _J_-band magnitudes is described below. The profile suggests that the sources with $m_J < 17$ are complete. However, the completeness limit should be investigated quantitatively.

![J-band histogram in Jasmine Field](./image/histogram_j-band_jasmine_field.png)


The histogram of the _Hw_-band magnitudes is illustrated. The completeness limit is possibly about 16.5 mag. Note that this limit should be evaluated in a proper way.

![Hw-band histogram in Jasmine Field](./image/histogram_hw-band_jasmine_field.png)

The distribution of the sources brighter than 14.5 mag in the _Hw_-band is illustrated. The total number of the sources are 117230. The number is consistent with the original estimate of the JASMINE target sources.

![Distribution of the sources with Hw < 14.5](./image/jasmine_field.png)

## Merge procedure

The three catalogs (2MASS, SIRIUS, and VIRAC) are compiled into the JASMINE merged catalog. The catalogs are sequentially merged. First, the 2MASS and SIRIUS catalogs are merged with a cross-match radius of 1.0&Prime;. The SIRIUS coordinates get preference over the 2MASS coordinates. Magnitudes with smaller uncertainties are selected. Then, the temporary catalog is merged with VIRAC. The cross-match radius is 1.0&Prime;. The VIRAC coordinates are adopted for matched sources. Magnitudes with smaller uncertainties are selected.


### Calculation of Hw magnitude

JASMINE's _Hw_ magnitude is calculated using _J_- and _H_-bands of each catalog. The conversion functions are adopted from Yano-san's presentation in ASJ meeting 2021 [(PDF)][V204a]. The _Hw_ magnitudes for VIRAC are calculated with the VVV filter set as follows.

[V204a]: http://jasmine.nao.ac.jp/doc/yano-20210913-V204a.pdf

$$
H_W = 0.7988 J + 0.2012 H -0.0315 JH^2 \quad \sigma=0.033
$$

The _Hw_ magnitudes for the SIRIUS catalog is described below.

$$
H_W = 0.7796 J + 0.2204 H -0.0326 JH^2 \quad \sigma=0.063
$$

The _Hw_ magnitudes for the 2MASS point-source catalog is given below.

$$
H_W = 0.7829 J + 0.2171 H -0.0323 JH^2 \quad \sigma=0.035
$$

The merged catalog contains the _Hw_ magnitude with the smallest uncertainty. Note that the _Hw_ magnitude is not defined if either of the _J_- or _H_-band magnitudes is not defined.
