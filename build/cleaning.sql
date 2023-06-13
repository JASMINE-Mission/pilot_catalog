DROP TABLE IF EXISTS merged_sources CASCADE;
CREATE TABLE tmass_sources_clean AS
SELECT MIN(aux2.source_id) AS source_id,AVG(aux2.ra) AS ra ,AVG(aux2.dec) AS dec,MIN(aux2.designation) AS designation, 
CASE WHEN AVG(aux2.phot_j_mag_error) IS NULL THEN AVG(aux2.phot_j_mag) ELSE SUM(aux2.phot_j_mag*aux2.phot_j_mag_error)/SUM(aux2.phot_j_mag_error) END as phot_j_mag, MAX(aux2.phot_j_cmsig) as phot_j_cmsig, MAX(aux2.phot_j_mag_error) as phot_j_mag_error, MIN(aux2.phot_j_snr) as phot_j_snr, 
CASE WHEN AVG(aux2.phot_h_mag_error) IS NULL THEN AVG(aux2.phot_h_mag) ELSE SUM(aux2.phot_h_mag*aux2.phot_h_mag_error)/SUM(aux2.phot_h_mag_error) END as phot_h_mag, MAX(aux2.phot_h_cmsig) as phot_h_cmsig, MAX(aux2.phot_h_mag_error) as phot_h_mag_error, MIN(aux2.phot_h_snr) as phot_h_snr,  
CASE WHEN AVG(aux2.phot_ks_mag_error) IS NULL THEN AVG(aux2.phot_ks_mag) ELSE SUM(aux2.phot_ks_mag*aux2.phot_ks_mag_error)/SUM(aux2.phot_ks_mag_error) END as phot_ks_mag, MAX(aux2.phot_ks_cmsig) as phot_ks_cmsig, MAX(aux2.phot_ks_mag_error) as phot_ks_mag_error, MIN(aux2.phot_ks_snr) as phot_ks_snr, 
STRING_AGG(aux2.quality_flag,'-') as quality_flag, STRING_AGG(aux2.rd_flg,'-') as rd_flg, 
STRING_AGG(aux2.pair_id,'-') as pair_id FROM
(SELECT MIN(aux.source_id) AS source_id,AVG(aux.ra) AS ra ,AVG(aux.dec) AS dec,MIN(aux.designation) AS designation, 
CASE WHEN AVG(aux.phot_j_mag_error) IS NULL THEN AVG(aux.phot_j_mag) ELSE SUM(aux.phot_j_mag*aux.phot_j_mag_error)/SUM(aux.phot_j_mag_error) END as phot_j_mag, MAX(aux.phot_j_cmsig) as phot_j_cmsig, MAX(aux.phot_j_mag_error) as phot_j_mag_error, MIN(aux.phot_j_snr) as phot_j_snr, 
CASE WHEN AVG(aux.phot_h_mag_error) IS NULL THEN AVG(aux.phot_h_mag) ELSE SUM(aux.phot_h_mag*aux.phot_h_mag_error)/SUM(aux.phot_h_mag_error) END as phot_h_mag, MAX(aux.phot_h_cmsig) as phot_h_cmsig, MAX(aux.phot_h_mag_error) as phot_h_mag_error, MIN(aux.phot_h_snr) as phot_h_snr,  
CASE WHEN AVG(aux.phot_ks_mag_error) IS NULL THEN AVG(aux.phot_ks_mag) ELSE SUM(aux.phot_ks_mag*aux.phot_ks_mag_error)/SUM(aux.phot_ks_mag_error) END as phot_ks_mag, MAX(aux.phot_ks_cmsig) as phot_ks_cmsig, MAX(aux.phot_ks_mag_error) as phot_ks_mag_error, MIN(aux.phot_ks_snr) as phot_ks_snr, 
STRING_AGG(aux.quality_flag,'-') as quality_flag, STRING_AGG(aux.rd_flg,'-') as rd_flg, 
MIN(aux.pair_id) as pair_id FROM 
(SELECT t1.*,CASE WHEN t1.source_id<t2.source_id THEN CONCAT(CAST(t1.source_id AS varchar),'-',CAST(t2.source_id AS varchar)) ELSE CONCAT(CAST(t2.source_id AS varchar),'-',CAST(t1.source_id AS varchar)) END as pair_id FROM tmass_sources AS t1 INNER JOIN tmass_sources AS t2 ON q3c_join(t1.ra,t1.dec,t2.ra,t2.dec,2./3600.) AND (COALESCE(ABS(t1.phot_j_mag-t2.phot_j_mag)<2.,True) AND COALESCE(ABS(t1.phot_h_mag-t2.phot_h_mag)<2.,True) AND COALESCE(ABS(t1.phot_ks_mag-t2.phot_ks_mag)<2.,True)) WHERE t1.source_id!=t2.source_id) AS aux GROUP BY aux.pair_id) 
as aux2 GROUP BY FLOOR(aux2.ra*3600.0/4.0),FLOOR(aux2.dec*3600.0/4.0)
UNION
SELECT t.source_id,t.ra,t.dec,t.designation,t.phot_j_mag,t.phot_j_cmsig,t.phot_j_mag_error,t.phot_j_snr,t.phot_h_mag,t.phot_h_cmsig,t.phot_h_mag_error,t.phot_h_snr,t.phot_ks_mag,t.phot_ks_cmsig,t.phot_ks_mag_error,t.phot_ks_snr,t.quality_flag,t.rd_flg, NULL as pair_id FROM tmass_sources as t WHERE t.source_id NOT IN 
(SELECT t2.source_id FROM tmass_sources AS t2 INNER JOIN tmass_sources as t3 ON q3c_join(t3.ra,t3.dec,t2.ra,t2.dec,2./3600.) AND (COALESCE(ABS(t3.phot_j_mag-t2.phot_j_mag)<2.,True) AND COALESCE(ABS(t3.phot_h_mag-t2.phot_h_mag)<2.,True) AND COALESCE(ABS(t3.phot_ks_mag-t2.phot_ks_mag)<2.,True)) WHERE t2.source_id!=t3.source_id) 