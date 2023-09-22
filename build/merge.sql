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


ALTER TABLE merged_sources ADD CONSTRAINT
  FK_merged_tmass_id FOREIGN KEY (tmass_source_id)
  REFERENCES tmass_sources_clean (source_id) ON DELETE CASCADE;
ALTER TABLE merged_sources ADD CONSTRAINT
  FK_merged_sirius_id FOREIGN KEY  (sirius_source_id)
  REFERENCES sirius_sources_clean (source_id) ON DELETE CASCADE;
ALTER TABLE merged_sources ADD CONSTRAINT
  FK_merged_vvv_id FOREIGN KEY (vvv_source_id)
  REFERENCES vvv4_sources_clean (source_id) ON DELETE CASCADE;


INSERT INTO merged_sources
SELECT  --tmass unique sources
  nextval('merged_sources_source_id_seq') AS source_id,
  t.source_id AS tmass_source_id,
  CAST(NULL AS BIGINT) AS sirius_source_id,
  CAST(NULL AS BIGINT) AS vvv_source_id, 
  compute_glon( ra, dec) as glon,
  compute_glat( ra, dec) as glat,  
  ra,  
  dec,
  CAST('T' AS VARCHAR) AS position_source,
  CAST('T' AS VARCHAR) AS magnitude_source,
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
  nextval('merged_sources_source_id_seq') AS source_id,
  CAST(NULL AS BIGINT) AS tmass_source_id,
  CAST(NULL AS BIGINT) AS sirius_source_id,
  v.source_id AS vvv_source_id, 
  compute_glon( ra, dec) as glon,
  compute_glat( ra, dec) as glat,  
  ra,  
  dec,
  CAST('V' AS VARCHAR) AS position_source,
  CAST('V' AS VARCHAR) AS magnitude_source,
  compute_hw( phot_j_mag, phot_h_mag) AS phot_hw_mag,
  compute_hw_error( phot_j_mag, phot_j_mag_error, phot_h_mag, phot_h_mag_error) AS phot_hw_mag_error, 
  phot_j_mag, 
  phot_j_mag_error, 
  phot_h_mag, 
  phot_h_mag_error, 
  phot_ks_mag, 
  phot_ks_mag_error 
  FROM vvv4_sources_clean as v WHERE  v.source_id NOT IN (SELECT vvv_source_id FROM vvv_sirius_xmatch) AND  v.source_id NOT IN (SELECT vvv_source_id FROM tmass_vvv_xmatch)
UNION
SELECT  --sirius unique sources  
  nextval('merged_sources_source_id_seq') AS source_id,
  CAST(NULL AS BIGINT) AS tmass_source_id,
  s.source_id AS sirius_source_id,
  CAST(NULL AS BIGINT) AS vvv_source_id, 
  compute_glon( ra, dec) as glon,
  compute_glat( ra, dec) as glat,  
  ra,  
  dec,
  CAST('S' AS VARCHAR) AS position_source,
  CAST('S' AS VARCHAR) AS magnitude_source,
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
SELECT  --2MASSxSIRIUS
  nextval('merged_sources_source_id_seq') AS source_id,
  ts.tmass_source_id AS tmass_source_id,
  ts.sirius_source_id AS sirius_source_id,
  CAST(NULL AS BIGINT) AS vvv_source_id, 
  compute_glon( ra, dec) as glon,
  compute_glat( ra, dec) as glat,  
  ra,  
  dec,
  ts.position_source AS position_source,
  CAST('TS' AS VARCHAR) AS magnitude_source,
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
SELECT  --2MASSxVVV
  nextval('merged_sources_source_id_seq') AS source_id,
  tv.tmass_source_id AS tmass_source_id,
  CAST(NULL AS BIGINT) AS sirius_source_id,
  tv.vvv_source_id AS vvv_source_id, 
  compute_glon( ra, dec) as glon,
  compute_glat( ra, dec) as glat,  
  ra,  
  dec,
  tv.position_source AS position_source,
  CAST('TV' AS VARCHAR) AS magnitude_source,
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
SELECT  --VVVxSIRIUS  
  nextval('merged_sources_source_id_seq') AS source_id,
  CAST(NULL AS BIGINT) AS tmass_source_id,
  vs.sirius_source_id AS sirius_source_id,
  vs.vvv_source_id AS vvv_source_id, 
  compute_glon( ra, dec) as glon,
  compute_glat( ra, dec) as glat,  
  ra,  
  dec,
  vs.position_source AS position_source,
  CAST('VS' AS VARCHAR) AS magnitude_source,
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
SELECT  --2MASSxVVVxSIRIUS  
  nextval('merged_sources_source_id_seq') AS source_id,
  tvs.tmass_source_id AS tmass_source_id,
  tvs.sirius_source_id AS sirius_source_id,
  tvs.vvv_source_id AS vvv_source_id, 
  compute_glon( ra, dec) as glon,
  compute_glat( ra, dec) as glat,  
  ra,  
  dec,
  tvs.position_source AS position_source,
  CAST('TVS' AS VARCHAR) AS magnitude_source,
  compute_hw( phot_j_mag, phot_h_mag) AS phot_hw_mag,
  compute_hw_error( phot_j_mag, phot_j_mag_error, phot_h_mag, phot_h_mag_error) AS phot_hw_mag_error, 
  phot_j_mag, 
  phot_j_mag_error, 
  phot_h_mag, 
  phot_h_mag_error, 
  phot_ks_mag, 
  phot_ks_mag_error 
  FROM tmass_vvv_sirius_xmatch as tvs;


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


--DROP TABLE IF EXISTS tmass_vvv_sirius_xmatch CASCADE;
--DROP TABLE IF EXISTS tmass_sirius_xmatch CASCADE;
--DROP TABLE IF EXISTS tmass_vvv_xmatch CASCADE;
--DROP TABLE IF EXISTS vvv_sirius_xmatch CASCADE;
