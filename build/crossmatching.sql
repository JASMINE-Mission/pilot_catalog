-- 2MASSxVVV
DROP TABLE IF EXISTS tmass_vvv_xmatch CASCADE;
CREATE TABLE tmass_vvv_xmatch (
    xmatch_source_id    BIGSERIAL PRIMARY KEY,
    tmass_source_id     BIGINT NOT NULL,
    vvv_source_id       BIGINT NOT NULL,
    ra                  FLOAT NOT NULL,
    dec                 FLOAT NOT NULL,
    position_source     VARCHAR(1) NOT NULL,
    phot_j_mag          FLOAT,
    phot_j_mag_error    FLOAT,
    phot_h_mag          FLOAT,
    phot_h_mag_error    FLOAT,
    phot_ks_mag         FLOAT,
    phot_ks_mag_error   FLOAT,
    tmass_j_mag         FLOAT,
    tmass_h_mag         FLOAT,
    tmass_ks_mag        FLOAT,
    tmass_j_mag_error   FLOAT,
    tmass_h_mag_error   FLOAT,
    tmass_ks_mag_error  FLOAT,
    vvv_j_mag           FLOAT,
    vvv_h_mag           FLOAT,
    vvv_ks_mag          FLOAT,
    vvv_j_mag_error     FLOAT,
    vvv_h_mag_error     FLOAT,
    vvv_ks_mag_error    FLOAT,
    separation          FLOAT
);

ALTER TABLE tmass_vvv_xmatch ADD CONSTRAINT
  FK_tmass_vvv_xmatch_tmass_id FOREIGN KEY (tmass_source_id)
  REFERENCES tmass_sources_clean (source_id) ON DELETE CASCADE;
ALTER TABLE tmass_vvv_xmatch ADD CONSTRAINT
  FK_tmass_vvv_xmatch_vvv_id FOREIGN KEY (vvv_source_id)
  REFERENCES vvv4_sources_clean (source_id) ON DELETE CASCADE;

-- Ignore any 2MASS magnitude band if it is brighter than 12 (VVV is saturated). For the bright, ignore magnitudes of VVV
INSERT INTO tmass_vvv_xmatch
SELECT nextval('tmass_vvv_xmatch_xmatch_source_id_seq') AS xmatch_source_id,t.source_id as tmass_source_id,v.source_id as vvv_source_id, v.ra as ra, v.dec as dec, CAST('V' AS VARCHAR(1)) AS position_source,
CASE WHEN t.phot_j_mag<=12 THEN t.phot_j_mag ELSE  weighted_avg(t.phot_j_mag,1/POWER(t.phot_j_mag_error,2),v.phot_j_mag,1/POWER(v.phot_j_mag_error,2)) END as phot_j_mag, 
CASE WHEN t.phot_j_mag<=12 THEN t.phot_j_mag_error ELSE SQRT(weighted_avg_error(1/POWER(t.phot_j_mag_error,2),1/POWER(v.phot_j_mag_error,2))) END as phot_j_mag_error,
CASE WHEN t.phot_h_mag<=12 THEN t.phot_h_mag ELSE weighted_avg(t.phot_h_mag,1/POWER(t.phot_h_mag_error,2),v.phot_h_mag,1/POWER(v.phot_h_mag_error,2)) END as phot_h_mag, 
CASE WHEN t.phot_h_mag<=12 THEN t.phot_h_mag_error ELSE SQRT(weighted_avg_error(1/POWER(t.phot_h_mag_error,2),1/POWER(v.phot_h_mag_error,2))) END as phot_h_mag_error,
CASE WHEN t.phot_ks_mag<=12 THEN t.phot_ks_mag ELSE weighted_avg(t.phot_ks_mag,1/POWER(t.phot_ks_mag_error,2),v.phot_ks_mag,1/POWER(v.phot_ks_mag_error,2)) END as phot_ks_mag, 
CASE WHEN t.phot_ks_mag<=12 THEN t.phot_ks_mag_error ELSE SQRT(weighted_avg_error(1/POWER(t.phot_ks_mag_error,2),1/POWER(v.phot_ks_mag_error,2))) END as phot_ks_mag_error,
t.phot_j_mag as tmass_j_mag,t.phot_h_mag as tmass_h_mag,t.phot_ks_mag as tmass_ks_mag,
t.phot_j_mag_error as tmass_j_mag_error,t.phot_h_mag_error as tmass_h_mag_error,t.phot_ks_mag_error as tmass_ks_mag_error,
v.phot_j_mag as vvv_j_mag,v.phot_h_mag as vvv_h_mag,v.phot_ks_mag as vvv_ks_mag,
v.phot_j_mag_error as vvv_j_mag_error,v.phot_h_mag_error as vvv_h_mag_error,v.phot_ks_mag_error as vvv_ks_mag_error,
q3c_dist(t.ra,t.dec,v.ra,v.dec)*3600. as separation
FROM vvv4_sources_clean as v INNER JOIN tmass_sources_clean as t ON q3c_join(t.ra,t.dec,v.ra,v.dec,1./3600.)  AND jhk_match(v.phot_j_mag,CASE WHEN t.phot_j_mag_error IS NULL THEN NULL ELSE NULLIF(GREATEST(t.phot_j_mag,12),12) END,v.phot_h_mag,CASE WHEN t.phot_h_mag_error IS NULL THEN NULL ELSE NULLIF(GREATEST(t.phot_h_mag,12),12) END, v.phot_ks_mag,CASE WHEN t.phot_ks_mag_error IS NULL THEN NULL ELSE NULLIF(GREATEST(t.phot_ks_mag,12),12) END,1.0::FLOAT); 

CREATE INDEX IF NOT EXISTS tmass_vvv_xmatch_tmass_sourceid
ON tmass_vvv_xmatch (tmass_source_id);
CREATE INDEX IF NOT EXISTS tmass_vvv_xmatch_vvv_sourceid
ON tmass_vvv_xmatch (vvv_source_id);


-- 2MASSxSIRIUS
DROP TABLE IF EXISTS tmass_sirius_xmatch CASCADE;
CREATE TABLE tmass_sirius_xmatch (
    xmatch_source_id       BIGSERIAL PRIMARY KEY,
    tmass_source_id        BIGINT NOT NULL,
    sirius_source_id       BIGINT NOT NULL,
    ra                     FLOAT NOT NULL,
    dec                    FLOAT NOT NULL,
    position_source        VARCHAR(1) NOT NULL,
    phot_j_mag             FLOAT,
    phot_j_mag_error       FLOAT,
    phot_h_mag             FLOAT,
    phot_h_mag_error       FLOAT,
    phot_ks_mag            FLOAT,
    phot_ks_mag_error      FLOAT,
    tmass_j_mag            FLOAT,
    tmass_h_mag            FLOAT,
    tmass_ks_mag           FLOAT,
    tmass_j_mag_error      FLOAT,
    tmass_h_mag_error      FLOAT,
    tmass_ks_mag_error     FLOAT,
    sirius_j_mag           FLOAT,
    sirius_h_mag           FLOAT,
    sirius_ks_mag          FLOAT,
    sirius_j_mag_error     FLOAT,
    sirius_h_mag_error     FLOAT,
    sirius_ks_mag_error    FLOAT,
    separation             FLOAT
);

ALTER TABLE tmass_sirius_xmatch ADD CONSTRAINT
  FK_tmass_sirius_xmatch_tmass_id FOREIGN KEY (tmass_source_id)
  REFERENCES tmass_sources_clean (source_id) ON DELETE CASCADE;
ALTER TABLE tmass_sirius_xmatch ADD CONSTRAINT
  FK_tmass_sirius_xmatch_sirius_id FOREIGN KEY (sirius_source_id)
  REFERENCES sirius_sources_clean (source_id) ON DELETE CASCADE;



INSERT INTO tmass_sirius_xmatch
SELECT nextval('tmass_sirius_xmatch_xmatch_source_id_seq') AS xmatch_source_id,t.source_id as tmass_source_id,s.source_id as sirius_source_id, s.ra as ra, s.dec as dec, CAST('S' AS VARCHAR(1)) AS position_source,
weighted_avg(t.phot_j_mag,1/POWER(t.phot_j_mag_error,2),s.phot_j_mag,1/POWER(s.phot_j_mag_error,2)) as phot_j_mag, 
SQRT(weighted_avg_error(1/POWER(t.phot_j_mag_error,2),1/POWER(s.phot_j_mag_error,2))) as phot_j_mag_error,
weighted_avg(t.phot_h_mag,1/POWER(t.phot_h_mag_error,2),s.phot_h_mag,1/POWER(s.phot_h_mag_error,2)) as phot_h_mag,
SQRT(weighted_avg_error(1/POWER(t.phot_h_mag_error,2),1/POWER(s.phot_h_mag_error,2))) as phot_h_mag_error,
weighted_avg(t.phot_ks_mag,1/POWER(t.phot_ks_mag_error,2),s.phot_ks_mag,1/POWER(s.phot_ks_mag_error,2)) as phot_ks_mag, 
SQRT(weighted_avg_error(1/POWER(t.phot_ks_mag_error,2),1/POWER(s.phot_ks_mag_error,2))) as phot_ks_mag_error,
t.phot_j_mag as tmass_j_mag,t.phot_h_mag as tmass_h_mag,t.phot_ks_mag as tmass_ks_mag,
t.phot_j_mag_error as tmass_j_mag_error,t.phot_h_mag_error as tmass_h_mag_error,t.phot_ks_mag_error as tmass_ks_mag_error,
s.phot_j_mag as sirius_j_mag,s.phot_h_mag as sirius_h_mag,s.phot_ks_mag as sirius_ks_mag,
s.phot_j_mag_error as sirius_j_mag_error,s.phot_h_mag_error as sirius_h_mag_error,s.phot_ks_mag_error as sirius_ks_mag_error,
q3c_dist(t.ra,t.dec,s.ra,s.dec)*3600. as separation
FROM sirius_sources_clean as s INNER JOIN tmass_sources_clean as t ON q3c_join(t.ra,t.dec,s.ra,s.dec,1./3600.) AND jhk_match(CASE WHEN t.phot_j_mag_error IS NULL THEN NULL ELSE t.phot_j_mag END,s.phot_j_mag,CASE WHEN t.phot_h_mag_error IS NULL THEN NULL ELSE t.phot_h_mag END,s.phot_h_mag,CASE WHEN t.phot_ks_mag_error IS NULL THEN NULL ELSE t.phot_ks_mag END,s.phot_ks_mag,1.0::FLOAT); 

CREATE INDEX IF NOT EXISTS tmass_sirius_xmatch_tmass_sourceid
ON tmass_sirius_xmatch (tmass_source_id);
CREATE INDEX IF NOT EXISTS tmass_sirius_xmatch_sirius_sourceid
ON tmass_sirius_xmatch (sirius_source_id);



-- VVVxSIRIUS
DROP TABLE IF EXISTS vvv_sirius_xmatch CASCADE;
CREATE TABLE vvv_sirius_xmatch (
    xmatch_source_id       BIGSERIAL PRIMARY KEY,
    vvv_source_id          BIGINT NOT NULL,
    sirius_source_id       BIGINT NOT NULL,
    ra                     FLOAT NOT NULL,
    dec                    FLOAT NOT NULL,
    position_source        VARCHAR(1) NOT NULL,
    phot_j_mag             FLOAT,
    phot_j_mag_error       FLOAT,
    phot_h_mag             FLOAT,
    phot_h_mag_error       FLOAT,
    phot_ks_mag            FLOAT,
    phot_ks_mag_error      FLOAT,
    vvv_j_mag              FLOAT,
    vvv_h_mag              FLOAT,
    vvv_ks_mag             FLOAT,
    vvv_j_mag_error        FLOAT,
    vvv_h_mag_error        FLOAT,
    vvv_ks_mag_error       FLOAT,
    sirius_j_mag           FLOAT,
    sirius_h_mag           FLOAT,
    sirius_ks_mag          FLOAT,
    sirius_j_mag_error     FLOAT,
    sirius_h_mag_error     FLOAT,
    sirius_ks_mag_error    FLOAT,
    separation             FLOAT
);

ALTER TABLE vvv_sirius_xmatch ADD CONSTRAINT
  FK_vvv_sirius_xmatch_vvv_id FOREIGN KEY (vvv_source_id)
  REFERENCES vvv4_sources_clean (source_id) ON DELETE CASCADE;
ALTER TABLE vvv_sirius_xmatch ADD CONSTRAINT
  FK_vvv_sirius_xmatch_sirius_id FOREIGN KEY (sirius_source_id)
  REFERENCES sirius_sources_clean (source_id) ON DELETE CASCADE;


-- Ignore any SIRIUS magnitude band if it is brighter than 12 (VVV is saturated). For the bright, ignore magnitudes of VVV.
INSERT INTO vvv_sirius_xmatch
SELECT nextval('vvv_sirius_xmatch_xmatch_source_id_seq') AS xmatch_source_id,v.source_id as vvv_source_id,s.source_id as sirius_source_id, s.ra as ra, s.dec as dec, CAST('S' AS VARCHAR(1)) AS position_source,
CASE WHEN s.phot_j_mag<=12 THEN s.phot_j_mag ELSE weighted_avg(v.phot_j_mag,1/POWER(v.phot_j_mag_error,2),s.phot_j_mag,1/POWER(s.phot_j_mag_error,2)) END as phot_j_mag, 
CASE WHEN s.phot_j_mag<=12 THEN s.phot_j_mag_error ELSE SQRT(weighted_avg_error(1/POWER(v.phot_j_mag_error,2),1/POWER(s.phot_j_mag_error,2))) END as phot_j_mag_error,
CASE WHEN s.phot_h_mag<=12 THEN s.phot_h_mag ELSE weighted_avg(v.phot_h_mag,1/POWER(v.phot_h_mag_error,2),s.phot_h_mag,1/POWER(s.phot_h_mag_error,2)) END as phot_h_mag,
CASE WHEN s.phot_h_mag<=12 THEN s.phot_h_mag_error ELSE SQRT(weighted_avg_error(1/POWER(v.phot_h_mag_error,2),1/POWER(s.phot_h_mag_error,2))) END as phot_h_mag_error,
CASE WHEN s.phot_ks_mag<=12 THEN s.phot_ks_mag ELSE weighted_avg(v.phot_ks_mag,1/POWER(v.phot_ks_mag_error,2),s.phot_ks_mag,1/POWER(s.phot_ks_mag_error,2)) END as phot_ks_mag, 
CASE WHEN s.phot_ks_mag<=12 THEN s.phot_ks_mag_error ELSE SQRT(weighted_avg_error(1/POWER(v.phot_ks_mag_error,2),1/POWER(s.phot_ks_mag_error,2))) END as phot_ks_mag_error,
v.phot_j_mag as vvv_j_mag,v.phot_h_mag as vvv_h_mag,v.phot_ks_mag as vvv_ks_mag,
v.phot_j_mag_error as vvv_j_mag_error,v.phot_h_mag_error as vvv_h_mag_error,v.phot_ks_mag_error as vvv_ks_mag_error,
s.phot_j_mag as sirius_j_mag,s.phot_h_mag as sirius_h_mag,s.phot_ks_mag as sirius_ks_mag,
s.phot_j_mag_error as sirius_j_mag_error,s.phot_h_mag_error as sirius_h_mag_error,s.phot_ks_mag_error as sirius_ks_mag_error,
q3c_dist(s.ra,s.dec,v.ra,v.dec)*3600. as separation
FROM sirius_sources_clean as s INNER JOIN vvv4_sources_clean as v ON q3c_join(s.ra,s.dec,v.ra,v.dec,1./3600.) AND jhk_match(v.phot_j_mag,NULLIF(GREATEST(s.phot_j_mag,12),12),v.phot_h_mag,NULLIF(GREATEST(s.phot_h_mag,12),12), v.phot_ks_mag,NULLIF(GREATEST(s.phot_ks_mag,12),12),1.0::FLOAT);

CREATE INDEX IF NOT EXISTS vvv_sirius_xmatch_vvv_sourceid
ON vvv_sirius_xmatch (vvv_source_id);
CREATE INDEX IF NOT EXISTS vvv_sirius_xmatch_sirius_sourceid
ON vvv_sirius_xmatch (sirius_source_id);



-- Three way crossmatch: ignore VVV for bright mags
DROP TABLE IF EXISTS tmass_vvv_sirius_xmatch CASCADE;
CREATE TABLE tmass_vvv_sirius_xmatch AS
SELECT ts.tmass_source_id,ts.sirius_source_id,vs.vvv_source_id,ts.ra as ra, ts.dec as dec, CAST('S' AS VARCHAR(1)) AS position_source,
CASE WHEN ts.tmass_j_mag<=12 OR ts.sirius_j_mag<=12 THEN ts.phot_j_mag ELSE weighted_avg3(ts.tmass_j_mag,1/POWER(ts.tmass_j_mag_error,2),ts.sirius_j_mag,1/POWER(ts.sirius_j_mag_error,2),vs.vvv_j_mag,1/POWER(vs.vvv_j_mag_error,2)) END as phot_j_mag, 
CASE WHEN ts.tmass_j_mag<=12 OR ts.sirius_j_mag<=12 THEN ts.phot_j_mag_error ELSE SQRT(weighted_avg_error3(1/POWER(ts.tmass_j_mag_error,2),1/POWER(ts.sirius_j_mag_error,2),1/POWER(vs.vvv_j_mag_error,2))) END as phot_j_mag_error,
CASE WHEN ts.tmass_h_mag<=12 OR ts.sirius_h_mag<=12 THEN ts.phot_h_mag ELSE weighted_avg3(ts.tmass_h_mag,1/POWER(ts.tmass_h_mag_error,2),ts.sirius_h_mag,1/POWER(ts.sirius_h_mag_error,2),vs.vvv_h_mag,1/POWER(vs.vvv_h_mag_error,2)) END as phot_h_mag, 
CASE WHEN ts.tmass_h_mag<=12 OR ts.sirius_h_mag<=12 THEN ts.phot_h_mag_error ELSE SQRT(weighted_avg_error3(1/POWER(ts.tmass_h_mag_error,2),1/POWER(ts.sirius_h_mag_error,2),1/POWER(vs.vvv_h_mag_error,2))) END as phot_h_mag_error,
CASE WHEN ts.tmass_ks_mag<=12 OR ts.sirius_ks_mag<=12 THEN ts.phot_ks_mag ELSE weighted_avg3(ts.tmass_ks_mag,1/POWER(ts.tmass_ks_mag_error,2),ts.sirius_ks_mag,1/POWER(ts.sirius_ks_mag_error,2),vs.vvv_ks_mag,1/POWER(vs.vvv_ks_mag_error,2)) END as phot_ks_mag, 
CASE WHEN ts.tmass_ks_mag<=12 OR ts.sirius_ks_mag<=12 THEN ts.phot_ks_mag_error ELSE SQRT(weighted_avg_error3(1/POWER(ts.tmass_ks_mag_error,2),1/POWER(ts.sirius_ks_mag_error,2),1/POWER(vs.vvv_ks_mag_error,2))) END as phot_ks_mag_error,
ts.xmatch_source_id as tmass_x_sirius_id,
vs.xmatch_source_id as vvv_x_sirius_id,
tv.xmatch_source_id as tmass_x_vvv_id
FROM vvv_sirius_xmatch as vs INNER JOIN tmass_sirius_xmatch as ts ON ts.sirius_source_id=vs.sirius_source_id
INNER JOIN tmass_vvv_xmatch as tv ON tv.vvv_source_id = vs.vvv_source_id
WHERE tv.tmass_source_id = ts.tmass_source_id;

