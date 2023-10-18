\timing on

--\echo STARTING
--DROP TABLE IF EXISTS link_gdr3 CASCADE;
--CREATE TABLE link_gdr3 (
--  link_id                BIGSERIAL PRIMARY KEY,
--  merged_source_id       BIGINT NOT NULL,
--  gdr3_source_id         BIGINT NOT NULL,
--  distance               FLOAT(10),
--  tmass_source_id        BIGINT,
--  vvv_source_id          BIGINT,
--  sirius_source_id       BIGINT,
--  flag                   BIT(7)
--);

--\echo link_gdr3 reseted 
--ALTER TABLE link_gdr3 ADD CONSTRAINT
--  FK_link_gdr3_0 FOREIGN KEY (merged_source_id)
--  REFERENCES merged_sources (source_id) ON DELETE CASCADE;
--ALTER TABLE link_gdr3 ADD CONSTRAINT
--  FK_link_gdr3_1 FOREIGN KEY (gdr3_source_id)
--  REFERENCES gdr3_sources (source_id) ON DELETE CASCADE;

--INSERT INTO link_gdr3 (merged_source_id,gdr3_source_id)
--SELECT merged_source_id,gdr3_source_id FROM link_gdr3_full WHERE ordering=1;

\echo creating neighbours
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

DROP TABLE IF EXISTS flag_table CASCADE;
CREATE TABLE flag_table AS (
  SELECT ROW_NUMBER () OVER(PARTITION BY m.gdr3_source_id ORDER BY m.distance ASC) as ordering, source_id, CAST(MIN(CAST(flag AS int)) + CAST(POWER(2,7) AS INT) AS BIT(7)) | (CAST(CAST(COUNT(*)>1 AS int) AS VARCHAR))::BIT(7) AS flag FROM
  (SELECT m.gdr3_source_id AS source_id,
  CASE WHEN m.tmass_source_id IS NULL THEN '000000'::bit(6) ELSE COALESCE(CAST(CAST(lt.gdr3_source_id != m.gdr3_source_id AS int) AS VARCHAR)::BIT(6)>>5,'001000'::bit(6)) END | 
    CASE WHEN m.vvv_source_id IS NULL THEN '000000'::bit(6) ELSE COALESCE(CAST(CAST(lv.gdr3_source_id != m.gdr3_source_id AS int) AS VARCHAR)::BIT(6)>>4,'010000'::bit(6)) END | 
    CASE WHEN m.sirius_source_id IS NULL THEN '000000'::bit(6) ELSE COALESCE(CAST(CAST(ls.gdr3_source_id != m.gdr3_source_id AS int) AS VARCHAR)::BIT(6)>>3,'100000'::bit(6)) END AS flag FROM neighbours as m LEFT JOIN link_gdr3_tmass as lt ON m.tmass_source_id = lt.tmass_source_id LEFT JOIN link_gdr3_sirius AS ls ON m.sirius_source_id = ls.sirius_source_id LEFT JOIN link_gdr3_vvv AS lv ON m.vvv_source_id = lv.vvv_source_id) as g GROUP BY source_id);

--INSERT INTO link_gdr3
 -- (merged_source_id,gdr3_source_id,distance,tmass_source_id,vvv_source_id,sirius_source_id,flag)
--SELECT n.merged_source_id, n.gdr3_source_id, n.distance,n.tmass_source_id,n.vvv_source_id,n.sirius_source_id,f.flag FROM neighbours AS n INNER JOIN flag_table as f ON f.source_id = n.gdr3_source_id WHERE f.ordering=1;

