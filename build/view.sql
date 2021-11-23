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
