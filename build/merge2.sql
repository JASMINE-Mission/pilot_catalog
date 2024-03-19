--select candidates to be duplicates

DROP TABLE IF EXISTS merged_sources_dups_candidates CASCADE;

CREATE TABLE merged_sources_dups_candidates AS
SELECT m.*,c.count as num_neighbours,SQRT(POWER(COALESCE(m.phot_j_mag_error,0),2)+POWER(COALESCE(m.phot_h_mag_error,0),2)+POWER(COALESCE(m.phot_ks_mag_error,0),2)) as phot_error FROM merged_sources_confusion_06_5  as c LEFT JOIN merged_sources as m on m.source_id=c.source_id WHERE c.count>1;

CREATE INDEX IF NOT EXISTS merged_sources_dups_candidates_source_id
  ON merged_sources_dups_candidates (source_id);
CREATE INDEX IF NOT EXISTS merged_sources_dups_candidates_vvv_source_id
  ON merged_sources_dups_candidates (vvv_source_id);
CREATE INDEX IF NOT EXISTS merged_sources_dups_candidates_sirius_source_id
  ON merged_sources_dups_candidates (sirius_source_id);
CREATE INDEX IF NOT EXISTS merged_sources_dups_candidates_tmass_source_id
  ON merged_sources_dups_candidates (tmass_source_id);
CREATE INDEX IF NOT EXISTS merged_sources_dups_candidates_glonglat
  ON merged_sources_dups_candidates (q3c_ang2ipix(glon,glat));
CLUSTER merged_sources_dups_candidates_glonglat ON merged_sources_dups_candidates;
ANALYZE merged_sources_dups_candidates;



--DROP TABLE IF EXISTS merged_sources_dups_typeA CASCADE;

--CREATE TABLE merged_sources_dups_typeA_aux AS
--SELECT t1.*,t2.source_id as source_id_neighbour,t2.position_source as position_source_neighbour,t2.magnitude_source as magnitude_source_neighbour,t2.glon as glon_neighbour, t2.glat as glat_neighbour, t2.phot_j_mag as phot_j_mag_neighbour, t2.phot_j_mag_error as phot_j_mag__error_neighbour, t2.phot_h_mag as phot_h_mag_neighbour, t2.phot_h_mag_error as phot_h_mag__error_neighbour, t2.phot_ks_mag as phot_ks_mag_neighbour,  t2.phot_ks_mag_error as phot_ks_mag__error_neighbour,
--CASE WHEN t1.source_id<t2.source_id THEN CONCAT(CAST(t1.source_id AS varchar),'-',CAST(t2.source_id AS varchar)) ELSE CONCAT(CAST(t2.source_id AS varchar),'-',CAST(t1.source_id AS varchar)) END as pair_id 
--FROM merged_sources_dups_candidates AS t1 INNER JOIN merged_sources_dups_candidates AS t2 ON q3c_join(t1.glon,t1.glat,t2.glon,t2.glat,0.6/3600.);

--CREATE TABLE merged_sources_dups_typeA AS --the closest neighbour is a VVV source and the main source is bright
--SELECT aux.* FROM merged_sources_dups_typeA_aux AS aux WHERE (aux.source_id != aux.source_id_neighbour) AND (aux.magnitude_source_neighbour='TV' OR aux.magnitude_source_neighbour='TVS' OR aux.magnitude_source_neighbour='VS' OR aux.magnitude_source_neighbour='V') AND (aux.phot_j_mag<=13 OR aux.phot_h_mag<=13 OR aux.phot_ks_mag<=13) AND (aux.magnitude_source != 'V');

--DROP TABLE merged_sources_dups_typeA_aux CASCADE;



-- solve sources with a duplicated tmass_source_id
DROP TABLE IF EXISTS merged_sources_dups_tmass CASCADE;

CREATE TABLE merged_sources_dups_tmass AS --two merged sources sharing the same source from any catalogue
SELECT m.*,aux.num_neighbours,aux.counts,aux.phot_error FROM (SELECT select_better_agg(source_id,phot_error) as source_id,
tmass_source_id,
select_better_agg(sirius_source_id,phot_error) as sirius_source_id,
select_better_agg(vvv_source_id,phot_error) as vvv_source_id,
select_better_agg(glon,phot_error) as glon,
select_better_agg(glat,phot_error) as glat,
select_better_agg(phot_j_mag,phot_error) as phot_j_mag,
select_better_agg(phot_j_mag_error,phot_error) as phot_j_mag_error,
select_better_agg(phot_h_mag,phot_error) as phot_h_mag,
select_better_agg(phot_h_mag_error,phot_error) as phot_h_mag_error,
select_better_agg(phot_ks_mag,phot_error) as phot_ks_mag,
select_better_agg(phot_ks_mag_error,phot_error) as phot_ks_mag_error,
MAX(num_neighbours) as num_neighbours,
select_better_agg(phot_error,phot_error) as phot_error,
COUNT(*) AS counts
FROM merged_sources_dups_candidates WHERE tmass_source_id IS NOT NULL GROUP BY tmass_source_id) AS aux INNER JOIN merged_sources_raw AS m ON aux.source_id = m.source_id WHERE counts>1;



-- solve sources with a duplicated sirius_source_id
DROP TABLE IF EXISTS merged_sources_dups_sirius CASCADE;

CREATE TABLE merged_sources_dups_sirius AS --two merged sources sharing the same source from any catalogue
SELECT m.*,aux.num_neighbours,aux.counts,aux.phot_error FROM (SELECT select_better_agg(source_id,phot_error) as source_id,
select_better_agg(tmass_source_id,phot_error) as tmass_source_id,
sirius_source_id,
select_better_agg(vvv_source_id,phot_error) as vvv_source_id,
select_better_agg(glon,phot_error) as glon,
select_better_agg(glat,phot_error) as glat,
select_better_agg(phot_j_mag,phot_error) as phot_j_mag,
select_better_agg(phot_j_mag_error,phot_error) as phot_j_mag_error,
select_better_agg(phot_h_mag,phot_error) as phot_h_mag,
select_better_agg(phot_h_mag_error,phot_error) as phot_h_mag_error,
select_better_agg(phot_ks_mag,phot_error) as phot_ks_mag,
select_better_agg(phot_ks_mag_error,phot_error) as phot_ks_mag_error,
MAX(num_neighbours) as num_neighbours,
select_better_agg(phot_error,phot_error) as phot_error,
COUNT(*) AS counts
FROM merged_sources_dups_candidates WHERE sirius_source_id IS NOT NULL GROUP BY sirius_source_id) AS aux INNER JOIN merged_sources_raw AS m ON aux.source_id = m.source_id WHERE counts>1;



-- solve sources with a duplicated vvv_source_id
DROP TABLE IF EXISTS merged_sources_dups_vvv CASCADE;

CREATE TABLE merged_sources_dups_vvv AS --two merged sources sharing the same source from any catalogue
SELECT m.*,aux.num_neighbours,aux.counts,aux.phot_error FROM (SELECT select_better_agg(source_id,phot_error) as source_id,
select_better_agg(tmass_source_id,phot_error) as tmass_source_id,
select_better_agg(sirius_source_id,phot_error) as sirius_source_id,
vvv_source_id,
select_better_agg(glon,phot_error) as glon,
select_better_agg(glat,phot_error) as glat,
select_better_agg(phot_j_mag,phot_error) as phot_j_mag,
select_better_agg(phot_j_mag_error,phot_error) as phot_j_mag_error,
select_better_agg(phot_h_mag,phot_error) as phot_h_mag,
select_better_agg(phot_h_mag_error,phot_error) as phot_h_mag_error,
select_better_agg(phot_ks_mag,phot_error) as phot_ks_mag,
select_better_agg(phot_ks_mag_error,phot_error) as phot_ks_mag_error,
MAX(num_neighbours) as num_neighbours,
select_better_agg(phot_error,phot_error) as phot_error,
COUNT(*) AS counts
FROM merged_sources_dups_candidates WHERE vvv_source_id IS NOT NULL GROUP BY vvv_source_id) AS aux INNER JOIN merged_sources_raw AS m ON aux.source_id = m.source_id WHERE counts>1;




DROP TABLE IF EXISTS merged_sources_dups_candidates2 CASCADE;

CREATE TABLE merged_sources_dups_candidates2 AS
SELECT m.* FROM merged_sources_dups_candidates AS m 
LEFT OUTER JOIN merged_sources_dups_tmass AS t ON m.tmass_source_id=t.tmass_source_id 
LEFT OUTER JOIN merged_sources_dups_sirius AS s ON m.sirius_source_id=s.sirius_source_id 
LEFT OUTER JOIN merged_sources_dups_vvv AS v ON m.vvv_source_id=v.vvv_source_id
WHERE t.source_id IS NULL AND s.source_id IS NULL AND v.source_id IS NULL;

CREATE INDEX IF NOT EXISTS merged_sources_dups_candidates2_source_id
  ON merged_sources_dups_candidates2 (source_id);
CREATE INDEX IF NOT EXISTS merged_sources_dups_candidates2_vvv_source_id
  ON merged_sources_dups_candidates2 (vvv_source_id);
CREATE INDEX IF NOT EXISTS merged_sources_dups_candidates2_sirius_source_id
  ON merged_sources_dups_candidates2 (sirius_source_id);
CREATE INDEX IF NOT EXISTS merged_sources_dups_candidates2_tmass_source_id
  ON merged_sources_dups_candidates2 (tmass_source_id);
CREATE INDEX IF NOT EXISTS merged_sources_dups_candidates2_glonglat
  ON merged_sources_dups_candidates2 (q3c_ang2ipix(glon,glat));
CLUSTER merged_sources_dups_candidates2_glonglat ON merged_sources_dups_candidates2;
ANALYZE merged_sources_dups_candidates2;

DROP TABLE IF EXISTS merged_sources_dups_candidates2_full CASCADE;

CREATE TABLE merged_sources_dups_candidates2_full AS
SELECT * FROM merged_sources_dups_candidates2
UNION
SELECT DISTINCT ON (tmass_source_id,sirius_source_id,vvv_source_id) aux.source_id, aux.tmass_source_id,aux.sirius_source_id,aux.vvv_source_id,aux.glon,aux.glat,aux.ra,aux.dec,aux.position_source,aux.magnitude_source,aux.phot_hw_mag,aux.phot_hw_mag_error,aux.phot_j_mag,aux.phot_j_mag_error,aux.phot_h_mag,aux.phot_h_mag_error,aux.phot_ks_mag,aux.phot_ks_mag_error,aux.num_neighbours,aux.phot_error FROM (SELECT * FROM merged_sources_dups_tmass UNION SELECT * FROM merged_sources_dups_sirius UNION SELECT * FROM merged_sources_dups_vvv) AS aux;

CREATE INDEX IF NOT EXISTS merged_sources_dups_candidates2_full_source_id
  ON merged_sources_dups_candidates2_full (source_id);
CREATE INDEX IF NOT EXISTS merged_sources_dups_candidates2_full_vvv_source_id
  ON merged_sources_dups_candidates2_full (vvv_source_id);
CREATE INDEX IF NOT EXISTS merged_sources_dups_candidates2_full_sirius_source_id
  ON merged_sources_dups_candidates2_full (sirius_source_id);
CREATE INDEX IF NOT EXISTS merged_sources_dups_candidates2_full_tmass_source_id
  ON merged_sources_dups_candidates2_full (tmass_source_id);
CREATE INDEX IF NOT EXISTS merged_sources_dups_candidates2_full_glonglat
  ON merged_sources_dups_candidates2_full (q3c_ang2ipix(glon,glat));
CLUSTER merged_sources_dups_candidates2_full_glonglat ON merged_sources_dups_candidates2_full;
ANALYZE merged_sources_dups_candidates2_full;



DROP TABLE IF EXISTS merged_sources_dups_clean CASCADE;

CREATE TABLE merged_sources_dups_clean (
  source_id          BIGSERIAL PRIMARY KEY,
  tmass_source_id    BIGINT,
  sirius_source_id   BIGINT,
  vvv_source_id      BIGINT,
  glon               FLOAT,
  glat               FLOAT,
  ra                 FLOAT,
  dec                FLOAT,
  position_source    VARCHAR(1),
  magnitude_source   VARCHAR(3),
  phot_hw_mag        FLOAT,
  phot_hw_mag_error  FLOAT,
  phot_j_mag         FLOAT,
  phot_j_mag_error   FLOAT,
  phot_h_mag         FLOAT,
  phot_h_mag_error   FLOAT,
  phot_ks_mag        FLOAT,
  phot_ks_mag_error  FLOAT
);

WITH AUX_2 AS (
SELECT source_id
FROM (SELECT select_better(d1.source_id,d1.phot_error,d2.source_id,d2.phot_error) as source_id,LEAST(d1.phot_error,d2.phot_error) as phot_error FROM merged_sources_dups_candidates2_full as d1 INNER JOIN merged_sources_dups_candidates2_full as d2 ON q3c_join(d1.ra,d1.dec,d2.ra,d2.dec,1.0/3600) AND jhk_match(d1.phot_j_mag,d2.phot_j_mag,d1.phot_h_mag,d2.phot_h_mag,d1.phot_ks_mag,d2.phot_ks_mag,2.0::FLOAT) WHERE d1.source_id!=d2.source_id) AS aux GROUP BY aux.source_id)
INSERT INTO merged_sources_dups_clean
SELECT m.* FROM merged_sources_raw as m INNER JOIN AUX_2 as a ON m.source_id = a.source_id;


--update merge catalogue after fixing cases with shared source ids

DROP TABLE IF EXISTS merged_sources CASCADE;
CREATE TABLE merged_sources (
  source_id          BIGSERIAL PRIMARY KEY,
  tmass_source_id    BIGINT,
  sirius_source_id   BIGINT,
  vvv_source_id      BIGINT,
  glon               FLOAT,
  glat               FLOAT,
  ra                 FLOAT,
  dec                FLOAT,
  position_source    VARCHAR(1),
  magnitude_source   VARCHAR(3),
  phot_hw_mag        FLOAT,
  phot_hw_mag_error  FLOAT,
  phot_j_mag         FLOAT,
  phot_j_mag_error   FLOAT,
  phot_h_mag         FLOAT,
  phot_h_mag_error   FLOAT,
  phot_ks_mag        FLOAT,
  phot_ks_mag_error  FLOAT
);

INSERT INTO merged_sources
SELECT * FROM merged_sources_raw AS m
LEFT OUTER JOIN merged_sources_dups_tmass AS t ON m.tmass_source_id=t.tmass_source_id 
LEFT OUTER JOIN merged_sources_dups_sirius AS s ON m.sirius_source_id=s.sirius_source_id 
LEFT OUTER JOIN merged_sources_dups_vvv AS v ON m.vvv_source_id=v.vvv_source_id
WHERE t.source_id IS NULL AND s.source_id IS NULL AND v.source_id IS NULL
UNION 
SELECT DISTINCT ON (tmass_source_id,sirius_source_id,vvv_source_id) aux.source_id, aux.tmass_source_id,aux.sirius_source_id,aux.vvv_source_id,aux.glon,aux.glat,aux.ra,aux.dec,aux.position_source,aux.magnitude_source,aux.phot_hw_mag,aux.phot_hw_mag_error,aux.phot_j_mag,aux.phot_j_mag_error,aux.phot_h_mag,aux.phot_h_mag_error,aux.phot_ks_mag,aux.phot_ks_mag_error FROM (SELECT * FROM merged_sources_dups_tmass UNION SELECT * FROM merged_sources_dups_sirius UNION SELECT * FROM merged_sources_dups_vvv) AS aux;


CREATE INDEX IF NOT EXISTS merged_sources_tmass_source_id
  ON merged_sources (tmass_source_id);
CREATE INDEX IF NOT EXISTS merged_sources_vvv_source_id
  ON merged_sources (vvv_source_id);
CREATE INDEX IF NOT EXISTS merged_sources_sirius_source_id
  ON merged_sources (sirius_source_id);
CREATE INDEX IF NOT EXISTS merged_sources_radec
  ON merged_sources (q3c_ang2ipix(ra,dec));
CREATE INDEX IF NOT EXISTS merged_sources_glonglat
  ON merged_sources (q3c_ang2ipix(glon,glat));
CREATE INDEX IF NOT EXISTS merged_sources_hwmag
  ON merged_sources (phot_hw_mag);
CREATE INDEX IF NOT EXISTS merged_sources_jmag
  ON merged_sources (phot_j_mag);
CREATE INDEX IF NOT EXISTS merged_sources_hmag
  ON merged_sources (phot_h_mag);
CREATE INDEX IF NOT EXISTS merged_sources_ksmag
  ON merged_sources (phot_ks_mag);
CREATE INDEX IF NOT EXISTS merged_sources_ra
  ON merged_sources (ra);
CREATE INDEX IF NOT EXISTS merged_sources_dec
  ON merged_sources (dec);
CREATE INDEX IF NOT EXISTS merged_sources_glon
  ON merged_sources (glon);
CREATE INDEX IF NOT EXISTS merged_sources_glat
  ON merged_sources (glat);
CLUSTER merged_sources_glonglat ON merged_sources;
ANALYZE merged_sources;




--update merge catalogue after fixing all cases
DROP TABLE IF EXISTS merged_sources_clean CASCADE;
CREATE TABLE merged_sources_clean (
  source_id          BIGSERIAL PRIMARY KEY,
  tmass_source_id    BIGINT,
  sirius_source_id   BIGINT,
  vvv_source_id      BIGINT,
  glon               FLOAT,
  glat               FLOAT,
  ra                 FLOAT,
  dec                FLOAT,
  position_source    VARCHAR(1),
  magnitude_source   VARCHAR(3),
  phot_hw_mag        FLOAT,
  phot_hw_mag_error  FLOAT,
  phot_j_mag         FLOAT,
  phot_j_mag_error   FLOAT,
  phot_h_mag         FLOAT,
  phot_h_mag_error   FLOAT,
  phot_ks_mag        FLOAT,
  phot_ks_mag_error  FLOAT
);

INSERT INTO merged_sources_clean
SELECT * FROM merged_sources_clean AS m
LEFT OUTER JOIN merged_sources_dups_candidates AS d WHERE d.source_id IS NULL
UNION 
SELECT * FROM merged_sources_dups_clean;

CREATE INDEX IF NOT EXISTS merged_sources_clean_tmass_source_id
  ON merged_sources_clean (tmass_source_id);
CREATE INDEX IF NOT EXISTS merged_sources_clean_vvv_source_id
  ON merged_sources_clean (vvv_source_id);
CREATE INDEX IF NOT EXISTS merged_sources_clean_sirius_source_id
  ON merged_sources_clean (sirius_source_id);
CREATE INDEX IF NOT EXISTS merged_sources_clean_radec
  ON merged_sources_clean (q3c_ang2ipix(ra,dec));
CREATE INDEX IF NOT EXISTS merged_sources_clean_glonglat
  ON merged_sources_clean (q3c_ang2ipix(glon,glat));
CREATE INDEX IF NOT EXISTS merged_sources_clean_hwmag
  ON merged_sources_clean (phot_hw_mag);
CREATE INDEX IF NOT EXISTS merged_sources_clean_jmag
  ON merged_sources_clean (phot_j_mag);
CREATE INDEX IF NOT EXISTS merged_sources_clean_hmag
  ON merged_sources_clean (phot_h_mag);
CREATE INDEX IF NOT EXISTS merged_sources_clean_ksmag
  ON merged_sources_clean (phot_ks_mag);
CREATE INDEX IF NOT EXISTS merged_sources_clean_ra
  ON merged_sources_clean (ra);
CREATE INDEX IF NOT EXISTS merged_sources_clean_dec
  ON merged_sources_clean (dec);
CREATE INDEX IF NOT EXISTS merged_sources_clean_glon
  ON merged_sources_clean (glon);
CREATE INDEX IF NOT EXISTS merged_sources_clean_glat
  ON merged_sources_clean (glat);
CLUSTER merged_sources_clean_glonglat ON merged_sources_clean;
ANALYZE merged_sources_clean;