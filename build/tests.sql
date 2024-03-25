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


DROP TABLE IF EXISTS merged_sources_aux_t CASCADE;
CREATE TABLE merged_sources_aux_t AS
SELECT m.* FROM merged_sources_raw as m LEFT OUTER JOIN merged_sources_dups_tmass as t ON m.tmass_source_id=t.tmass_source_id WHERE t.source_id IS NULL;

CREATE INDEX IF NOT EXISTS merged_sources_aux_t_source_id
  ON merged_sources_aux_t (source_id);
CREATE INDEX IF NOT EXISTS merged_sources_aux_t_vvv_source_id
  ON merged_sources_aux_t (vvv_source_id);
CREATE INDEX IF NOT EXISTS merged_sources_aux_t_sirius_source_id
  ON merged_sources_aux_t (sirius_source_id);
CLUSTER merged_sources_aux_t_sirius_source_id ON merged_sources_aux_t;
ANALYZE merged_sources_aux_t;

DROP TABLE IF EXISTS merged_sources_aux_ts CASCADE;
CREATE TABLE merged_sources_aux_ts AS
SELECT m.* FROM merged_sources_aux_t as m LEFT OUTER JOIN merged_sources_dups_sirius as s ON m.sirius_source_id=s.sirius_source_id WHERE s.source_id IS NULL;

CREATE INDEX IF NOT EXISTS merged_sources_aux_ts_source_id
  ON merged_sources_aux_ts (source_id);
CREATE INDEX IF NOT EXISTS merged_sources_aux_ts_vvv_source_id
  ON merged_sources_aux_ts (vvv_source_id);
CLUSTER merged_sources_aux_ts_vvv_source_id ON merged_sources_aux_ts;
ANALYZE merged_sources_aux_ts;

DROP TABLE IF EXISTS merged_sources_aux_tsv CASCADE;
CREATE TABLE merged_sources_aux_tsv AS
SELECT m.* FROM merged_sources_aux_ts as m LEFT OUTER JOIN merged_sources_dups_vvv as v ON m.vvv_source_id=v.vvv_source_id WHERE v.source_id IS NULL;

CREATE INDEX IF NOT EXISTS merged_sources_aux_tsv_source_id
  ON merged_sources_aux_tsv (source_id);
CLUSTER merged_sources_aux_tsv_vvv_source_id ON merged_sources_aux_tsv;
ANALYZE merged_sources_aux_tsv;


INSERT INTO merged_sources
SELECT * FROM merged_sources_aux_tsv
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