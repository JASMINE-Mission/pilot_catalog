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
  phot_ks_mag_error  FLOAT,
  parallax           FLOAT,
  parallax_error     FLOAT,
  pmra               FLOAT,
  pmra_error         FLOAT,
  pmdec              FLOAT,
  pmdec_error        FLOAT,
  uwe                FLOAT,
  ref_epoch          INTEGER,
  vvv_source         VARCHAR(3),
  duplicate_flag     INTEGER,
  num_neighbours     INTEGER
);



INSERT INTO merged_sources
SELECT m.*,0 as duplicate_flag, 0 as num_neighbours FROM merged_sources_raw AS m LEFT JOIN merged_sources_confusion_025_5 AS conf ON m.source_id = conf.source_id WHERE conf.source_id IS NULL 
UNION 
SELECT m.*,conf.dups as duplicate_flag, conf.num_neighbours as num_neighbours FROM merged_sources_raw AS m LEFT JOIN merged_sources_confusion_025_5 AS conf ON m.source_id = conf.source_id WHERE conf.select_neighbour = 0;


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



--create clean version of merged_sources (purer but less complete)
--DROP TABLE IF EXISTS merged_sources_clean CASCADE;
--CREATE TABLE merged_sources_clean (
--   source_id          BIGSERIAL PRIMARY KEY,
--   tmass_source_id    BIGINT,
--   sirius_source_id   BIGINT,
--   vvv_source_id      BIGINT,
--   glon               FLOAT,
--   glat               FLOAT,
--   ra                 FLOAT,
--   dec                FLOAT,
--   position_source    VARCHAR(1),
--   magnitude_source   VARCHAR(3),
--   phot_hw_mag        FLOAT, 
--   phot_hw_mag_error  FLOAT,
--   phot_j_mag         FLOAT,
--   phot_j_mag_error   FLOAT,
--   phot_h_mag         FLOAT,
--   phot_h_mag_error   FLOAT,
--   phot_ks_mag        FLOAT,
--   phot_ks_mag_error  FLOAT,
--   parallax           FLOAT,
--   parallax_error     FLOAT,
--   pmra               FLOAT,
--   pmra_error         FLOAT,
--   pmdec              FLOAT,
--   pmdec_error        FLOAT,
--   uwe                FLOAT,
--   ref_epoch          INTEGER,
--   vvv_source         VARCHAR(3),
--   duplicate_flag     INTEGER,
--   num_neighbours     INTEGER
-- );

-- INSERT INTO merged_sources_clean
-- SELECT m.* FROM merged_sources ;

-- CREATE INDEX IF NOT EXISTS merged_sources_clean_tmass_source_id
--   ON merged_sources_clean (tmass_source_id);
-- CREATE INDEX IF NOT EXISTS merged_sources_clean_vvv_source_id
--   ON merged_sources_clean (vvv_source_id);
-- CREATE INDEX IF NOT EXISTS merged_sources_clean_sirius_source_id
--   ON merged_sources_clean (sirius_source_id);
-- CREATE INDEX IF NOT EXISTS merged_sources_clean_radec
--   ON merged_sources_clean (q3c_ang2ipix(ra,dec));
-- CREATE INDEX IF NOT EXISTS merged_sources_clean_glonglat
--   ON merged_sources_clean (q3c_ang2ipix(glon,glat));
-- CREATE INDEX IF NOT EXISTS merged_sources_clean_hwmag
--   ON merged_sources_clean (phot_hw_mag);
-- CREATE INDEX IF NOT EXISTS merged_sources_clean_jmag
--   ON merged_sources_clean (phot_j_mag);
-- CREATE INDEX IF NOT EXISTS merged_sources_clean_hmag
--   ON merged_sources_clean (phot_h_mag);
-- CREATE INDEX IF NOT EXISTS merged_sources_clean_ksmag
--   ON merged_sources_clean (phot_ks_mag);
-- CREATE INDEX IF NOT EXISTS merged_sources_clean_ra
--   ON merged_sources_clean (ra);
-- CREATE INDEX IF NOT EXISTS merged_sources_clean_dec
--   ON merged_sources_clean (dec);
-- CREATE INDEX IF NOT EXISTS merged_sources_clean_glon
--   ON merged_sources_clean (glon);
-- CREATE INDEX IF NOT EXISTS merged_sources_clean_glat
--   ON merged_sources_clean (glat);
-- CLUSTER merged_sources_clean_glonglat ON merged_sources_clean;
-- ANALYZE merged_sources_clean;