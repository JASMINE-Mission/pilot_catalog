DROP VIEW IF EXISTS sirius_sources CASCADE;
CREATE MATERIALIZED VIEW sirius_sources AS
SELECT
  *
FROM
  sirius_sources_orig
WHERE
  (glon BETWEEN -2.5 AND 1.2) AND (glat BETWEEN -1.2 AND 1.2);


CREATE OR REPLACE VIEW vvv_sources AS
SELECT
  source_id,
  glon,
  glat,
  ra,
  dec,
  COALESCE(phot_z2_mag,phot_z1_mag) AS phot_z_mag,
  COALESCE(phot_z2_mag_error,phot_z1_mag_error) AS phot_z_mag_error,
  COALESCE(phot_y2_mag,phot_y1_mag) AS phot_y_mag,
  COALESCE(phot_y2_mag_error,phot_y1_mag_error) AS phot_y_mag_error,
  COALESCE(phot_j2_mag,phot_j1_mag) AS phot_j_mag,
  COALESCE(phot_j2_mag_error,phot_j1_mag_error) AS phot_j_mag_error,
  COALESCE(phot_h2_mag,phot_h1_mag) AS phot_h_mag,
  COALESCE(phot_h2_mag_error,phot_h1_mag_error) AS phot_h_mag_error,
  COALESCE(phot_k2_mag,phot_k1_mag) AS phot_k_mag,
  COALESCE(phot_k2_mag_error,phot_k1_mag_error) AS phot_k_mag_error
FROM
  vvv_sources_orig;


DROP VIEW IF EXISTS tmass_vvv_merged_sources CASCADE;
CREATE MATERIALIZED VIEW tmass_vvv_merged_sources AS
SELECT
  t.source_id AS tmass_source_id,
  v.source_id AS vvv_source_id,
  COALESCE(v.glon,t.glon) AS glon,
  COALESCE(v.glon,t.glat) AS glat,
  COALESCE(v.ra,t.ra) AS ra,
  COALESCE(v.dec,t.dec) AS dec,
  ifthenelse(v.source_id,'V','2') AS position_source,
  COALESCE(v.phot_j_mag,t.phot_j_mag) AS phot_j_mag,
  COALESCE(v.phot_j_mag_error,t.phot_j_mag_error) AS phot_j_mag_error,
  ifthenelse(v.phot_j_mag,'V','2') AS phot_j_mag_source,
  COALESCE(v.phot_h_mag,t.phot_h_mag) AS phot_h_mag,
  COALESCE(v.phot_h_mag_error,t.phot_h_mag_error) AS phot_h_mag_error,
  ifthenelse(v.phot_h_mag,'V','2') AS phot_h_mag_source,
  COALESCE(v.phot_k_mag,t.phot_k_mag) AS phot_k_mag,
  COALESCE(v.phot_k_mag_error,t.phot_k_mag_error) AS phot_k_mag_error,
  ifthenelse(v.phot_k_mag,'V','2') AS phot_k_mag_source
FROM
  tmass_sources AS t
LEFT JOIN
  vvv_sources AS v
ON
  q3c_join(t.glon,t.glat,v.glon,v.glat,1./3600.)
  AND jhk_match(
    t.phot_j_mag,v.phot_j_mag,t.phot_h_mag,v.phot_h_mag,
    t.phot_k_mag,v.phot_k_mag,2.0)
UNION ALL
SELECT
  t.source_id AS tmass_source_id,
  v.source_id AS vvv_source_id,
  COALESCE(v.glon,t.glon) AS glon,
  COALESCE(v.glon,t.glat) AS glat,
  COALESCE(v.ra,t.ra) AS ra,
  COALESCE(v.dec,t.dec) AS dec,
  ifthenelse(v.source_id,'V','2') AS position_source,
  COALESCE(v.phot_j_mag,t.phot_j_mag) AS phot_j_mag,
  COALESCE(v.phot_j_mag_error,t.phot_j_mag_error) AS phot_j_mag_error,
  ifthenelse(v.phot_j_mag,'V','2') AS phot_j_mag_source,
  COALESCE(v.phot_h_mag,t.phot_h_mag) AS phot_h_mag,
  COALESCE(v.phot_h_mag_error,t.phot_h_mag_error) AS phot_h_mag_error,
  ifthenelse(v.phot_h_mag,'V','2') AS phot_h_mag_source,
  COALESCE(v.phot_k_mag,t.phot_k_mag) AS phot_k_mag,
  COALESCE(v.phot_k_mag_error,t.phot_k_mag_error) AS phot_k_mag_error,
  ifthenelse(v.phot_k_mag,'V','2') AS phot_k_mag_source
FROM
  tmass_sources AS t
RIGHT JOIN
  vvv_sources AS v
ON
  q3c_join(t.glon,t.glat,v.glon,v.glat,1./3600.)
  AND jhk_match(
    t.phot_j_mag,v.phot_j_mag,t.phot_h_mag,v.phot_h_mag,
    t.phot_k_mag,v.phot_k_mag,2.0)
WHERE
  t.source_id IS NULL;


DROP VIEW IF EXISTS merged_sources CASCADE;
CREATE MATERIALIZED VIEW merged_sources AS
SELECT
  t.tmass_source_id AS tmass_source_id,
  t.vvv_source_id AS vvv_source_id,
  s.source_id AS sirius_source_id,
  COALESCE(s.glon,t.glon) AS glon,
  COALESCE(s.glon,t.glat) AS glat,
  COALESCE(s.ra,t.ra) AS ra,
  COALESCE(s.dec,t.dec) AS dec,
  ifthenelse(s.source_id,'S',t.position_source) AS position_source,
  COALESCE(s.phot_j_mag,t.phot_j_mag) AS phot_j_mag,
  COALESCE(s.phot_j_mag_error,t.phot_j_mag_error) AS phot_j_mag_error,
  ifthenelse(s.phot_j_mag,'S',t.phot_j_mag_source) AS phot_j_mag_source,
  COALESCE(s.phot_h_mag,t.phot_h_mag) AS phot_h_mag,
  COALESCE(s.phot_h_mag_error,t.phot_h_mag_error) AS phot_h_mag_error,
  ifthenelse(s.phot_h_mag,'S',t.phot_h_mag_source) AS phot_h_mag_source,
  COALESCE(s.phot_k_mag,t.phot_k_mag) AS phot_k_mag,
  COALESCE(s.phot_k_mag_error,t.phot_k_mag_error) AS phot_k_mag_error,
  ifthenelse(s.phot_k_mag,'S',t.phot_k_mag_source) AS phot_k_mag_source
FROM
  sirius_sources AS s
LEFT JOIN
  tmass_vvv_merged_sources AS t
ON
  q3c_join(s.glon,s.glat,t.glon,t.glat,1./3600.)
  AND jhk_match(
    t.phot_j_mag,s.phot_j_mag,t.phot_h_mag,s.phot_h_mag,
    t.phot_k_mag,s.phot_k_mag,2.0)
UNION ALL
SELECT
  t.tmass_source_id AS tmass_source_id,
  t.vvv_source_id AS vvv_source_id,
  s.source_id AS sirius_source_id,
  COALESCE(s.glon,t.glon) AS glon,
  COALESCE(s.glon,t.glat) AS glat,
  COALESCE(s.ra,t.ra) AS ra,
  COALESCE(s.dec,t.dec) AS dec,
  ifthenelse(s.source_id,'S',t.position_source) AS position_source,
  COALESCE(s.phot_j_mag,t.phot_j_mag) AS phot_j_mag,
  COALESCE(s.phot_j_mag_error,t.phot_j_mag_error) AS phot_j_mag_error,
  ifthenelse(s.phot_j_mag,'S',t.phot_j_mag_source) AS phot_j_mag_source,
  COALESCE(s.phot_h_mag,t.phot_h_mag) AS phot_h_mag,
  COALESCE(s.phot_h_mag_error,t.phot_h_mag_error) AS phot_h_mag_error,
  ifthenelse(s.phot_h_mag,'S',t.phot_h_mag_source) AS phot_h_mag_source,
  COALESCE(s.phot_k_mag,t.phot_k_mag) AS phot_k_mag,
  COALESCE(s.phot_k_mag_error,t.phot_k_mag_error) AS phot_k_mag_error,
  ifthenelse(s.phot_k_mag,'S',t.phot_k_mag_source) AS phot_k_mag_source
FROM
  sirius_sources AS s
RIGHT JOIN
  tmass_vvv_merged_sources AS t
ON
  q3c_join(s.glon,s.glat,t.glon,t.glat,1./3600.)
  AND jhk_match(
    t.phot_j_mag,s.phot_j_mag,t.phot_h_mag,s.phot_h_mag,
    t.phot_k_mag,s.phot_k_mag,2.0)
WHERE
  s.source_id IS NULL;
