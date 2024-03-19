\set angdist_threshold 0.6/3600
\set magdiff_threshold 5.

DROP TABLE IF EXISTS merged_sources_confusion_06_5 CASCADE; 
CREATE TABLE merged_sources_confusion_06_5 AS
SELECT m.source_id,COUNT(aux.sid),m.glon,m.glat,m.phot_j_mag,m.phot_h_mag,m.phot_ks_mag,m.phot_hw_mag FROM merged_sources_raw as m, LATERAL (SELECT m1.source_id as sid,m1.glon,m1.glat,m1.phot_j_mag,m1.phot_h_mag,m1.phot_ks_mag FROM merged_sources_raw as m1 WHERE q3c_join(m.ra,m.dec,m1.ra,m1.dec,:angdist_threshold)) aux WHERE jhk_match(aux.phot_j_mag,m.phot_j_mag,aux.phot_h_mag,m.phot_h_mag,aux.phot_ks_mag,m.phot_ks_mag,:magdiff_threshold) GROUP BY m.source_id;


-- index merged_sources_confusion_06_5 for quick access
CREATE INDEX IF NOT EXISTS merged_sources_confusion_06_5_source_id
  ON merged_sources_confusion_06_5 (source_id);
CREATE INDEX IF NOT EXISTS merged_sources_confusion_06_5_glonglat
  ON merged_sources_confusion_06_5 (q3c_ang2ipix(glon,glat));
CLUSTER merged_sources_confusion_06_5_glonglat ON merged_sources_confusion_06_5;
ANALYZE merged_sources_confusion_06_5;

