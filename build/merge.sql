CREATE TEMP VIEW tmass_hw AS
  SELECT
    *,
    0.7829*phot_j_mag + 0.2171*phot_h_mag
    - 0.0323*(phot_j_mag-phot_h_mag)^2
    AS phot_hw_mag,
    sqrt(0.035^2
     + (0.7829*phot_j_mag_error)^2
     + (0.2171*phot_h_mag_error)^2
     + (0.0323*2*(phot_j_mag-phot_h_mag)*phot_j_mag_error)^2
     + (0.0323*2*(phot_j_mag-phot_h_mag)*phot_h_mag_error)^2)
    AS phot_hw_mag_error
  FROM
    tmass_sources;

CREATE TEMP VIEW sirius_hw AS
  SELECT
    *,
    0.7796*phot_j_mag + 0.2204*phot_h_mag
    - 0.0326*(phot_j_mag-phot_h_mag)^2
    AS phot_hw_mag,
    sqrt(0.063^2
     + (0.7796*phot_j_mag_error)^2
     + (0.2204*phot_h_mag_error)^2
     + (0.0326*2*(phot_j_mag-phot_h_mag)*phot_j_mag_error)^2
     + (0.0326*2*(phot_j_mag-phot_h_mag)*phot_h_mag_error)^2)
    AS phot_hw_mag_error
  FROM
    sirius_sources;

CREATE TEMP TABLE vvv_hw AS
  SELECT
    *,
    0.7988*phot_j_mag + 0.2012*phot_h_mag
    - 0.0315*(phot_j_mag-phot_h_mag)^2
    AS phot_hw_mag,
    sqrt(0.033^2
     + (0.7988*phot_j_mag_error)^2
     + (0.2012*phot_h_mag_error)^2
     + (0.0315*2*(phot_j_mag-phot_h_mag)*phot_j_mag_error)^2
     + (0.0315*2*(phot_j_mag-phot_h_mag)*phot_h_mag_error)^2)
    AS phot_hw_mag_error
  FROM
    vvv_sources
  WHERE
    phot_j_flag = 0 AND phot_h_flag = 0;

CREATE INDEX IF NOT EXISTS temp_vvv_hw_glonglat
  ON vvv_hw (q3c_ang2ipix(glon,glat));
CLUSTER temp_vvv_hw_glonglat ON vvv_hw;
ANALYZE vvv_hw;


CREATE TEMP TABLE temp_merged_sources (
  source_id          BIGSERIAL PRIMARY KEY,
  tmass_source_id    BIGINT,
  sirius_source_id   BIGINT,
  glon               FLOAT,
  glat               FLOAT,
  ra                 FLOAT,
  dec                FLOAT,
  position_source    VARCHAR(1),
  phot_hw_mag        FLOAT,
  phot_hw_mag_error  FLOAT,
  phot_hw_mag_source VARCHAR(1),
  phot_j_mag         FLOAT,
  phot_j_mag_error   FLOAT,
  phot_j_mag_source  VARCHAR(1),
  phot_h_mag         FLOAT,
  phot_h_mag_error   FLOAT,
  phot_h_mag_source  VARCHAR(1),
  phot_ks_mag        FLOAT,
  phot_ks_mag_error  FLOAT,
  phot_ks_mag_source VARCHAR(1)
);

INSERT INTO temp_merged_sources
SELECT
  nextval('temp_merged_sources_source_id_seq') AS source_id,
  t.source_id AS tmass_source_id,
  s.source_id AS sirius_source_id,
  wrap(COALESCE(s.glon,t.glon)) AS glon,
  COALESCE(s.glat,t.glat) AS glat,
  COALESCE(s.ra,t.ra) AS ra,
  COALESCE(s.dec,t.dec) AS dec,
  ifthenelse(s.source_id,'S','2') AS position_source,
  select_better(
    s.phot_hw_mag,s.phot_hw_mag_error,
    t.phot_hw_mag,t.phot_hw_mag_error) AS phot_hw_mag,
  select_better(
    s.phot_hw_mag_error,s.phot_hw_mag_error,
    t.phot_hw_mag_error,t.phot_hw_mag_error) AS phot_hw_mag_error,
  select_char(
    s.phot_hw_mag_error,t.phot_hw_mag_error,'S','2') AS phot_hw_mag_source,
  select_better(
    s.phot_j_mag,s.phot_j_mag_error,
    t.phot_j_mag,t.phot_j_mag_error) AS phot_j_mag,
  select_better(
    s.phot_j_mag_error,s.phot_j_mag_error,
    t.phot_j_mag_error,t.phot_j_mag_error) AS phot_j_mag_error,
  select_char(
    s.phot_j_mag_error,t.phot_j_mag_error,'S','2') AS phot_j_mag_source,
  select_better(
    s.phot_h_mag,s.phot_h_mag_error,
    t.phot_h_mag,t.phot_h_mag_error) AS phot_h_mag,
  select_better(
    s.phot_h_mag_error,s.phot_h_mag_error,
    t.phot_h_mag_error,t.phot_h_mag_error) AS phot_h_mag_error,
  select_char(
    s.phot_h_mag_error,t.phot_h_mag_error,'S','2') AS phot_h_mag_source,
  select_better(
    s.phot_ks_mag,s.phot_ks_mag_error,
    t.phot_ks_mag,t.phot_ks_mag_error) AS phot_ks_mag,
  select_better(
    s.phot_ks_mag_error,s.phot_ks_mag_error,
    t.phot_ks_mag_error,t.phot_ks_mag_error) AS phot_ks_mag_error,
  select_char(
    s.phot_ks_mag_error,t.phot_ks_mag_error,'S','2') AS phot_ks_mag_source
FROM
  tmass_hw AS t
LEFT JOIN
  sirius_hw AS s
ON
  q3c_join(t.glon,t.glat,s.glon,s.glat,1./3600.)
  AND jhk_match(
    t.phot_j_mag,s.phot_j_mag,t.phot_h_mag,s.phot_h_mag,
    t.phot_ks_mag,s.phot_ks_mag,2.0::FLOAT)
UNION
SELECT
  nextval('temp_merged_sources_source_id_seq') AS source_id,
  t.source_id AS tmass_source_id,
  s.source_id AS sirius_source_id,
  wrap(COALESCE(s.glon,t.glon)) AS glon,
  COALESCE(s.glat,t.glat) AS glat,
  COALESCE(s.ra,t.ra) AS ra,
  COALESCE(s.dec,t.dec) AS dec,
  ifthenelse(s.source_id,'S','2') AS position_source,
  select_better(
    s.phot_hw_mag,s.phot_hw_mag_error,
    t.phot_hw_mag,t.phot_hw_mag_error) AS phot_hw_mag,
  select_better(
    s.phot_hw_mag_error,s.phot_hw_mag_error,
    t.phot_hw_mag_error,t.phot_hw_mag_error) AS phot_hw_mag_error,
  select_char(
    s.phot_hw_mag_error,t.phot_hw_mag_error,'S','2') AS phot_hw_mag_source,
  select_better(
    s.phot_j_mag,s.phot_j_mag_error,
    t.phot_j_mag,t.phot_j_mag_error) AS phot_j_mag,
  select_better(
    s.phot_j_mag_error,s.phot_j_mag_error,
    t.phot_j_mag_error,t.phot_j_mag_error) AS phot_j_mag_error,
  select_char(
    s.phot_j_mag_error,t.phot_j_mag_error,'S','2') AS phot_j_mag_source,
  select_better(
    s.phot_h_mag,s.phot_h_mag_error,
    t.phot_h_mag,t.phot_h_mag_error) AS phot_h_mag,
  select_better(
    s.phot_h_mag_error,s.phot_h_mag_error,
    t.phot_h_mag_error,t.phot_h_mag_error) AS phot_h_mag_error,
  select_char(
    s.phot_h_mag_error,t.phot_h_mag_error,'S','2') AS phot_h_mag_source,
  select_better(
    s.phot_ks_mag,s.phot_ks_mag_error,
    t.phot_ks_mag,t.phot_ks_mag_error) AS phot_ks_mag,
  select_better(
    s.phot_ks_mag_error,s.phot_ks_mag_error,
    t.phot_ks_mag_error,t.phot_ks_mag_error) AS phot_ks_mag_error,
  select_char(
    s.phot_ks_mag_error,t.phot_ks_mag_error,'S','2') AS phot_ks_mag_source
FROM
  sirius_hw AS s
LEFT JOIN
  tmass_hw AS t
ON
  q3c_join(s.glon,s.glat,t.glon,t.glat,1./3600.)
  AND jhk_match(
    t.phot_j_mag,s.phot_j_mag,t.phot_h_mag,s.phot_h_mag,
    t.phot_ks_mag,s.phot_ks_mag,2.0::FLOAT)
WHERE
  t.source_id IS NULL;


CREATE INDEX IF NOT EXISTS temp_merged_sources_glonglat
  ON temp_merged_sources (q3c_ang2ipix(glon,glat));
CLUSTER temp_merged_sources_glonglat ON temp_merged_sources;
ANALYZE temp_merged_sources;


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
  phot_hw_mag        FLOAT,
  phot_hw_mag_error  FLOAT,
  phot_hw_mag_source VARCHAR(1),
  phot_j_mag         FLOAT,
  phot_j_mag_error   FLOAT,
  phot_j_mag_source  VARCHAR(1),
  phot_h_mag         FLOAT,
  phot_h_mag_error   FLOAT,
  phot_h_mag_source  VARCHAR(1),
  phot_ks_mag        FLOAT,
  phot_ks_mag_error  FLOAT,
  phot_ks_mag_source VARCHAR(1)
);

ALTER TABLE merged_sources ADD CONSTRAINT
  FK_merged_tmass_id FOREIGN KEY (tmass_source_id)
  REFERENCES tmass_sources (source_id) ON DELETE CASCADE;
ALTER TABLE merged_sources ADD CONSTRAINT
  FK_merged_sirius_id FOREIGN KEY  (sirius_source_id)
  REFERENCES sirius_sources (source_id) ON DELETE CASCADE;
ALTER TABLE merged_sources ADD CONSTRAINT
  FK_merged_vvv_id FOREIGN KEY (vvv_source_id)
  REFERENCES vvv_sources (source_id) ON DELETE CASCADE;


INSERT INTO merged_sources
SELECT
  nextval('merged_sources_source_id_seq') AS source_id,
  t.tmass_source_id AS tmass_source_id,
  t.sirius_source_id AS sirius_source_id,
  v.source_id AS vvv_source_id,
  wrap(COALESCE(v.glon,t.glon)) AS glon,
  COALESCE(v.glat,t.glat) AS glat,
  COALESCE(v.ra,t.ra) AS ra,
  COALESCE(v.dec,t.dec) AS dec,
  ifthenelse(v.source_id,'V',t.position_source) AS position_source,
  select_better(
    v.phot_hw_mag,v.phot_hw_mag_error,
    t.phot_hw_mag,t.phot_hw_mag_error) AS phot_hw_mag,
  select_better(
    v.phot_hw_mag_error,v.phot_hw_mag_error,
    t.phot_hw_mag_error,t.phot_hw_mag_error) AS phot_hw_mag_error,
  select_char(
    v.phot_hw_mag_error,t.phot_hw_mag_error,
    'V',t.phot_hw_mag_source) AS phot_hw_mag_source,
  select_better(
    v.phot_j_mag,v.phot_j_mag_error,
    t.phot_j_mag,t.phot_j_mag_error) AS phot_j_mag,
  select_better(
    v.phot_j_mag_error,v.phot_j_mag_error,
    t.phot_j_mag_error,t.phot_j_mag_error) AS phot_j_mag_error,
  select_char(
    v.phot_j_mag_error,t.phot_j_mag_error,
    'V',t.phot_j_mag_source) AS phot_j_mag_source,
  select_better(
    v.phot_h_mag,v.phot_h_mag_error,
    t.phot_h_mag,t.phot_h_mag_error) AS phot_h_mag,
  select_better(
    v.phot_h_mag_error,v.phot_h_mag_error,
    t.phot_h_mag_error,t.phot_h_mag_error) AS phot_h_mag_error,
  select_char(
    v.phot_h_mag_error,t.phot_h_mag_error,
    'V',t.phot_h_mag_source) AS phot_h_mag_source,
  select_better(
    v.phot_ks_mag,v.phot_ks_mag_error,
    t.phot_ks_mag,t.phot_ks_mag_error) AS phot_ks_mag,
  select_better(
    v.phot_ks_mag_error,v.phot_ks_mag_error,
    t.phot_ks_mag_error,t.phot_ks_mag_error) AS phot_ks_mag_error,
  select_char(
    v.phot_ks_mag_error,t.phot_ks_mag_error,
    'V',t.phot_ks_mag_source) AS phot_ks_mag_source
FROM
  vvv_hw AS v
LEFT JOIN
  temp_merged_sources AS t
ON
  q3c_join(v.glon,v.glat,t.glon,t.glat,1./3600.)
  AND jhk_match(
    t.phot_j_mag,v.phot_j_mag,t.phot_h_mag,v.phot_h_mag,
    t.phot_ks_mag,v.phot_ks_mag,2.0::FLOAT)
UNION
SELECT
  nextval('merged_sources_source_id_seq') AS source_id,
  t.tmass_source_id AS tmass_source_id,
  t.sirius_source_id AS sirius_source_id,
  v.source_id AS vvv_source_id,
  wrap(COALESCE(v.glon,t.glon)) AS glon,
  COALESCE(v.glat,t.glat) AS glat,
  COALESCE(v.ra,t.ra) AS ra,
  COALESCE(v.dec,t.dec) AS dec,
  ifthenelse(v.source_id,'V',t.position_source) AS position_source,
  select_better(
    v.phot_hw_mag,v.phot_hw_mag_error,
    t.phot_hw_mag,t.phot_hw_mag_error) AS phot_hw_mag,
  select_better(
    v.phot_hw_mag_error,v.phot_hw_mag_error,
    t.phot_hw_mag_error,t.phot_hw_mag_error) AS phot_hw_mag_error,
  select_char(
    v.phot_hw_mag_error,t.phot_hw_mag_error,
    'V',t.phot_hw_mag_source) AS phot_hw_mag_source,
  select_better(
    v.phot_j_mag,v.phot_j_mag_error,
    t.phot_j_mag,t.phot_j_mag_error) AS phot_j_mag,
  select_better(
    v.phot_j_mag_error,v.phot_j_mag_error,
    t.phot_j_mag_error,t.phot_j_mag_error) AS phot_j_mag_error,
  select_char(
    v.phot_j_mag_error,t.phot_j_mag_error,
    'V',t.phot_j_mag_source) AS phot_j_mag_source,
  select_better(
    v.phot_h_mag,v.phot_h_mag_error,
    t.phot_h_mag,t.phot_h_mag_error) AS phot_h_mag,
  select_better(
    v.phot_h_mag_error,v.phot_h_mag_error,
    t.phot_h_mag_error,t.phot_h_mag_error) AS phot_h_mag_error,
  select_char(
    v.phot_h_mag_error,t.phot_h_mag_error,
    'V',t.phot_h_mag_source) AS phot_h_mag_source,
  select_better(
    v.phot_ks_mag,v.phot_ks_mag_error,
    t.phot_ks_mag,t.phot_ks_mag_error) AS phot_ks_mag,
  select_better(
    v.phot_ks_mag_error,v.phot_ks_mag_error,
    t.phot_ks_mag_error,t.phot_ks_mag_error) AS phot_ks_mag_error,
  select_char(
    v.phot_ks_mag_error,t.phot_ks_mag_error,
    'V',t.phot_ks_mag_source) AS phot_ks_mag_source
FROM
  temp_merged_sources AS t
LEFT JOIN
  vvv_hw AS v
ON
  q3c_join(t.glon,t.glat,v.glon,v.glat,1./3600.)
  AND jhk_match(
    t.phot_j_mag,v.phot_j_mag,t.phot_h_mag,v.phot_h_mag,
    t.phot_ks_mag,v.phot_ks_mag,2.0::FLOAT)
WHERE
  v.source_id IS NULL;


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
