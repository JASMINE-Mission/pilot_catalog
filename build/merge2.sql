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

-- DROP TABLE IF EXISTS merged_sources_dups_typeB CASCADE;

-- CREATE TABLE merged_sources_dups_typeB AS --two merged sources sharing the same source from any catalogue
-- SELECT select_better(t1.source_id,t1.phot_error,t2.source_id,t2.phot_error) as source_id,
-- select_better(t1.count,t1.phot_error,t2.count,t2.phot_error) as count,
-- select_better(t1.glon,t1.phot_error,t2.glon,t2.phot_error) as glon,
-- select_better(t1.glat,t1.phot_error,t2.glat,t2.phot_error) as glat,
-- select_better(t1.phot_j_mag,t1.phot_error,t2.phot_j_mag,t2.phot_error) as phot_j_mag,
-- select_better(t1.phot_h_mag,t1.phot_error,t2.phot_h_mag,t2.phot_error) as phot_h_mag,
-- select_better(t1.phot_ks_mag,t1.phot_error,t2.phot_ks_mag,t2.phot_error) as phot_ks_mag,
-- select_better(t1.phot_hw_mag,t1.phot_error,t2.phot_hw_mag,t2.phot_error) as phot_hw_mag,
-- select_better(t1.phot_error,t1.phot_error,t2.phot_error,t2.phot_error) as phot_error,
-- select_better(t1.position_source,t1.phot_error,t2.position_source,t2.phot_error) as position_source,
-- select_better(t1.magnitude_source,t1.phot_error,t2.magnitude_source,t2.phot_error) as magnitude_source,
-- select_worst(t1.source_id,t1.phot_error,t2.source_id,t2.phot_error) as source_id_neighbour,
-- select_worst(t1.position_source,t1.phot_error,t2.position_source,t2.phot_error) as position_source_neighbour,
-- select_worst(t1.glon,t1.phot_error,t2.glon,t2.phot_error) as glon_neighbour,
-- select_worst(t1.glat,t1.phot_error,t2.glat,t2.phot_error) as glat_neighbour,
-- CASE WHEN t1.source_id<t2.source_id THEN CONCAT(CAST(t1.source_id AS varchar),'-',CAST(t2.source_id AS varchar)) -- ELSE CONCAT(CAST(t2.source_id AS varchar),'-',CAST(t1.source_id AS varchar)) END as pair_id 
-- FROM merged_sources_dups_candidates AS t1, INNER JOIN
-- SELECT t2.* FROM merged_sources_dups_candidates AS t2 WHERE (t1.tmass_source_id = t2.tmass_source_id OR t1.-- vvv_source_id=t2.vvv_source_id OR t1.sirius_source_id = t2.sirius_source_id) AND (t1.source_id != t2.source_id)
-- ;



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

