DROP TABLE IF EXISTS tmass_vvv_xmatch CASCADE;
CREATE TABLE tmass_vvv_xmatch AS
SELECT t.source_id as tmass_source_id,v.source_id as vvv_source_id, v.ra as ra, v.dec as dec, CAST('V' AS VARCHAR(1)) AS position_source,
weighted_avg(t.phot_j_mag,1/POWER(t.phot_j_mag_error,2),v.phot_j_mag,1/POWER(v.phot_j_mag_error,2)) as phot_j_mag, 
SQRT(weighted_avg_error(1/POWER(t.phot_j_mag_error,2),1/POWER(v.phot_j_mag_error,2))) as phot_j_mag_error,
weighted_avg(t.phot_h_mag,1/POWER(t.phot_h_mag_error,2),v.phot_h_mag,1/POWER(v.phot_h_mag_error,2)) as phot_h_mag, 
SQRT(weighted_avg_error(1/POWER(t.phot_h_mag_error,2),1/POWER(v.phot_h_mag_error,2))) as phot_h_mag_error,
weighted_avg(t.phot_ks_mag,1/POWER(t.phot_ks_mag_error,2),v.phot_ks_mag,1/POWER(v.phot_ks_mag_error,2)) as phot_ks_mag, 
SQRT(weighted_avg_error(1/POWER(t.phot_ks_mag_error,2),1/POWER(v.phot_ks_mag_error,2))) as phot_ks_mag_error,
t.phot_j_mag as tmass_j_mag,t.phot_h_mag as tmass_h_mag,t.phot_ks_mag as tmass_ks_mag,
t.phot_j_mag_error as tmass_j_mag_error,t.phot_h_mag_error as tmass_h_mag_error,t.phot_ks_mag_error as tmass_ks_mag_error,
t.quality_flag as tmass_quality_flag, t.rd_flg as tmass_rd_flg,
v.phot_j_mag as vvv_j_mag,v.phot_h_mag as vvv_h_mag,v.phot_ks_mag as vvv_ks_mag,
v.phot_j_mag_error as vvv_j_mag_error,v.phot_h_mag_error as vvv_h_mag_error,v.phot_ks_mag_error as vvv_ks_mag_error,
v.phot_j_flag as vvv_phot_j_flag,v.phot_h_flag as vvv_phot_h_flag,v.phot_ks_flag as vvv_phot_ks_flag
FROM vvv4_sources_clean as v INNER JOIN tmass_sources_clean as t ON q3c_join(t.ra,t.dec,v.ra,v.dec,1./3600.) AND jhk_match(CASE WHEN t.phot_j_mag_error IS NULL THEN NULL ELSE t.phot_j_mag END,v.phot_j_mag,CASE WHEN t.phot_h_mag_error IS NULL THEN NULL ELSE t.phot_h_mag END,v.phot_h_mag,CASE WHEN t.phot_ks_mag_error IS NULL THEN NULL ELSE t.phot_ks_mag END,v.phot_ks_mag,1.0::FLOAT); 

CREATE INDEX IF NOT EXISTS tmass_vvv_xmatch_tmass_sourceid
ON tmass_vvv_xmatch (tmass_source_id);
CREATE INDEX IF NOT EXISTS tmass_vvv_xmatch_vvv_sourceid
ON tmass_vvv_xmatch (vvv_source_id);



DROP TABLE IF EXISTS tmass_sirius_xmatch CASCADE;
CREATE TABLE tmass_sirius_xmatch AS
SELECT t.source_id as tmass_source_id,s.source_id as sirius_source_id, s.ra as ra, s.dec as dec, CAST('S' AS VARCHAR(1)) AS position_source,
weighted_avg(t.phot_j_mag,1/POWER(t.phot_j_mag_error,2),s.phot_j_mag,1/POWER(s.phot_j_mag_error,2)) as phot_j_mag, 
SQRT(weighted_avg_error(1/POWER(t.phot_j_mag_error,2),1/POWER(s.phot_j_mag_error,2))) as phot_j_mag_error,
weighted_avg(t.phot_h_mag,1/POWER(t.phot_h_mag_error,2),s.phot_h_mag,1/POWER(s.phot_h_mag_error,2)) as phot_h_mag,
SQRT(weighted_avg_error(1/POWER(t.phot_h_mag_error,2),1/POWER(s.phot_h_mag_error,2))) as phot_h_mag_error,
weighted_avg(t.phot_ks_mag,1/POWER(t.phot_ks_mag_error,2),s.phot_ks_mag,1/POWER(s.phot_ks_mag_error,2)) as phot_ks_mag, 
SQRT(weighted_avg_error(1/POWER(t.phot_ks_mag_error,2),1/POWER(s.phot_ks_mag_error,2))) as phot_ks_mag_error,
t.phot_j_mag as tmass_j_mag,t.phot_h_mag as tmass_h_mag,t.phot_ks_mag as tmass_ks_mag,
t.phot_j_mag_error as tmass_j_mag_error,t.phot_h_mag_error as tmass_h_mag_error,t.phot_ks_mag_error as tmass_ks_mag_error,
t.quality_flag as tmass_quality_flag, t.rd_flg as tmass_rd_flg,
s.phot_j_mag as sirius_j_mag,s.phot_h_mag as sirius_h_mag,s.phot_ks_mag as sirius_ks_mag,
s.phot_j_mag_error as sirius_j_mag_error,s.phot_h_mag_error as sirius_h_mag_error,s.phot_ks_mag_error as sirius_ks_mag_error,
s.plate_name as plate_name
FROM sirius_sources_clean as s INNER JOIN tmass_sources_clean as t ON q3c_join(t.ra,t.dec,s.ra,s.dec,1./3600.) AND jhk_match(CASE WHEN t.phot_j_mag_error IS NULL THEN NULL ELSE t.phot_j_mag END,s.phot_j_mag,CASE WHEN t.phot_h_mag_error IS NULL THEN NULL ELSE t.phot_h_mag END,s.phot_h_mag,CASE WHEN t.phot_ks_mag_error IS NULL THEN NULL ELSE t.phot_ks_mag END,s.phot_ks_mag,1.0::FLOAT); 

CREATE INDEX IF NOT EXISTS tmass_sirius_xmatch_tmass_sourceid
ON tmass_sirius_xmatch (tmass_source_id);
CREATE INDEX IF NOT EXISTS tmass_sirius_xmatch_sirius_sourceid
ON tmass_sirius_xmatch (sirius_source_id);


DROP TABLE IF EXISTS vvv_sirius_xmatch CASCADE;
CREATE TABLE vvv_sirius_xmatch AS
SELECT v.source_id as vvv_source_id,s.source_id as sirius_source_id, s.ra as ra, s.dec as dec, CAST('S' AS VARCHAR(1)) AS position_source,
weighted_avg(v.phot_j_mag,1/POWER(v.phot_j_mag_error,2),s.phot_j_mag,1/POWER(s.phot_j_mag_error,2)) as phot_j_mag, 
SQRT(weighted_avg_error(1/POWER(v.phot_j_mag_error,2),1/POWER(s.phot_j_mag_error,2))) as phot_j_mag_error,
weighted_avg(v.phot_h_mag,1/POWER(v.phot_h_mag_error,2),s.phot_h_mag,1/POWER(s.phot_h_mag_error,2)) as phot_h_mag,
SQRT(weighted_avg_error(1/POWER(v.phot_h_mag_error,2),1/POWER(s.phot_h_mag_error,2))) as phot_h_mag_error,
weighted_avg(v.phot_ks_mag,1/POWER(v.phot_ks_mag_error,2),s.phot_ks_mag,1/POWER(s.phot_ks_mag_error,2)) as phot_ks_mag, 
SQRT(weighted_avg_error(1/POWER(v.phot_ks_mag_error,2),1/POWER(s.phot_ks_mag_error,2))) as phot_ks_mag_error,
v.phot_j_mag as vvv_j_mag,v.phot_h_mag as vvv_h_mag,v.phot_ks_mag as vvv_ks_mag,
v.phot_j_mag_error as vvv_j_mag_error,v.phot_h_mag_error as vvv_h_mag_error,v.phot_ks_mag_error as vvv_ks_mag_error,
v.phot_j_flag as vvv_phot_j_flag,v.phot_h_flag as vvv_phot_h_flag,v.phot_ks_flag as vvv_phot_ks_flag,
s.phot_j_mag as sirius_j_mag,s.phot_h_mag as sirius_h_mag,s.phot_ks_mag as sirius_ks_mag,
s.phot_j_mag_error as sirius_j_mag_error,s.phot_h_mag_error as sirius_h_mag_error,s.phot_ks_mag_error as sirius_ks_mag_error,
s.plate_name as plate_name
FROM sirius_sources_clean as s INNER JOIN vvv4_sources_clean as v ON q3c_join(v.ra,v.dec,s.ra,s.dec,1./3600.) AND jhk_match(v.phot_j_mag,s.phot_j_mag,v.phot_h_mag,s.phot_h_mag,v.phot_ks_mag,s.phot_ks_mag,1.0::FLOAT); 

CREATE INDEX IF NOT EXISTS vvv_sirius_xmatch_vvv_sourceid
ON vvv_sirius_xmatch (vvv_source_id);
CREATE INDEX IF NOT EXISTS vvv_sirius_xmatch_sirius_sourceid
ON vvv_sirius_xmatch (sirius_source_id);


DROP TABLE IF EXISTS tmass_vvv_sirius_xmatch CASCADE;
CREATE TABLE tmass_vvv_sirius_xmatch AS
SELECT ts.tmass_source_id,ts.sirius_source_id,vs.vvv_source_id,ts.ra as ra, ts.dec as dec, CAST('S' AS VARCHAR(1)) AS position_source,
weighted_avg3(ts.tmass_j_mag,1/POWER(ts.tmass_j_mag_error,2),
            ts.sirius_j_mag,1/POWER(ts.sirius_j_mag_error,2),
            vs.vvv_j_mag,1/POWER(vs.vvv_j_mag_error,2)) as phot_j_mag, 
SQRT(weighted_avg_error3(1/POWER(ts.tmass_j_mag_error,2),
            1/POWER(ts.sirius_j_mag_error,2),
            1/POWER(vs.vvv_j_mag_error,2))) as phot_j_mag_error,
weighted_avg3(ts.tmass_h_mag,1/POWER(ts.tmass_h_mag_error,2),
            ts.sirius_h_mag,1/POWER(ts.sirius_h_mag_error,2),
            vs.vvv_h_mag,1/POWER(vs.vvv_h_mag_error,2)) as phot_h_mag, 
SQRT(weighted_avg_error3(1/POWER(ts.tmass_h_mag_error,2),
            1/POWER(ts.sirius_h_mag_error,2),
            1/POWER(vs.vvv_h_mag_error,2))) as phot_h_mag_error,
weighted_avg3(ts.tmass_ks_mag,1/POWER(ts.tmass_ks_mag_error,2),
            ts.sirius_ks_mag,1/POWER(ts.sirius_ks_mag_error,2),
            vs.vvv_ks_mag,1/POWER(vs.vvv_ks_mag_error,2)) as phot_ks_mag, 
SQRT(weighted_avg_error3(1/POWER(ts.tmass_ks_mag_error,2),
            1/POWER(ts.sirius_ks_mag_error,2),
            1/POWER(vs.vvv_ks_mag_error,2))) as phot_ks_mag_error
FROM vvv_sirius_xmatch as vs INNER JOIN tmass_sirius_xmatch as ts ON ts.sirius_source_id=vs.sirius_source_id;

CREATE INDEX IF NOT EXISTS tmass_vvv_sirius_xmatch_tmass_sourceid
ON tmass_vvv_sirius_xmatch (tmass_source_id);
CREATE INDEX IF NOT EXISTS tmass_vvv_sirius_xmatch_vvv_sourceid
ON tmass_vvv_sirius_xmatch (vvv_source_id);
CREATE INDEX IF NOT EXISTS tmass_vvv_sirius_xmatch_sirius_sourceid
ON tmass_vvv_sirius_xmatch (sirius_source_id);


DROP TABLE IF EXISTS tmass_vvv_sirius_xmatch_V2 CASCADE;
CREATE TABLE tmass_vvv_sirius_xmatch_V2 AS
SELECT ts.tmass_source_id,ts.sirius_source_id,vs.vvv_source_id,ts.ra as ra, ts.dec as dec, CAST('S' AS VARCHAR(1)) AS position_source,
weighted_avg3(ts.tmass_j_mag,1/POWER(ts.tmass_j_mag_error,2),
            ts.sirius_j_mag,1/POWER(ts.sirius_j_mag_error,2),
            vs.vvv_j_mag,1/POWER(vs.vvv_j_mag_error,2)) as phot_j_mag, 
SQRT(weighted_avg_error3(1/POWER(ts.tmass_j_mag_error,2),
            1/POWER(ts.sirius_j_mag_error,2),
            1/POWER(vs.vvv_j_mag_error,2))) as phot_j_mag_error,
weighted_avg3(ts.tmass_h_mag,1/POWER(ts.tmass_h_mag_error,2),
            ts.sirius_h_mag,1/POWER(ts.sirius_h_mag_error,2),
            vs.vvv_h_mag,1/POWER(vs.vvv_h_mag_error,2)) as phot_h_mag, 
SQRT(weighted_avg_error3(1/POWER(ts.tmass_h_mag_error,2),
            1/POWER(ts.sirius_h_mag_error,2),
            1/POWER(vs.vvv_h_mag_error,2))) as phot_h_mag_error,
weighted_avg3(ts.tmass_ks_mag,1/POWER(ts.tmass_ks_mag_error,2),
            ts.sirius_ks_mag,1/POWER(ts.sirius_ks_mag_error,2),
            vs.vvv_ks_mag,1/POWER(vs.vvv_ks_mag_error,2)) as phot_ks_mag, 
SQRT(weighted_avg_error3(1/POWER(ts.tmass_ks_mag_error,2),
            1/POWER(ts.sirius_ks_mag_error,2),
            1/POWER(vs.vvv_ks_mag_error,2))) as phot_ks_mag_error
FROM tmass_sirius_xmatch as ts INNER JOIN tmass_vvv_xmatch as tv ON ts.tmass_source_id=tv.tmass_source_id;