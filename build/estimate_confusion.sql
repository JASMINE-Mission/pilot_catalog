\set angdist_threshold 0.25/3600 -- based on histogram of angular separations, this seems a good place to cut
\set magdiff_threshold 5.

DROP TABLE IF EXISTS merged_sources_confusion_06_5 CASCADE; 
CREATE TABLE merged_sources_confusion_06_5 AS
SELECT m.source_id,m.tmass_source_id,m.sirius_source_id,m.vvv_source_id,COUNT(aux.sid) as num_neighbours,MIN(ang_dist_mas) as min_ang_dist,MAX(ang_dist_mas) as max_ang_dist,AVG(ang_dist_mas) as avg_ang_dist,m.ra,m.dec,m.glon,m.glat,m.phot_j_mag,m.phot_h_mag,m.phot_ks_mag,m.phot_hw_mag, 
CASE WHEN MIN(ang_dist_mas)<0.1 THEN CASE WHEN COUNT(aux.sid)=1 THEN 1 ELSE 3 END ELSE 2 END AS dups
FROM merged_sources_raw as m, LATERAL (SELECT m1.source_id as sid,m1.glon,m1.glat,m1.phot_j_mag,m1.phot_h_mag,m1.phot_ks_mag,q3c_dist(m.ra,m.dec,m1.ra,m1.dec)*3600*1000 as ang_dist_mas FROM merged_sources_raw as m1 WHERE q3c_join(m.ra,m.dec,m1.ra,m1.dec,:angdist_threshold) AND m.source_id!=m1.source_id) aux WHERE jhk_match(aux.phot_j_mag,m.phot_j_mag,aux.phot_h_mag,m.phot_h_mag,aux.phot_ks_mag,m.phot_ks_mag,:magdiff_threshold) GROUP BY m.source_id;

ALTER TABLE merged_sources_confusion_06_5 ADD CONSTRAINT
  FK_merged_tmass_id FOREIGN KEY (tmass_source_id)
  REFERENCES tmass_sources_clean (source_id) ON DELETE CASCADE;
ALTER TABLE merged_sources_confusion_06_5 ADD CONSTRAINT
  FK_merged_sirius_id FOREIGN KEY  (sirius_source_id)
  REFERENCES sirius_sources_clean (source_id) ON DELETE CASCADE;

-- index merged_sources_confusion_06_5 for quick access
CREATE INDEX IF NOT EXISTS merged_sources_confusion_06_5_source_id
  ON merged_sources_confusion_06_5 (source_id);
CREATE INDEX IF NOT EXISTS merged_sources_confusion_06_5_glonglat
  ON merged_sources_confusion_06_5 (q3c_ang2ipix(glon,glat));
CREATE INDEX IF NOT EXISTS merged_sources_confusion_06_5_dupflag
  ON merged_sources_confusion_06_5 (dups);
CLUSTER merged_sources_confusion_06_5_glonglat ON merged_sources_confusion_06_5;
ANALYZE merged_sources_confusion_06_5;