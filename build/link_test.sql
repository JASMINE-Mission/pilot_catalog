\timing on

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

--INSERT INTO link_gdr3 (merged_source_id,gdr3_source_id)
--SELECT merged_source_id,gdr3_source_id FROM link_gdr3_full WHERE ordering=1;


WITH neighbours AS (SELECT
  aux.source_id AS merged_source_id,
  g.source_id AS gdr3_source_id,
  aux.distance AS distance,
  aux.tmass_source_id AS tmass_source_id,
  aux.vvv_source_id AS vvv_source_id,
  aux.sirius_source_id AS sirius_source_id,
  ROW_NUMBER () OVER(PARTITION BY g.source_id ORDER BY aux.distance ASC) as ordering
  FROM gdr3_sources AS g, LATERAL(
    SELECT source_id,3600.0*q3c_dist(m0.ra,m0.dec,g.ra_vvv,g.dec_vvv) as distance,tmass_source_id,vvv_source_id,sirius_source_id,
      CASE WHEN (m0.phot_ks_mag-g.phot_ks_mag_pred) IS NULL THEN 
        (CASE WHEN (m0.phot_h_mag-g.phot_h_mag_pred) IS NULL THEN (
          CASE WHEN (m0.phot_j_mag-g.phot_j_mag_pred) IS NULL THEN 0 ELSE m0.phot_j_mag-g.phot_j_mag_pred END)
            ELSE m0.phot_h_mag-g.phot_h_mag_pred END) 
              ELSE m0.phot_ks_mag-g.phot_ks_mag_pred END AS mag_diff
        FROM merged_sources AS m0 
        WHERE q3c_join(m0.ra,m0.dec,g.ra_vvv,g.dec_vvv,1./3600.)) as aux WHERE aux.mag_diff < 1.0),
  flag_table AS (
  SELECT source_id, CAST(MIN(CAST(flag AS int)) + CAST(POWER(2,7) AS INT) AS BIT(7)) | (CAST(CAST(COUNT(*)>1 AS int) AS VARCHAR))::BIT(7) AS flag FROM
  (SELECT m.gdr3_source_id AS source_id,COALESCE(CAST(CAST(lt.gdr3_source_id != m.gdr3_source_id AS int) AS VARCHAR)::BIT(6)>>5,'001000'::bit(6)) | COALESCE(CAST(CAST(lv.gdr3_source_id != m.gdr3_source_id AS int) AS VARCHAR)::BIT(6)>>4,'001000'::bit(6)) | COALESCE(CAST(CAST(ls.gdr3_source_id != m.gdr3_source_id AS int) AS VARCHAR)::BIT(6)>>3,'001000'::bit(6)) AS flag FROM neighbours as m LEFT JOIN link_gdr3_tmass as lt ON m.tmass_source_id = lt.tmass_source_id LEFT JOIN link_gdr3_sirius AS ls ON m.sirius_source_id = ls.sirius_source_id LEFT JOIN link_gdr3_vvv AS lv ON m.vvv_source_id = lv.vvv_source_id WHERE m.sirius_source_id IS NOT NULL OR m.tmass_source_id IS NOT NULL OR m.vvv_source_id IS NOT NULL) as g GROUP BY source_id
  )
INSERT INTO link_gdr3
  (merged_source_id,gdr3_source_id,distance,tmass_source_id,vvv_source_id,sirius_source_id)
SELECT n.merged_source_id, n.gdr3_source_id, n.distance,n.tmass_source_id,n.vvv_source_id,n.sirius_source_id,f.flag FROM neighbours AS n LEFT JOIN flag_table as f ON f.source_id = n.gdr3_source_id WHERE ordering = 1;

