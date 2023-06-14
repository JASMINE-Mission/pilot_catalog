DROP TABLE IF EXISTS tmass_sources_clean CASCADE;
CREATE TABLE tmass_sources_clean AS
SELECT MIN(aux2.source_id) AS source_id,AVG(aux2.ra) AS ra ,AVG(aux2.dec) AS dec,MIN(aux2.designation) AS designation, 
CASE WHEN AVG(aux2.phot_j_mag_error) IS NULL THEN AVG(aux2.phot_j_mag) ELSE SUM(aux2.phot_j_mag*aux2.phot_j_mag_error)/SUM(aux2.phot_j_mag_error) END as phot_j_mag, MAX(aux2.phot_j_cmsig) as phot_j_cmsig, MAX(aux2.phot_j_mag_error) as phot_j_mag_error, MIN(aux2.phot_j_snr) as phot_j_snr, 
CASE WHEN AVG(aux2.phot_h_mag_error) IS NULL THEN AVG(aux2.phot_h_mag) ELSE SUM(aux2.phot_h_mag*aux2.phot_h_mag_error)/SUM(aux2.phot_h_mag_error) END as phot_h_mag, MAX(aux2.phot_h_cmsig) as phot_h_cmsig, MAX(aux2.phot_h_mag_error) as phot_h_mag_error, MIN(aux2.phot_h_snr) as phot_h_snr,  
CASE WHEN AVG(aux2.phot_ks_mag_error) IS NULL THEN AVG(aux2.phot_ks_mag) ELSE SUM(aux2.phot_ks_mag*aux2.phot_ks_mag_error)/SUM(aux2.phot_ks_mag_error) END as phot_ks_mag, MAX(aux2.phot_ks_cmsig) as phot_ks_cmsig, MAX(aux2.phot_ks_mag_error) as phot_ks_mag_error, MIN(aux2.phot_ks_snr) as phot_ks_snr, 
STRING_AGG(aux2.quality_flag,'-') as quality_flag, STRING_AGG(aux2.rd_flg,'-') as rd_flg, 
STRING_AGG(aux2.pair_id,'-') as pair_id,MAX(aux2.ang_dist) as ang_dist FROM
(SELECT MIN(aux.source_id) AS source_id,AVG(aux.ra) AS ra ,AVG(aux.dec) AS dec,MIN(aux.designation) AS designation, 
CASE WHEN AVG(aux.phot_j_mag_error) IS NULL THEN AVG(aux.phot_j_mag) ELSE SUM(aux.phot_j_mag*aux.phot_j_mag_error)/SUM(aux.phot_j_mag_error) END as phot_j_mag, MAX(aux.phot_j_cmsig) as phot_j_cmsig, MAX(aux.phot_j_mag_error) as phot_j_mag_error, MIN(aux.phot_j_snr) as phot_j_snr, 
CASE WHEN AVG(aux.phot_h_mag_error) IS NULL THEN AVG(aux.phot_h_mag) ELSE SUM(aux.phot_h_mag*aux.phot_h_mag_error)/SUM(aux.phot_h_mag_error) END as phot_h_mag, MAX(aux.phot_h_cmsig) as phot_h_cmsig, MAX(aux.phot_h_mag_error) as phot_h_mag_error, MIN(aux.phot_h_snr) as phot_h_snr,  
CASE WHEN AVG(aux.phot_ks_mag_error) IS NULL THEN AVG(aux.phot_ks_mag) ELSE SUM(aux.phot_ks_mag*aux.phot_ks_mag_error)/SUM(aux.phot_ks_mag_error) END as phot_ks_mag, MAX(aux.phot_ks_cmsig) as phot_ks_cmsig, MAX(aux.phot_ks_mag_error) as phot_ks_mag_error, MIN(aux.phot_ks_snr) as phot_ks_snr, 
STRING_AGG(aux.quality_flag,'-') as quality_flag, STRING_AGG(aux.rd_flg,'-') as rd_flg, 
MIN(aux.pair_id) as pair_id,MAX(aux.ang_dist) as ang_dist FROM 
(SELECT t1.*,CASE WHEN t1.source_id<t2.source_id THEN CONCAT(CAST(t1.source_id AS varchar),'-',CAST(t2.source_id AS varchar)) ELSE CONCAT(CAST(t2.source_id AS varchar),'-',CAST(t1.source_id AS varchar)) END as pair_id,q3c_dist(t1.ra,t1.dec,t2.ra,t2.dec) as ang_dist FROM tmass_sources AS t1 INNER JOIN tmass_sources AS t2 ON q3c_join(t1.ra,t1.dec,t2.ra,t2.dec,2./3600.) AND jhk_match(t1.phot_j_mag,t2.phot_j_mag,t1.phot_h_mag,t2.phot_h_mag,t1.phot_ks_mag,t2.phot_ks_mag,2.0::FLOAT) WHERE t1.source_id!=t2.source_id) AS aux GROUP BY aux.pair_id) 
as aux2 GROUP BY FLOOR(aux2.ra*3600.0/4.0),FLOOR(aux2.dec*3600.0/4.0)
UNION
SELECT t.source_id,t.ra,t.dec,t.designation,t.phot_j_mag,t.phot_j_cmsig,t.phot_j_mag_error,t.phot_j_snr,t.phot_h_mag,t.phot_h_cmsig,t.phot_h_mag_error,t.phot_h_snr,t.phot_ks_mag,t.phot_ks_cmsig,t.phot_ks_mag_error,t.phot_ks_snr,t.quality_flag,t.rd_flg, NULL as pair_id, NULL as ang_dist FROM tmass_sources as t WHERE t.source_id NOT IN 
(SELECT t2.source_id FROM tmass_sources AS t2 INNER JOIN tmass_sources as t3 ON q3c_join(t3.ra,t3.dec,t2.ra,t2.dec,2./3600.) AND (COALESCE(ABS(t3.phot_j_mag-t2.phot_j_mag)<2.,True) AND COALESCE(ABS(t3.phot_h_mag-t2.phot_h_mag)<2.,True) AND COALESCE(ABS(t3.phot_ks_mag-t2.phot_ks_mag)<2.,True)) WHERE t2.source_id!=t3.source_id) 


DROP TABLE IF EXISTS vvv_sources_clean CASCADE;
CREATE TABLE vvv_sources_clean AS
SELECT MIN(aux2.source_id) AS source_id,AVG(aux2.ra) AS ra ,AVG(aux2.dec) AS dec,
CASE WHEN AVG(aux2.phot_z_mag_error) IS NULL THEN AVG(aux2.phot_z_mag) ELSE SUM(aux2.phot_z_mag*aux2.phot_z_mag_error)/SUM(aux2.phot_z_mag_error) END as phot_z_mag, MAX(aux2.phot_z_mag_error) as phot_z_mag_error, SUM(aux2.phot_z_flag) as phot_z_flag,
CASE WHEN AVG(aux2.phot_y_mag_error) IS NULL THEN AVG(aux2.phot_y_mag) ELSE SUM(aux2.phot_y_mag*aux2.phot_y_mag_error)/SUM(aux2.phot_y_mag_error) END as phot_y_mag, MAX(aux2.phot_y_mag_error) as phot_y_mag_error, SUM(aux2.phot_y_flag) as phot_y_flag,
CASE WHEN AVG(aux2.phot_j_mag_error) IS NULL THEN AVG(aux2.phot_j_mag) ELSE SUM(aux2.phot_j_mag*aux2.phot_j_mag_error)/SUM(aux2.phot_j_mag_error) END as phot_j_mag, MAX(aux2.phot_j_mag_error) as phot_j_mag_error, SUM(aux2.phot_j_flag) as phot_j_flag,
CASE WHEN AVG(aux2.phot_h_mag_error) IS NULL THEN AVG(aux2.phot_h_mag) ELSE SUM(aux2.phot_h_mag*aux2.phot_h_mag_error)/SUM(aux2.phot_h_mag_error) END as phot_h_mag, MAX(aux2.phot_h_mag_error) as phot_h_mag_error, SUM(aux2.phot_h_flag) as phot_h_flag,
CASE WHEN AVG(aux2.phot_ks_mag_error) IS NULL THEN AVG(aux2.phot_ks_mag) ELSE SUM(aux2.phot_ks_mag*aux2.phot_ks_mag_error)/SUM(aux2.phot_ks_mag_error) END as phot_ks_mag, MAX(aux2.phot_ks_mag_error) as phot_ks_mag_error,SUM(aux2.phot_ks_flag) as phot_ks_flag, 
STRING_AGG(aux2.pair_id,'-') as pair_id,MAX(aux2.ang_dist) as ang_dist FROM
(SELECT MIN(aux.source_id) AS source_id,AVG(aux.ra) AS ra ,AVG(aux.dec) AS dec,
CASE WHEN AVG(aux.phot_z_mag_error) IS NULL THEN AVG(aux.phot_z_mag) ELSE SUM(aux.phot_z_mag*aux.phot_z_mag_error)/SUM(aux.phot_z_mag_error) END as phot_z_mag, MAX(aux.phot_z_mag_error) as phot_z_mag_error, SUM(aux.phot_z_flag) as phot_z_flag,
CASE WHEN AVG(aux.phot_y_mag_error) IS NULL THEN AVG(aux.phot_y_mag) ELSE SUM(aux.phot_y_mag*aux.phot_y_mag_error)/SUM(aux.phot_y_mag_error) END as phot_y_mag, MAX(aux.phot_y_mag_error) as phot_y_mag_error, SUM(aux.phot_y_flag) as phot_y_flag,
CASE WHEN AVG(aux.phot_j_mag_error) IS NULL THEN AVG(aux.phot_j_mag) ELSE SUM(aux.phot_j_mag*aux.phot_j_mag_error)/SUM(aux.phot_j_mag_error) END as phot_j_mag, MAX(aux.phot_j_mag_error) as phot_j_mag_error, SUM(aux.phot_j_flag) as phot_j_flag,
CASE WHEN AVG(aux.phot_h_mag_error) IS NULL THEN AVG(aux.phot_h_mag) ELSE SUM(aux.phot_h_mag*aux.phot_h_mag_error)/SUM(aux.phot_h_mag_error) END as phot_h_mag, MAX(aux.phot_h_mag_error) as phot_h_mag_error, SUM(aux.phot_h_flag) as phot_h_flag,
CASE WHEN AVG(aux.phot_ks_mag_error) IS NULL THEN AVG(aux.phot_ks_mag) ELSE SUM(aux.phot_ks_mag*aux.phot_ks_mag_error)/SUM(aux.phot_ks_mag_error) END as phot_ks_mag, MAX(aux.phot_ks_mag_error) as phot_ks_mag_error,SUM(aux.phot_ks_flag) as phot_ks_flag,
MIN(aux.pair_id) as pair_id, MAX(aux.ang_dist) as ang_dist FROM 
(SELECT v1.source_id,v1.ra,v1.dec,
CASE WHEN v1.phot_z_mag_error IS NULL THEN NULL ELSE GREATEST(v1.phot_z_mag_error,0.001) END as phot_z_mag_error,v1.phot_z_mag,
CASE WHEN v1.phot_y_mag_error IS NULL THEN NULL ELSE GREATEST(v1.phot_y_mag_error,0.001) END as phot_y_mag_error,v1.phot_y_mag,
CASE WHEN v1.phot_j_mag_error IS NULL THEN NULL ELSE GREATEST(v1.phot_j_mag_error,0.001) END as phot_j_mag_error,v1.phot_j_mag,
CASE WHEN v1.phot_h_mag_error IS NULL THEN NULL ELSE GREATEST(v1.phot_h_mag_error,0.001) END as phot_h_mag_error,v1.phot_h_mag,
CASE WHEN v1.phot_ks_mag_error IS NULL THEN NULL ELSE GREATEST(v1.phot_ks_mag_error,0.001) END as phot_ks_mag_error,v1.phot_ks_mag, 
v1.phot_z_flag,v1.phot_y_flag,v1.phot_j_flag,v1.phot_h_flag,v1.phot_ks_flag,
q3c_dist(v1.ra,v1.dec,v2.ra,v2.dec)*3600. as ang_dist,
CASE WHEN v1.source_id<v2.source_id THEN CONCAT(CAST(v1.source_id AS varchar),'-',CAST(v2.source_id AS varchar)) ELSE CONCAT(CAST(v2.source_id AS varchar),'-',CAST(v1.source_id AS varchar)) END as pair_id FROM vvv_sources AS v1 INNER JOIN vvv_sources AS v2 ON q3c_join(v1.ra,v1.dec,v2.ra,v2.dec,0.6/3600.) AND (COALESCE(ABS((v1.phot_j_mag-v2.phot_j_mag)/SQRT(v1.phot_j_mag_error*v1.phot_j_mag_error+v2.phot_j_mag_error*v2.phot_j_mag_error))<50.,True) AND COALESCE(ABS((v1.phot_h_mag-v2.phot_h_mag)/SQRT(v1.phot_h_mag_error*v1.phot_h_mag_error+v2.phot_h_mag_error*v2.phot_h_mag_error))<50.,True) AND COALESCE(ABS((v1.phot_ks_mag-v2.phot_ks_mag)/SQRT(v1.phot_ks_mag_error*v1.phot_ks_mag_error+v2.phot_ks_mag_error*v2.phot_ks_mag_error))<50.,True)) WHERE v1.source_id!=v2.source_id) AS aux GROUP BY aux.pair_id) 
as aux2 GROUP BY FLOOR(aux2.ra*3600.0/2.0),FLOOR(aux2.dec*3600.0/2.0)
UNION
SELECT v.source_id,v.ra,v.dec,v.phot_j_mag,v.phot_j_mag_error,v.phot_h_mag,v.phot_h_mag_error,v.phot_ks_mag,v.phot_ks_mag_error, NULL as pair_id, NULL as ang_dist FROM vvv_sources as v WHERE v.source_id NOT IN 
(SELECT v2.source_id FROM vvv_sources AS v2 INNER JOIN vvv_sources as v3 ON q3c_join(v3.ra,v3.dec,v2.ra,v2.dec,0.6/3600.) AND (COALESCE(ABS((v3.phot_j_mag-v2.phot_j_mag)/SQRT(v3.phot_j_mag_error*v3.phot_j_mag_error+v2.phot_j_mag_error*v2.phot_j_mag_error))<50.,True) AND COALESCE(ABS((v3.phot_h_mag-v2.phot_h_mag)/SQRT(v3.phot_h_mag_error*v3.phot_h_mag_error+v2.phot_h_mag_error*v2.phot_h_mag_error))<50.,True) AND COALESCE(ABS((v3.phot_ks_mag-v2.phot_ks_mag)/SQRT(v3.phot_ks_mag_error*v3.phot_ks_mag_error+v2.phot_ks_mag_error*v2.phot_ks_mag_error))<50.,True)) WHERE v2.source_id!=v3.source_id)



DROP TABLE IF EXISTS sirius_sources_clean CASCADE;
CREATE TABLE sirius_sources_clean AS
SELECT MIN(aux2.source_id) AS source_id,AVG(aux2.ra) AS ra ,AVG(aux2.dec) AS dec,
AVG(aux2.position_j_x) as position_j_x, AVG(aux2.position_j_y) as position_j_y,CASE WHEN AVG(aux2.phot_j_mag_error) IS NULL THEN AVG(aux2.phot_j_mag) ELSE SUM(aux2.phot_j_mag*aux2.phot_j_mag_error)/SUM(aux2.phot_j_mag_error) END as phot_j_mag, MAX(aux2.phot_j_mag_error) as phot_j_mag_error,
AVG(aux2.position_h_x) as position_h_x, AVG(aux2.position_h_y) as position_h_y,CASE WHEN AVG(aux2.phot_h_mag_error) IS NULL THEN AVG(aux2.phot_h_mag) ELSE SUM(aux2.phot_h_mag*aux2.phot_h_mag_error)/SUM(aux2.phot_h_mag_error) END as phot_h_mag, MAX(aux2.phot_h_mag_error) as phot_h_mag_error,
AVG(aux2.position_ks_x) as position_ks_x, AVG(aux2.position_ks_y) as position_ks_y,CASE WHEN AVG(aux2.phot_ks_mag_error) IS NULL THEN AVG(aux2.phot_ks_mag) ELSE SUM(aux2.phot_ks_mag*aux2.phot_ks_mag_error)/SUM(aux2.phot_ks_mag_error) END as phot_ks_mag, MAX(aux2.phot_ks_mag_error) as phot_ks_mag_error,
STRING_AGG(aux2.plate_name,'-') as plate_name,
STRING_AGG(aux2.pair_id,'-') as pair_id, MAX(aux2.ang_dist) as ang_dist
FROM (SELECT MIN(aux.source_id) AS source_id,AVG(aux.ra) AS ra ,AVG(aux.dec) AS dec,
CASE WHEN AVG(aux.phot_j_mag_error) IS NULL THEN AVG(aux.phot_j_mag) ELSE SUM(aux.phot_j_mag*aux.phot_j_mag_error)/SUM(aux.phot_j_mag_error) END as phot_j_mag, MAX(aux.phot_j_mag_error) as phot_j_mag_error, AVG(aux.position_j_x) as position_j_x, AVG(aux.position_j_y) as position_j_y,
CASE WHEN AVG(aux.phot_h_mag_error) IS NULL THEN AVG(aux.phot_h_mag) ELSE SUM(aux.phot_h_mag*aux.phot_h_mag_error)/SUM(aux.phot_h_mag_error) END as phot_h_mag, MAX(aux.phot_h_mag_error) as phot_h_mag_error,AVG(aux.position_h_x) as position_h_x, AVG(aux.position_h_y) as position_h_y,
CASE WHEN AVG(aux.phot_ks_mag_error) IS NULL THEN AVG(aux.phot_ks_mag) ELSE SUM(aux.phot_ks_mag*aux.phot_ks_mag_error)/SUM(aux.phot_ks_mag_error) END as phot_ks_mag, MAX(aux.phot_ks_mag_error) as phot_ks_mag_error,AVG(aux.position_ks_x) as position_ks_x, AVG(aux.position_ks_y) as position_ks_y,
STRING_AGG(aux.plate_name,'-') as plate_name,
MIN(aux.pair_id) as pair_id, MAX(aux.ang_dist) as ang_dist
FROM (SELECT s1.*,q3c_dist(s1.ra,s1.dec,s2.ra,s2.dec)*3600. as ang_dist,
CASE WHEN s1.source_id<s2.source_id THEN CONCAT(CAST(s1.source_id AS varchar),'-',CAST(s2.source_id AS varchar)) ELSE CONCAT(CAST(s2.source_id AS varchar),'-',CAST(s1.source_id AS varchar)) END as pair_id FROM sirius_sources as s1 INNER JOIN sirius_sources as s2 ON q3c_join(s1.ra,s1.dec,s2.ra,s2.dec,1./3600) AND jhk_match(s1.phot_j_mag,s2.phot_j_mag,s1.phot_h_mag,s2.phot_h_mag,s1.phot_ks_mag,s2.phot_ks_mag,1.0::FLOAT) WHERE s1.source_id!=s2.source_id ) AS aux GROUP BY aux.pair_id) as aux2 GROUP BY FLOOR(aux2.ra*3600.0/1.0),FLOOR(aux2.dec*3600.0/1.0)
UNION 
SELECT s.source_id,s.ra,s.dec,s.position_j_x,s.position_j_y,s.phot_j_mag,s.phot_j_mag_error,s.position_h_x,s.position_h_y,s.phot_h_mag,s.phot_h_mag_error,s.position_ks_x,s.position_ks_y,s.phot_ks_mag,s.phot_ks_mag_error,s.plate_name, NULL as pair_id, NULL as ang_dist FROM sirius_sources as s WHERE s.source_id NOT IN (SELECT s2.source_id FROM sirius_sources as s3 INNER JOIN sirius_sources as s2 ON q3c_join(s3.ra,s3.dec,s2.ra,s2.dec,1./3600) AND jhk_match(s3.phot_j_mag,s2.phot_j_mag,s3.phot_h_mag,s2.phot_h_mag,s3.phot_ks_mag,s2.phot_ks_mag,1.0::FLOAT) WHERE s3.source_id!=s2.source_id)