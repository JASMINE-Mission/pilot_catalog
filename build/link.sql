-- Link Gaia DR3 <-> 2MASS
DROP TABLE IF EXISTS link_gdr3_tmass CASCADE;
CREATE TABLE link_gdr3_tmass (
  link_id          BIGSERIAL PRIMARY KEY,
  tmass_source_id  BIGINT NOT NULL,
  gdr3_source_id   BIGINT NOT NULL,
  distance         FLOAT(10) NOT NULL
);

INSERT INTO link_gdr3_tmass
  (tmass_source_id,gdr3_source_id,distance)
SELECT
  t.source_id AS tmass_source_id,
  g.source_id AS gdr3_source_id,
  3600.0*q3c_dist(t.ra,t.dec,g.ra,g.dec) AS distance
FROM gdr3_sources AS g
JOIN tmass_sources_clean AS t
ON g.tmass_designation = t.designation;

CREATE INDEX IF NOT EXISTS link_gdr3_tmass_tmass_id
ON link_gdr3_tmass (tmass_source_id);
CREATE INDEX IF NOT EXISTS link_gdr3_tmass_gdr3_id
ON link_gdr3_tmass (gdr3_source_id);


-- Link Gaia DR3 <-> SIRIUS
DROP TABLE IF EXISTS link_gdr3_sirius CASCADE;
CREATE TABLE link_gdr3_sirius (
  link_id          BIGSERIAL PRIMARY KEY,
  sirius_source_id BIGINT NOT NULL,
  gdr3_source_id   BIGINT NOT NULL,
  distance         FLOAT(10) NOT NULL
);

WITH neighbours AS (SELECT
  aux.source_id AS sirius_source_id,
  g.source_id AS gdr3_source_id,
  aux.distance AS distance,
  ROW_NUMBER () OVER(PARTITION BY g.source_id ORDER BY aux.distance ASC) as ordering
FROM gdr3_sources AS g, LATERAL(
  SELECT source_id,3600.0*q3c_dist(s0.ra,s0.dec,g.ra_sirius,g.dec_sirius) as distance,
    CASE WHEN (s0.phot_ks_mag-g.phot_ks_mag_pred) IS NULL THEN 
      (CASE WHEN (s0.phot_h_mag-g.phot_h_mag_pred) IS NULL THEN (
        CASE WHEN (s0.phot_j_mag-g.phot_j_mag_pred) IS NULL THEN 0 ELSE s0.phot_j_mag-g.phot_j_mag_pred END)
          ELSE s0.phot_h_mag-g.phot_h_mag_pred END) 
            ELSE s0.phot_ks_mag-g.phot_ks_mag_pred END AS mag_diff
      FROM sirius_sources_clean AS s0 
      WHERE q3c_join(s0.ra,s0.dec,g.ra_sirius,g.dec_sirius,1./3600.)) as aux WHERE ABS(aux.mag_diff) < 1.0)
INSERT INTO link_gdr3_sirius
  (sirius_source_id,gdr3_source_id,distance)
SELECT sirius_source_id, gdr3_source_id, distance FROM neighbours WHERE ordering = 1;
--GREATEST(1.0,(GREATEST(g.ra_error,g.dec_error)*5 + g.pm*14)/1000)

CREATE INDEX IF NOT EXISTS link_gdr3_sirius_sirius_id
ON link_gdr3_sirius (sirius_source_id);
CREATE INDEX IF NOT EXISTS link_gdr3_sirius_gdr3_id
ON link_gdr3_sirius (gdr3_source_id);


-- Link Gaia DR3 <-> VVV
DROP TABLE IF EXISTS link_gdr3_vvv CASCADE;
CREATE TABLE link_gdr3_vvv (
  link_id          BIGSERIAL PRIMARY KEY,
  vvv_source_id BIGINT NOT NULL,
  gdr3_source_id   BIGINT NOT NULL,
  distance         FLOAT(10) NOT NULL
);

WITH neighbours AS (SELECT
  aux.source_id AS vvv_source_id,
  g.source_id AS gdr3_source_id,
  aux.distance AS distance,
  ROW_NUMBER () OVER(PARTITION BY g.source_id ORDER BY aux.distance ASC) as ordering
FROM gdr3_sources AS g, LATERAL(
  SELECT source_id,3600.0*q3c_dist(v0.ra,v0.dec,g.ra_vvv,g.dec_vvv) as distance,
    CASE WHEN (v0.phot_ks_mag-g.phot_ks_mag_pred) IS NULL THEN 
      (CASE WHEN (v0.phot_h_mag-g.phot_h_mag_pred) IS NULL THEN (
        CASE WHEN (v0.phot_j_mag-g.phot_j_mag_pred) IS NULL THEN 0 ELSE v0.phot_j_mag-g.phot_j_mag_pred END)
          ELSE v0.phot_h_mag-g.phot_h_mag_pred END) 
            ELSE v0.phot_ks_mag-g.phot_ks_mag_pred END AS mag_diff
      FROM vvv4_sources_clean AS v0 
      WHERE q3c_join(v0.ra,v0.dec,g.ra_vvv,g.dec_vvv,1./3600.)) as aux WHERE ABS(aux.mag_diff) < 1.0)
INSERT INTO link_gdr3_vvv
  (vvv_source_id,gdr3_source_id,distance)
SELECT vvv_source_id, gdr3_source_id, distance FROM neighbours WHERE ordering = 1;

CREATE INDEX IF NOT EXISTS link_gdr3_vvv_vvv_id
ON link_gdr3_vvv (vvv_source_id);
CREATE INDEX IF NOT EXISTS link_gdr3_vvv_gdr3_id
ON link_gdr3_vvv (gdr3_source_id);

-- Concatenate all

--- FIRST: create a table of all possibilities
DROP TABLE IF EXISTS link_gdr3_full CASCADE;
CREATE TABLE link_gdr3_full (
  link_id                BIGSERIAL PRIMARY KEY,
  merged_source_id       BIGINT NOT NULL,
  gdr3_source_id         BIGINT NOT NULL,
  ordering               INT,
  distance               FLOAT(10),
  gdr3_tmass_source_id   BIGINT,
  gdr3_vvv_source_id     BIGINT,
  gdr3_sirius_source_id  BIGINT,
  distance_tmass         FLOAT(10),
  distance_vvv           FLOAT(10),
  distance_sirius        FLOAT(10)
);


INSERT INTO link_gdr3_full
  (merged_source_id,gdr3_source_id,ordering,distance,gdr3_tmass_source_id,gdr3_vvv_source_id,gdr3_sirius_source_id,distance_tmass,distance_vvv,distance_sirius)
SELECT
  m.source_id AS merged_source_id,
  Case When lsirius.distance <= COALESCE(lvvv.distance,999) And lsirius.distance <= COALESCE(ltmass.distance,999) Then lsirius.gdr3_source_id
        When lvvv.distance < COALESCE(lsirius.distance,999) And lvvv.distance <= COALESCE(ltmass.distance,999) Then  lvvv.gdr3_source_id
        Else ltmass.gdr3_source_id
  End As gdr3_source_id,
  ROW_NUMBER () OVER(PARTITION BY m.source_id ORDER BY Case When lsirius.distance <= COALESCE(lvvv.distance,999) And lsirius.distance <= COALESCE(ltmass.distance,999) Then lsirius.distance
        When lvvv.distance < COALESCE(lsirius.distance,999) And lvvv.distance <= COALESCE(ltmass.distance,999) Then  lvvv.distance
        Else ltmass.distance END ASC) as ordering,
  Case When lsirius.distance <= COALESCE(lvvv.distance,999) And lsirius.distance <= COALESCE(ltmass.distance,999) Then lsirius.distance
        When lvvv.distance < COALESCE(lsirius.distance,999) And lvvv.distance <= COALESCE(ltmass.distance,999) Then  lvvv.distance
        Else ltmass.distance
  End As distance,
  ltmass.tmass_source_id AS gdr3_tmass_source_id,
  lvvv.vvv_source_id AS gdr3_vvv_source_id,
  lsirius.sirius_source_id AS gdr3_sirius_source_id,
  ltmass.distance AS distance_tmass,
  lvvv.distance AS distance_vvv,
  lsirius.distance AS distance_sirius
FROM merged_sources AS m
  LEFT JOIN link_gdr3_tmass as ltmass on m.tmass_source_id = ltmass.tmass_source_id
  LEFT JOIN link_gdr3_vvv as lvvv on m.vvv_source_id = lvvv.vvv_source_id
  LEFT JOIN link_gdr3_sirius as lsirius on m.sirius_source_id = lsirius.sirius_source_id
WHERE (ltmass.tmass_source_id IS NOT NULL) OR (lvvv.vvv_source_id IS NOT NULL) OR (lsirius.sirius_source_id IS NOT NULL);




--- SECOND: select the best merged source for each Gaia source

DROP TABLE IF EXISTS link_gdr3 CASCADE;
CREATE TABLE link_gdr3 (
  link_id                BIGSERIAL PRIMARY KEY,
  merged_source_id       BIGINT NOT NULL,
  gdr3_source_id         BIGINT NOT NULL,
  distance               FLOAT(10),
  tmass_source_id        BIGINT,
  vvv_source_id          BIGINT,
  sirius_source_id       BIGINT,
  flag                   BIT(7)
);

ALTER TABLE link_gdr3 ADD CONSTRAINT
  FK_link_gdr3_0 FOREIGN KEY (merged_source_id)
  REFERENCES merged_sources (source_id) ON DELETE CASCADE;
ALTER TABLE link_gdr3 ADD CONSTRAINT
  FK_link_gdr3_1 FOREIGN KEY (gdr3_source_id)
  REFERENCES gdr3_sources (source_id) ON DELETE CASCADE;


DROP TABLE IF EXISTS neighbours CASCADE;
CREATE TABLE neighbours AS (SELECT
aux.source_id AS merged_source_id,
g.source_id AS gdr3_source_id,
aux.distance AS distance,
aux.tmass_source_id AS tmass_source_id,
aux.vvv_source_id AS vvv_source_id,
aux.sirius_source_id AS sirius_source_id
FROM gdr3_sources AS g, LATERAL(
    SELECT m0.source_id,m0.tmass_source_id,m0.vvv_source_id,m0.sirius_source_id,
        3600.0*q3c_dist(g.ra,g.dec,m0.ra,m0.dec) AS distance,
        CASE WHEN (m0.phot_ks_mag-g.phot_ks_mag_pred) IS NOT NULL THEN m0.phot_ks_mag-g.phot_ks_mag_pred
            WHEN (m0.phot_ks_mag-g.phot_ks_mag_pred) IS NULL AND (m0.phot_h_mag-g.phot_h_mag_pred) IS NOT NULL THEN m0.phot_h_mag-g.phot_h_mag_pred
            WHEN (m0.phot_ks_mag-g.phot_ks_mag_pred) IS NULL AND (m0.phot_h_mag-g.phot_h_mag_pred) IS NULL AND (m0.phot_j_mag-g.phot_j_mag_pred) IS NOT NULL THEN m0.phot_j_mag-g.phot_j_mag_pred
            ELSE 0
        END AS mag_diff
    FROM (SELECT * FROM merged_sources WHERE position_source='T') AS m0 WHERE q3c_join(m0.ra,m0.dec,g.ra,g.dec,1./3600.)) AS aux 
    WHERE ABS(aux.mag_diff) < 1.0
UNION
SELECT
aux.source_id AS merged_source_id,
g.source_id AS gdr3_source_id,
aux.distance AS distance,
aux.tmass_source_id AS tmass_source_id,
aux.vvv_source_id AS vvv_source_id,
aux.sirius_source_id AS sirius_source_id
FROM gdr3_sources AS g, LATERAL(
    SELECT m0.source_id,m0.tmass_source_id,m0.vvv_source_id,m0.sirius_source_id,
        3600.0*q3c_dist(g.ra_vvv,g.dec_vvv,m0.ra,m0.dec) AS distance,
        CASE WHEN (m0.phot_ks_mag-g.phot_ks_mag_pred) IS NOT NULL THEN m0.phot_ks_mag-g.phot_ks_mag_pred
            WHEN (m0.phot_ks_mag-g.phot_ks_mag_pred) IS NULL AND (m0.phot_h_mag-g.phot_h_mag_pred) IS NOT NULL THEN m0.phot_h_mag-g.phot_h_mag_pred
            WHEN (m0.phot_ks_mag-g.phot_ks_mag_pred) IS NULL AND (m0.phot_h_mag-g.phot_h_mag_pred) IS NULL AND (m0.phot_j_mag-g.phot_j_mag_pred) IS NOT NULL THEN m0.phot_j_mag-g.phot_j_mag_pred
            ELSE 0
        END AS mag_diff
    FROM (SELECT * FROM merged_sources WHERE position_source='V') AS m0 WHERE q3c_join(m0.ra,m0.dec,g.ra_vvv,g.dec_vvv,1./3600.)) AS aux 
    WHERE ABS(aux.mag_diff) < 1.0
UNION
SELECT
aux.source_id AS merged_source_id,
g.source_id AS gdr3_source_id,
aux.distance AS distance,
aux.tmass_source_id AS tmass_source_id,
aux.vvv_source_id AS vvv_source_id,
aux.sirius_source_id AS sirius_source_id
FROM gdr3_sources AS g, LATERAL(
    SELECT m0.source_id,m0.tmass_source_id,m0.vvv_source_id,m0.sirius_source_id,
        3600.0*q3c_dist(g.ra_sirius,g.dec_sirius,m0.ra,m0.dec) AS distance,
        CASE WHEN (m0.phot_ks_mag-g.phot_ks_mag_pred) IS NOT NULL THEN m0.phot_ks_mag-g.phot_ks_mag_pred
            WHEN (m0.phot_ks_mag-g.phot_ks_mag_pred) IS NULL AND (m0.phot_h_mag-g.phot_h_mag_pred) IS NOT NULL THEN m0.phot_h_mag-g.phot_h_mag_pred
            WHEN (m0.phot_ks_mag-g.phot_ks_mag_pred) IS NULL AND (m0.phot_h_mag-g.phot_h_mag_pred) IS NULL AND (m0.phot_j_mag-g.phot_j_mag_pred) IS NOT NULL THEN m0.phot_j_mag-g.phot_j_mag_pred
            ELSE 0
        END AS mag_diff
    FROM (SELECT * FROM merged_sources WHERE position_source='S') AS m0 WHERE q3c_join(m0.ra,m0.dec,g.ra_sirius,g.dec_sirius,1./3600.)) AS aux 
    WHERE ABS(aux.mag_diff) < 1.0);

DROP TABLE IF EXISTS neighbours2 CASCADE;
CREATE TABLE neighbours2 AS (
    SELECT ROW_NUMBER () OVER(PARTITION BY n.gdr3_source_id ORDER BY n.distance ASC) AS ordering, n.* FROM neighbours AS n
);

DROP TABLE IF EXISTS flag_table CASCADE;
CREATE TABLE flag_table(
  gdr3_source_id   BIGINT NOT NULL,
  flag             BIT(7) NOT NULL
);

WITH aux AS(
    SELECT * FROM neighbours2 AS n WHERE ordering = 1
)
INSERT INTO flag_table 
  SELECT source_id, CAST(MIN(CAST(flag AS int)) + CAST(POWER(2,7) AS INT) AS BIT(7)) | (CAST(CAST(COUNT(*)>1 AS int) AS VARCHAR))::BIT(7) AS flag FROM
  (SELECT m.gdr3_source_id AS source_id,
  CASE WHEN m.tmass_source_id IS NULL THEN '000000'::bit(6) ELSE COALESCE(CAST(CAST(lt.gdr3_source_id != m.gdr3_source_id AS int) AS VARCHAR)::BIT(6)>>5,'001000'::bit(6)) END | 
    CASE WHEN m.vvv_source_id IS NULL THEN '000000'::bit(6) ELSE COALESCE(CAST(CAST(lv.gdr3_source_id != m.gdr3_source_id AS int) AS VARCHAR)::BIT(6)>>4,'010000'::bit(6)) END | 
    CASE WHEN m.sirius_source_id IS NULL THEN '000000'::bit(6) ELSE COALESCE(CAST(CAST(ls.gdr3_source_id != m.gdr3_source_id AS int) AS VARCHAR)::BIT(6)>>3,'100000'::bit(6)) END AS flag FROM aux AS m LEFT JOIN link_gdr3_tmass as lt ON m.tmass_source_id = lt.tmass_source_id LEFT JOIN link_gdr3_sirius AS ls ON m.sirius_source_id = ls.sirius_source_id LEFT JOIN link_gdr3_vvv AS lv ON m.vvv_source_id = lv.vvv_source_id) as g GROUP BY source_id;

INSERT INTO link_gdr3
 (merged_source_id,gdr3_source_id,distance,tmass_source_id,vvv_source_id,sirius_source_id,flag)
SELECT n.merged_source_id, n.gdr3_source_id, n.distance,n.tmass_source_id,n.vvv_source_id,n.sirius_source_id,f.flag FROM neighbours2 as n INNER JOIN flag_table as f ON n.gdr3_source_id = f.gdr3_source_id WHERE n.ordering=1;

CREATE INDEX IF NOT EXISTS link_gdr3_flag
  ON link_gdr3 (flag);
CLUSTER link_gdr3 USING link_gdr3_flag;
ANALYZE link_gdr3;

DROP TABLE neighbours2;
DROP TABLE flag_table;