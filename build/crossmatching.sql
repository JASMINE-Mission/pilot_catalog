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
FROM vvv_sources_clean as v INNER JOIN tmass_sources_clean as t ON q3c_join(t.ra,t.dec,v.ra,v.dec,1./3600.) AND jhk_match(CASE WHEN t.phot_j_mag_error IS NULL THEN NULL ELSE t.phot_j_mag END,v.phot_j_mag,CASE WHEN t.phot_h_mag_error IS NULL THEN NULL ELSE t.phot_h_mag END,v.phot_h_mag,CASE WHEN t.phot_ks_mag_error IS NULL THEN NULL ELSE t.phot_ks_mag END,v.phot_ks_mag,1.0::FLOAT); 

CREATE INDEX IF NOT EXISTS tmass_vvv_xmatch_tmass_sourceid
ON tmass_vvv_xmatch (tmass_source_id);
CREATE INDEX IF NOT EXISTS tmass_vvv_xmatch_vvv_sourceid
ON tmass_vvv_xmatch (vvv_source_id);



DROP TABLE IF EXISTS tmass_sirius_xmatch CASCADE;
CREATE TABLE tmass_sirius_xmatch AS
SELECT t.source_id as tmass_source_id,s.source_id as sirius_source_id, (t.ra+s.ra)/2 as ra, (t.dec+s.dec)/2 as dec,
weighted_avg(t.phot_j_mag,t.phot_j_mag_error,s.phot_j_mag,s.phot_j_mag_error) as phot_j_mag, 
select_max(t.phot_j_mag_error,s.phot_j_mag_error) as phot_j_mag_error,
weighted_avg(t.phot_h_mag,t.phot_h_mag_error,s.phot_h_mag,s.phot_h_mag_error) as phot_h_mag,
select_max(t.phot_h_mag_error,s.phot_h_mag_error) as phot_h_mag_error,
weighted_avg(t.phot_ks_mag,t.phot_ks_mag_error,s.phot_ks_mag,s.phot_ks_mag_error) as phot_ks_mag, 
select_max(t.phot_ks_mag_error,s.phot_ks_mag_error) as phot_ks_mag_error,
t.quality_flag as tmass_quality_flag, t.rd_flg as tmass_rd_flg,
s.plate_name as plate_name
FROM sirius_sources_clean as s INNER JOIN tmass_sources_clean as t ON q3c_join(t.ra,t.dec,s.ra,s.dec,1./3600.) AND jhk_match(CASE WHEN t.phot_j_mag_error IS NULL THEN NULL ELSE t.phot_j_mag END,s.phot_j_mag,CASE WHEN t.phot_h_mag_error IS NULL THEN NULL ELSE t.phot_h_mag END,s.phot_h_mag,CASE WHEN t.phot_ks_mag_error IS NULL THEN NULL ELSE t.phot_ks_mag END,s.phot_ks_mag,1.0::FLOAT); 

CREATE INDEX IF NOT EXISTS tmass_sirius_xmatch_tmass_sourceid
ON tmass_sirius_xmatch (tmass_source_id);
CREATE INDEX IF NOT EXISTS tmass_sirius_xmatch_sirius_sourceid
ON tmass_sirius_xmatch (sirius_source_id);


DROP TABLE IF EXISTS vvv_sirius_xmatch CASCADE;
CREATE TABLE vvv_sirius_xmatch AS
SELECT v.source_id as vvv_source_id,s.source_id as sirius_source_id, (v.ra+s.ra)/2 as ra, (v.dec+s.dec)/2 as dec,
weighted_avg(v.phot_j_mag,v.phot_j_mag_error,s.phot_j_mag,s.phot_j_mag_error) as phot_j_mag, 
select_max(v.phot_j_mag_error,s.phot_j_mag_error) as phot_j_mag_error,
weighted_avg(v.phot_h_mag,v.phot_h_mag_error,s.phot_h_mag,s.phot_h_mag_error) as phot_h_mag,
select_max(v.phot_h_mag_error,s.phot_h_mag_error) as phot_h_mag_error,
weighted_avg(v.phot_ks_mag,v.phot_ks_mag_error,s.phot_ks_mag,s.phot_ks_mag_error) as phot_ks_mag, 
select_max(v.phot_ks_mag_error,s.phot_ks_mag_error) as phot_ks_mag_error,
v.phot_j_flag as vvv_phot_j_flag,v.phot_h_flag as vvv_phot_h_flag,v.phot_ks_flag as vvv_phot_ks_flag,
s.plate_name as plate_name
FROM sirius_sources_clean as s INNER JOIN vvv_sources_clean as v ON q3c_join(v.ra,v.dec,s.ra,s.dec,1./3600.) AND jhk_match(v.phot_j_mag,s.phot_j_mag,v.phot_h_mag,s.phot_h_mag,v.phot_ks_mag,s.phot_ks_mag,1.0::FLOAT); 

CREATE INDEX IF NOT EXISTS vvv_sirius_xmatch_vvv_sourceid
ON vvv_sirius_xmatch (vvv_source_id);
CREATE INDEX IF NOT EXISTS vvv_sirius_xmatch_sirius_sourceid
ON vvv_sirius_xmatch (sirius_source_id);


DROP TABLE IF EXISTS tmass_vvv_sirius_xmatch CASCADE;
CREATE TABLE tmass_vvv_sirius_xmatch AS
SELECT ts.tmass_source_id,ts.sirius_source_id,vs.vvv_source_id,(ts.ra+vs.ra)/2 as ra, (ts.dec+vs.dec)/2 as dec,
weighted_avg(ts.phot_j_mag,ts.phot_j_mag_error,vs.phot_j_mag,vs.phot_j_mag_error) as phot_j_mag, 
select_max(ts.phot_j_mag_error,vs.phot_j_mag_error) as phot_j_mag_error,
weighted_avg(ts.phot_h_mag,ts.phot_h_mag_error,vs.phot_h_mag,vs.phot_h_mag_error) as phot_h_mag,
select_max(ts.phot_h_mag_error,vs.phot_h_mag_error) as phot_h_mag_error,
weighted_avg(ts.phot_ks_mag,ts.phot_ks_mag_error,vs.phot_ks_mag,vs.phot_ks_mag_error) as phot_ks_mag, 
select_max(ts.phot_ks_mag_error,vs.phot_ks_mag_error) as phot_ks_mag_error
FROM vvv_sirius_xmatch as vs INNER JOIN tmass_sirius_xmatch as ts ON ts.sirius_source_id=vs.sirius_source_id;

CREATE INDEX IF NOT EXISTS tmass_vvv_sirius_xmatch_tmass_sourceid
ON tmass_vvv_sirius_xmatch (tmass_source_id);
CREATE INDEX IF NOT EXISTS tmass_vvv_sirius_xmatch_vvv_sourceid
ON tmass_vvv_sirius_xmatch (vvv_source_id);
CREATE INDEX IF NOT EXISTS tmass_vvv_sirius_xmatch_sirius_sourceid
ON tmass_vvv_sirius_xmatch (sirius_source_id);