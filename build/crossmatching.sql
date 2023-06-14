DROP TABLE IF EXISTS tmass_vvv_xmatch CASCADE;
CREATE TABLE tmass_vvv_xmatch AS
SELECT t.source_id as tmass_source_id,v.source_id as vvv_source_id, (t.ra+v.ra)/2 as ra, (t.dec+v.dec)/2 as dec,
weighted_avg(t.phot_j_mag,t.phot_j_mag_error,v.phot_j_mag,v.phot_j_mag_error) as phot_j_mag, 
select_max(t.phot_j_mag_error,v.phot_j_mag_error) as phot_j_mag_error,
weighted_avg(t.phot_h_mag,t.phot_h_mag_error,v.phot_h_mag,v.phot_h_mag_error) as phot_h_mag, 
select_max(t.phot_h_mag_error,v.phot_h_mag_error) as phot_h_mag_error,
weighted_avg(t.phot_ks_mag,t.phot_ks_mag_error,v.phot_ks_mag,v.phot_ks_mag_error) as phot_ks_mag, 
select_max(t.phot_ks_mag_error,v.phot_ks_mag_error) as phot_ks_mag_error,
t.quality_flag as tmass_quality_flag, t.rd_flg as tmass_rd_flg,
v.phot_j_flag as vvv_phot_j_flag,v.phot_h_flag as vvv_phot_h_flag,v.phot_ks_flag as vvv_phot_ks_flag
FROM vvv_sources_clean as v INNER JOIN tmass_sources_clean as t ON q3c_join(t.ra,t.dec,v.ra,v.dec,1./3600.) AND jhk_match(t.phot_j_mag,v.phot_j_mag,t.phot_h_mag,v.phot_h_mag,t.phot_ks_mag,v.phot_ks_mag,1.0::FLOAT); 



--DROP TABLE IF EXISTS tmass_sirius_xmatch CASCADE;
--CREATE TABLE tmass_sirius_xmatch AS
--SELECT t.source_id as tmass_source_id,s.source_id as sirius_source_id, (t.ra+s.ra)/2 as ra, (t.dec+s.dec)/2 as dec,
--weighted_avg(t.phot_j_mag,t.phot_j_mag_error,s.phot_j_mag,s.phot_j_mag_error) as phot_j_mag, 
--select_max(t.phot_j_mag_error,s.phot_j_mag_error) as phot_j_mag_error,
--weighted_avg(t.phot_h_mag,t.phot_h_mag_error,s.phot_h_mag,s.phot_h_mag_error) as phot_h_mag, 
--select_max(t.phot_h_mag_error,s.phot_h_mag_error) as phot_h_mag_error,
--weighted_avg(t.phot_ks_mag,t.phot_ks_mag_error,s.phot_ks_mag,s.phot_ks_mag_error) as phot_ks_mag, 
--select_max(t.phot_ks_mag_error,s.phot_ks_mag_error) as phot_ks_mag_error,
--t.quality_flag as tmass_quality_flag, t.rd_flg as tmass_rd_flg,
--s.plate_name as plate_name
--FROM sirius_sources_clean as s INNER JOIN tmass_sources_clean as t ON q3c_join(t.ra,t.dec,s.ra,s.dec,1./3600.) AND jhk_match(t.phot_j_mag,s.phot_j_mag,t.phot_h_mag,s.phot_h_mag,t.phot_ks_mag,s.phot_ks_mag,1.0::FLOAT); 