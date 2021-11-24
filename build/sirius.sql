DROP VIEW IF EXISTS sirius_sources CASCADE;
CREATE MATERIALIZED VIEW sirius_sources AS
SELECT
  *
FROM
  sirius_sources_orig
WHERE
  (glon BETWEEN -2.5 AND 1.2) AND (glat BETWEEN -1.2 AND 1.2);


CREATE INDEX IF NOT EXISTS sirius_sources_radec
  ON sirius_sources (q3c_ang2ipix(ra,dec));
CREATE INDEX IF NOT EXISTS sirius_sources_glonglat
  ON sirius_sources (q3c_ang2ipix(glon,glat));
CREATE INDEX IF NOT EXISTS sirius_sources_jmag
  ON sirius_sources (phot_j_mag);
CREATE INDEX IF NOT EXISTS sirius_sources_hmag
  ON sirius_sources (phot_h_mag);
CREATE INDEX IF NOT EXISTS sirius_sources_kmag
  ON sirius_sources (phot_k_mag);
CREATE INDEX IF NOT EXISTS sirius_sources_ra
  ON sirius_sources (ra);
CREATE INDEX IF NOT EXISTS sirius_sources_dec
  ON sirius_sources (dec);
CREATE INDEX IF NOT EXISTS sirius_sources_glon
  ON sirius_sources (glon);
CREATE INDEX IF NOT EXISTS sirius_sources_glat
  ON sirius_sources (glat);
CLUSTER sirius_sources_glonglat ON sirius_sources;
ANALYZE sirius_sources;
