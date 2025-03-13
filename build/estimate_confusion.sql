\set angdist_threshold 0.25/3600 -- based on histogram of angular separations, this seems a good place to cut
\set magdiff_threshold 5.

DROP TABLE IF EXISTS merged_sources_confusion_025_5 CASCADE; 
CREATE TABLE merged_sources_confusion_025_5 AS
SELECT m.source_id,m.tmass_source_id,m.sirius_source_id,m.vvv_source_id,COUNT(aux.sid) as num_neighbours,MIN(ang_dist_mas) as min_ang_dist,MAX(ang_dist_mas) as max_ang_dist,AVG(ang_dist_mas) as avg_ang_dist,m.ra,m.dec,m.glon,m.glat,m.phot_j_mag,m.phot_h_mag,m.phot_ks_mag,m.phot_hw_mag, MIN(mag_diff) as min_mag_diff_neighbours,MAX(mag_diff) as max_mag_diff_neighbours,
SQRT(POWER(COALESCE(m.phot_j_mag_error,1),2)+POWER(COALESCE(m.phot_h_mag_error,1),2)+POWER(COALESCE(m.phot_ks_mag_error,1),2)) as phot_error,
MIN(aux.phot_error) as min_phot_error_neighbours,
CASE WHEN MIN(ang_dist_mas)<0.1 THEN CASE WHEN COUNT(aux.sid)=1 THEN 1 ELSE 3 END ELSE 2 END AS dups,
select_better_agg(sid,phot_error) as best_neighbour_source_id,
CASE WHEN (m.tmass_source_id IS NOT NULL OR SUM(has_tmass)>0) AND (MIN(brightest_mag)<13 OR LEAST(m.phot_j_mag,m.phot_h_mag,m.phot_ks_mag)<13) --if there is a brigtht tmass source involved, select the brighter
  THEN 
    CASE WHEN (MIN(brightest_mag)<LEAST(m.phot_j_mag,m.phot_h_mag,m.phot_ks_mag)) THEN 1 ElSE 0 END
  ELSE --if not, select the source with the smallest photometric error
    CASE WHEN MIN(aux.phot_error)<SQRT(POWER(COALESCE(m.phot_j_mag_error,1),2)+POWER(COALESCE(m.phot_h_mag_error,1),2)+POWER(COALESCE(m.phot_ks_mag_error,1),2)) THEN 1 ELSE 0 END
END as select_neighbour
FROM merged_sources_raw as m, LATERAL (
  SELECT m1.source_id as sid,m1.tmass_source_id/m1.tmass_source_id as has_tmass,m1.glon,m1.glat,m1.phot_j_mag,m1.phot_h_mag,m1.phot_ks_mag,
  SQRT(POWER(COALESCE(m1.phot_j_mag_error,1),2)+POWER(COALESCE(m1.phot_h_mag_error,1),2)+POWER(COALESCE(m1.phot_ks_mag_error,1),2)) as phot_error, -- compute photometric error budget of the source for comparison, penalise not having a measurement
  SQRT(POWER(COALESCE(m1.phot_j_mag-m.phot_j_mag,0),2)+POWER(COALESCE(m1.phot_h_mag-m.phot_h_mag,0),2)+POWER(COALESCE(m1.phot_ks_mag-m.phot_ks_mag,0),2)) as mag_diff,
  LEAST(m1.phot_j_mag,m1.phot_h_mag,m1.phot_ks_mag) as brightest_mag,
  q3c_dist(m.ra,m.dec,m1.ra,m1.dec)*3600*1000 as ang_dist_mas
  FROM merged_sources_raw as m1 WHERE q3c_join(m.ra,m.dec,m1.ra,m1.dec,:angdist_threshold) AND m.source_id!=m1.source_id
  ) aux WHERE jhk_match(aux.phot_j_mag,m.phot_j_mag,aux.phot_h_mag,m.phot_h_mag,aux.phot_ks_mag,m.phot_ks_mag,:magdiff_threshold) GROUP BY m.source_id;
--m1.phot_j_mag_error,m1.phot_h_mag_error,m1.phot_ks_mag_error,
ALTER TABLE merged_sources_confusion_025_5 ADD CONSTRAINT
  FK_merged_tmass_id FOREIGN KEY (tmass_source_id)
  REFERENCES tmass_sources_clean (source_id) ON DELETE CASCADE;
ALTER TABLE merged_sources_confusion_025_5 ADD CONSTRAINT
  FK_merged_sirius_id FOREIGN KEY  (sirius_source_id)
  REFERENCES sirius_sources_clean (source_id) ON DELETE CASCADE;

-- index merged_sources_confusion_025_5 for quick access
CREATE INDEX IF NOT EXISTS merged_sources_confusion_025_5_source_id
  ON merged_sources_confusion_025_5 (source_id);
CREATE INDEX IF NOT EXISTS merged_sources_confusion_025_5_glonglat
  ON merged_sources_confusion_025_5 (q3c_ang2ipix(glon,glat));
CREATE INDEX IF NOT EXISTS merged_sources_confusion_025_5_dupflag
  ON merged_sources_confusion_025_5 (dups);
CLUSTER merged_sources_confusion_025_5_glonglat ON merged_sources_confusion_025_5;
ANALYZE merged_sources_confusion_025_5;