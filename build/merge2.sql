DROP TABLE IF EXISTS merged_sources_dups_candidates CASCADE;

CREATE TABLE merged_sources_dups_candidates AS
SELECT conf.*,m.position_source,m.magnitude_source FROM (SELECT * FROM merged_sources_confusion_12_5 WHERE count>1) as conf LEFT JOIN merged_sources as m on m.source_id=conf.source_id;


DROP TABLE IF EXISTS merged_sources_dups_typeA CASCADE;

CREATE TABLE merged_sources_dups_typeA AS --the closest neighbour is a VVV source and the main source is bright
SELECT t1.*,
t2.source_id as source_id_neighbour,t2.position_source as position_source_neighbour,t2.ra as ra_neighbour, t2.dec as dec_neighbour 
FROM merged_sources_dups_candidates AS t1, LATERAL(
SELECT t2.source_id,t2.magnitude_source FROM merged_sources_dups_candidates AS t2 WHERE q3c_join(t1.glon,t1.glat,t2.glon,t2.glat,0.6/3600)
) as aux WHERE (aux.magnitude_source=="TV" OR aux.magnitude_source=="TVS" OR aux.magnitude_source=="VS" OR aux.magnitude_source=="V") AND 
(t1.phot_j_mag<=13 OR t1.phot_h_mag<=13 OR t1.phot_ks_mag<=13) AND (t1.magnitude_source != "V");



--DROP TABLE IF EXISTS merged_sources_clean CASCADE;
--CREATE TABLE merged_sources_clean (
--  source_id          BIGSERIAL PRIMARY KEY,
--  tmass_source_id    BIGINT,
--  sirius_source_id   BIGINT,
--  vvv_source_id      BIGINT,
--  glon               FLOAT,
--  glat               FLOAT,
--  ra                 FLOAT,
--  dec                FLOAT,
--  position_source    VARCHAR(1),
--  magnitude_source   VARCHAR(3),
--  phot_hw_mag        FLOAT,
--  phot_hw_mag_error  FLOAT,
--  phot_j_mag         FLOAT,
--  phot_j_mag_error   FLOAT,
--  phot_h_mag         FLOAT,
--  phot_h_mag_error   FLOAT,
--  phot_ks_mag        FLOAT,
--  phot_ks_mag_error  FLOAT
--);


--ALTER TABLE merged_sources ADD CONSTRAINT
--  FK_merged_tmass_id FOREIGN KEY (tmass_source_id)
--  REFERENCES tmass_sources_clean (source_id) ON DELETE CASCADE;
--ALTER TABLE merged_sources ADD CONSTRAINT
--  FK_merged_sirius_id FOREIGN KEY  (sirius_source_id)
--  REFERENCES sirius_sources_clean (source_id) ON DELETE CASCADE;
--ALTER TABLE merged_sources ADD CONSTRAINT
--  FK_merged_vvv_id FOREIGN KEY (vvv_source_id)
--  REFERENCES vvv4_sources_clean (source_id) ON DELETE CASCADE;

--WITH --select bright sources with a nearby VVV source
--SELECT * FROM merged_sources WHERE 
--INSERT INTO merged_sources_clean

--;

--WITH --select sources with a shared ID

--INSERT INTO merged_sources_clean

--;

--WITH --select remaining source_ids

--INSERT INTO merged_sources_clean

--;

--CREATE INDEX IF NOT EXISTS merged_sources_clean_tmass_source_id
--  ON merged_sources_clean (tmass_source_id);
--CREATE INDEX IF NOT EXISTS merged_sources_clean_vvv_source_id
--  ON merged_sources_clean (vvv_source_id);
--CREATE INDEX IF NOT EXISTS merged_sources_clean_sirius_source_id
--  ON merged_sources_clean (sirius_source_id);
--CREATE INDEX IF NOT EXISTS merged_sources_clean_radec
--  ON merged_sources_clean (q3c_ang2ipix(ra,dec));
--CREATE INDEX IF NOT EXISTS merged_sources_clean_glonglat
--  ON merged_sources_clean (q3c_ang2ipix(glon,glat));
--CREATE INDEX IF NOT EXISTS merged_sources_clean_hwmag
--  ON merged_sources_clean (phot_hw_mag);
--CREATE INDEX IF NOT EXISTS merged_sources_clean_jmag
--  ON merged_sources_clean (phot_j_mag);
--CREATE INDEX IF NOT EXISTS merged_sources_clean_hmag
--  ON merged_sources_clean (phot_h_mag);
--CREATE INDEX IF NOT EXISTS merged_sources_clean_ksmag
--  ON merged_sources_clean (phot_ks_mag);
--CREATE INDEX IF NOT EXISTS merged_sources_clean_ra
--  ON merged_sources_clean (ra);
--CREATE INDEX IF NOT EXISTS merged_sources_clean_dec
--  ON merged_sources_clean (dec);
--CREATE INDEX IF NOT EXISTS merged_sources_clean_glon
--  ON merged_sources_clean (glon);
--CREATE INDEX IF NOT EXISTS merged_sources_clean_glat
--  ON merged_sources_clean (glat);
--CLUSTER merged_sources_clean_glonglat ON merged_sources_clean;
--ANALYZE merged_sources_clean;

