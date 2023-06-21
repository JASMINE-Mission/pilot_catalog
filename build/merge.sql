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
  source             VARCHAR(3),
  phot_hw_mag        FLOAT,
  phot_hw_mag_error  FLOAT,
  phot_j_mag         FLOAT,
  phot_j_mag_error   FLOAT,
  phot_h_mag         FLOAT,
  phot_h_mag_error   FLOAT,
  phot_ks_mag        FLOAT,
  phot_ks_mag_error  FLOAT
);


ALTER TABLE merged_sources_clean ADD CONSTRAINT
  FK_merged_tmass_id FOREIGN KEY (tmass_source_id)
  REFERENCES tmass_sources_clean (source_id) ON DELETE CASCADE;
ALTER TABLE merged_sources_clean ADD CONSTRAINT
  FK_merged_sirius_id FOREIGN KEY  (sirius_source_id)
  REFERENCES sirius_sources_clean (source_id) ON DELETE CASCADE;
ALTER TABLE merged_sources_clean ADD CONSTRAINT
  FK_merged_vvv_id FOREIGN KEY (vvv_source_id)
  REFERENCES vvv_sources_clean (source_id) ON DELETE CASCADE;


INSERT INTO merged_sources_clean
SELECT  --tmass unique sources
  nextval('merged_sources_clean_source_id_seq') AS source_id,
  t.source_id AS tmass_source_id,
  CAST(NULL AS BIGINT) AS sirius_source_id,
  CAST(NULL AS BIGINT) AS vvv_source_id, 
  compute_glon( ra, dec) as glon,
  compute_glat( ra, dec) as glat,  
  ra,  
  dec,
  CAST('T' AS VARCHAR) AS source,
  compute_hw( phot_j_mag, phot_h_mag) AS phot_hw_mag,
  compute_hw_error( phot_j_mag, phot_j_mag_error, phot_h_mag, phot_h_mag_error) AS phot_hw_mag_error, 
  phot_j_mag, 
  phot_j_mag_error, 
  phot_h_mag, 
  phot_h_mag_error, 
  phot_ks_mag, 
  phot_ks_mag_error 
  FROM tmass_sources_clean as t WHERE  t.source_id NOT IN (SELECT tmass_source_id FROM tmass_sirius_xmatch) AND  t.source_id NOT IN (SELECT tmass_source_id FROM tmass_vvv_xmatch)
UNION
SELECT  --vvv unique sources  
  nextval('merged_sources_clean_source_id_seq') AS source_id,
  CAST(NULL AS BIGINT) AS tmass_source_id,
  CAST(NULL AS BIGINT) AS sirius_source_id,
  v.source_id AS vvv_source_id, 
  compute_glon( ra, dec) as glon,
  compute_glat( ra, dec) as glat,  
  ra,  
  dec,
  CAST('V' AS VARCHAR) AS source,
  compute_hw( phot_j_mag, phot_h_mag) AS phot_hw_mag,
  compute_hw_error( phot_j_mag, phot_j_mag_error, phot_h_mag, phot_h_mag_error) AS phot_hw_mag_error, 
  phot_j_mag, 
  phot_j_mag_error, 
  phot_h_mag, 
  phot_h_mag_error, 
  phot_ks_mag, 
  phot_ks_mag_error 
  FROM vvv_sources_clean as v WHERE  v.source_id NOT IN (SELECT vvv_source_id FROM vvv_sirius_xmatch) AND  v.source_id NOT IN (SELECT vvv_source_id FROM tmass_vvv_xmatch)
UNION
SELECT  --sirius unique sources  
  nextval('merged_sources_clean_source_id_seq') AS source_id,
  CAST(NULL AS BIGINT) AS tmass_source_id,
  s.source_id AS sirius_source_id,
  CAST(NULL AS BIGINT) AS vvv_source_id, 
  compute_glon( ra, dec) as glon,
  compute_glat( ra, dec) as glat,  
  ra,  
  dec,
  CAST('S' AS VARCHAR) AS source,
  compute_hw( phot_j_mag, phot_h_mag) AS phot_hw_mag,
  compute_hw_error( phot_j_mag, phot_j_mag_error, phot_h_mag, phot_h_mag_error) AS phot_hw_mag_error, 
  phot_j_mag, 
  phot_j_mag_error, 
  phot_h_mag, 
  phot_h_mag_error, 
  phot_ks_mag, 
  phot_ks_mag_error 
  FROM sirius_sources_clean as s WHERE  s.source_id NOT IN (SELECT sirius_source_id FROM vvv_sirius_xmatch) AND  s.source_id NOT IN (SELECT sirius_source_id FROM tmass_sirius_xmatch)
UNION
SELECT  --sirius unique sources  
  nextval('merged_sources_clean_source_id_seq') AS source_id,
  ts.tmass_source_id AS tmass_source_id,
  ts.sirius_source_id AS sirius_source_id,
  CAST(NULL AS BIGINT) AS vvv_source_id, 
  compute_glon( ra, dec) as glon,
  compute_glat( ra, dec) as glat,  
  ra,  
  dec,
  CAST('TS' AS VARCHAR) AS source,
  compute_hw( phot_j_mag, phot_h_mag) AS phot_hw_mag,
  compute_hw_error( phot_j_mag, phot_j_mag_error, phot_h_mag, phot_h_mag_error) AS phot_hw_mag_error, 
  phot_j_mag, 
  phot_j_mag_error, 
  phot_h_mag, 
  phot_h_mag_error, 
  phot_ks_mag, 
  phot_ks_mag_error 
  FROM tmass_sirius_xmatch as ts WHERE  ts.sirius_source_id NOT IN (SELECT sirius_source_id FROM tmass_vvv_sirius_xmatch)
UNION
SELECT  --sirius unique sources  
  nextval('merged_sources_clean_source_id_seq') AS source_id,
  tv.tmass_source_id AS tmass_source_id,
  CAST(NULL AS BIGINT) AS sirius_source_id,
  tv.vvv_source_id AS vvv_source_id, 
  compute_glon( ra, dec) as glon,
  compute_glat( ra, dec) as glat,  
  ra,  
  dec,
  CAST('TV' AS VARCHAR) AS source,
  compute_hw( phot_j_mag, phot_h_mag) AS phot_hw_mag,
  compute_hw_error( phot_j_mag, phot_j_mag_error, phot_h_mag, phot_h_mag_error) AS phot_hw_mag_error, 
  phot_j_mag, 
  phot_j_mag_error, 
  phot_h_mag, 
  phot_h_mag_error, 
  phot_ks_mag, 
  phot_ks_mag_error 
  FROM tmass_vvv_xmatch as tv WHERE  tv.vvv_source_id NOT IN (SELECT vvv_source_id FROM tmass_vvv_sirius_xmatch)
UNION
SELECT  --sirius unique sources  
  nextval('merged_sources_clean_source_id_seq') AS source_id,
  CAST(NULL AS BIGINT) AS tmass_source_id,
  vs.sirius_source_id AS sirius_source_id,
  vs.vvv_source_id AS vvv_source_id, 
  compute_glon( ra, dec) as glon,
  compute_glat( ra, dec) as glat,  
  ra,  
  dec,
  CAST('VS' AS VARCHAR) AS source,
  compute_hw( phot_j_mag, phot_h_mag) AS phot_hw_mag,
  compute_hw_error( phot_j_mag, phot_j_mag_error, phot_h_mag, phot_h_mag_error) AS phot_hw_mag_error, 
  phot_j_mag, 
  phot_j_mag_error, 
  phot_h_mag, 
  phot_h_mag_error, 
  phot_ks_mag, 
  phot_ks_mag_error 
  FROM vvv_sirius_xmatch as vs WHERE  vs.sirius_source_id NOT IN (SELECT sirius_source_id FROM tmass_vvv_sirius_xmatch)
UNION
SELECT  --sirius unique sources  
  nextval('merged_sources_clean_source_id_seq') AS source_id,
  tvs.tmass_source_id AS tmass_source_id,
  tvs.sirius_source_id AS sirius_source_id,
  tvs.vvv_source_id AS vvv_source_id, 
  compute_glon( ra, dec) as glon,
  compute_glat( ra, dec) as glat,  
  ra,  
  dec,
  CAST('TVS' AS VARCHAR) AS source,
  compute_hw( phot_j_mag, phot_h_mag) AS phot_hw_mag,
  compute_hw_error( phot_j_mag, phot_j_mag_error, phot_h_mag, phot_h_mag_error) AS phot_hw_mag_error, 
  phot_j_mag, 
  phot_j_mag_error, 
  phot_h_mag, 
  phot_h_mag_error, 
  phot_ks_mag, 
  phot_ks_mag_error 
  FROM tmass_vvv_sirius_xmatch as tvs;



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
