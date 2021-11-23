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
  tmass_vvv_merged_sources AS t
LEFT JOIN
  sirius_sources AS s
ON
  q3c_join(t.glon,t.glat,s.glon,s.glat,1./3600.)
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
LEFT JOIN
  tmass_vvv_merged_sources AS t
ON
  q3c_join(s.glon,s.glat,t.glon,t.glat,1./3600.)
  AND jhk_match(
    t.phot_j_mag,s.phot_j_mag,t.phot_h_mag,s.phot_h_mag,
    t.phot_k_mag,s.phot_k_mag,2.0)
WHERE
  s.source_id IS NULL;
