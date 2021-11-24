DROP MATERIALIZED VIEW IF EXISTS tmass_vvv_merged_sources CASCADE;
CREATE MATERIALIZED VIEW tmass_vvv_merged_sources AS
SELECT
  t.source_id AS tmass_source_id,
  v.source_id AS vvv_source_id,
  COALESCE(v.glon,t.glon) AS glon,
  COALESCE(v.glat,t.glat) AS glat,
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
UNION
SELECT
  t.source_id AS tmass_source_id,
  v.source_id AS vvv_source_id,
  COALESCE(v.glon,t.glon) AS glon,
  COALESCE(v.glat,t.glat) AS glat,
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
  vvv_sources AS v
LEFT JOIN
  tmass_sources AS t
ON
  q3c_join(v.glon,v.glat,t.glon,t.glat,1./3600.)
  AND jhk_match(
    t.phot_j_mag,v.phot_j_mag,t.phot_h_mag,v.phot_h_mag,
    t.phot_k_mag,v.phot_k_mag,2.0)
WHERE
  t.source_id IS NULL;


CREATE INDEX IF NOT EXISTS tmass_vvv_merged_sources_radec
  ON tmass_vvv_merged_sources (q3c_ang2ipix(ra,dec));
CREATE INDEX IF NOT EXISTS tmass_vvv_merged_sources_glonglat
  ON tmass_vvv_merged_sources (q3c_ang2ipix(glon,glat));
CREATE INDEX IF NOT EXISTS tmass_vvv_merged_sources_jmag
  ON tmass_vvv_merged_sources (phot_j_mag);
CREATE INDEX IF NOT EXISTS tmass_vvv_merged_sources_hmag
  ON tmass_vvv_merged_sources (phot_h_mag);
CREATE INDEX IF NOT EXISTS tmass_vvv_merged_sources_kmag
  ON tmass_vvv_merged_sources (phot_k_mag);
CREATE INDEX IF NOT EXISTS tmass_vvv_merged_sources_ra
  ON tmass_vvv_merged_sources (ra);
CREATE INDEX IF NOT EXISTS tmass_vvv_merged_sources_dec
  ON tmass_vvv_merged_sources (dec);
CREATE INDEX IF NOT EXISTS tmass_vvv_merged_sources_glon
  ON tmass_vvv_merged_sources (glon);
CREATE INDEX IF NOT EXISTS tmass_vvv_merged_sources_glat
  ON tmass_vvv_merged_sources (glat);
CLUSTER tmass_vvv_merged_sources_glonglat ON tmass_vvv_merged_sources;
ANALYZE tmass_vvv_merged_sources;
