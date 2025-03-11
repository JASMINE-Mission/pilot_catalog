-- VIRAC v2: just remove sources around (8") 2MASS bright sources (Ks mag <= 10) with bad astrometric solutions (uwe>1) => done offline with TOPCAT because it was x30 times faster.


DROP TABLE IF EXISTS virac2_ks16_clean CASCADE;
CREATE TABLE virac2_ks16_clean (
  source_id          BIGINT PRIMARY KEY,
  glon               FLOAT NOT NULL,
  glat               FLOAT NOT NULL,
  ra                 FLOAT NOT NULL,
  dec                FLOAT NOT NULL,
  phot_hw_mag         FLOAT,
  phot_hw_mag_error   FLOAT,
  phot_z_mag         FLOAT,
  phot_z_mag_error   FLOAT,
  phot_z_n_epochs    INTEGER,
  phot_y_mag         FLOAT,
  phot_y_mag_error   FLOAT,
  phot_y_n_epochs    INTEGER,
  phot_j_mag         FLOAT,
  phot_j_mag_error   FLOAT,
  phot_j_n_epochs    INTEGER,
  phot_h_mag         FLOAT,
  phot_h_mag_error   FLOAT,
  phot_h_n_epochs    INTEGER,
  phot_ks_mag        FLOAT,
  phot_ks_mag_error  FLOAT,
  phot_ks_n_epochs   INTEGER,
  parallax           FLOAT,
  parallax_error     FLOAT,
  pmra               FLOAT,
  pmra_error         FLOAT,
  pmdec              FLOAT,
  pmdec_error        FLOAT,
  parallax_pmra_corr FLOAT,
  parallax_pmdec_corr FLOAT,
  pmra_pmdec_corr    FLOAT,
  ref_epoch          FLOAT,
  astfit_epochs       INTEGER,
  astfit_params       INTEGER,
  uwe                FLOAT
);

INSERT INTO virac2_ks16_clean
SELECT v.source_id,compute_glon(v.ra,v.dec) as glon,compute_glat(v.ra,v.dec) as glat ,v.ra,v.dec,
compute_hw_VVV(v.phot_j_mean_mag,v.phot_h_mean_mag) as phot_hw_mag,
compute_hw_error_VVV(v.phot_j_mean_mag,v.phot_j_std_mag,v.phot_h_mean_mag,v.phot_h_std_mag) as phot_hw_mag_error,
v.phot_z_mean_mag,phot_z_std_mag,v.phot_z_n_epochs,
v.phot_y_mean_mag,phot_y_std_mag,v.phot_y_n_epochs,
v.phot_j_mean_mag,CASE IF phot_j_std_mag<=0 THEN 0.077 ELSE phot_j_std_mag END,v.phot_j_n_epochs,
v.phot_h_mean_mag,CASE IF phot_h_std_mag<=0 THEN 0.075 ELSE phot_h_std_mag END,v.phot_h_n_epochs,
v.phot_ks_mean_mag,CASE IF phot_ks_std_mag<=0 THEN 0.095 ELSE phot_ks_std_mag END,v.phot_ks_n_epochs,
v.parallax,v.parallax_error,v.pmra,v.pmra_error,v.pmdec,
v.pmdec_error,v.parallax_pmra_corr,v.parallax_pmdec_corr,
v.pmra_pmdec_corr,v.ref_epoch,v.astfit_epochs,v.astfit_params,v.uwe
FROM virac2_ks16 as v WHERE v.source_id NOT IN (SELECT v2.source_id FROM virac2_ks16_bad AS v2);


CREATE INDEX IF NOT EXISTS virac2_ks16_clean_sourceid
  ON virac2_ks16_clean (source_id);
CREATE INDEX IF NOT EXISTS virac2_ks16_clean_glonglat
  ON virac2_ks16_clean (q3c_ang2ipix(glon,glat));
CREATE INDEX IF NOT EXISTS virac2_ks16_clean_radec
  ON virac2_ks16_clean (q3c_ang2ipix(ra,dec));
CREATE INDEX IF NOT EXISTS virac2_ks16_clean_jmag
  ON virac2_ks16_clean (phot_j_mag);
CREATE INDEX IF NOT EXISTS virac2_ks16_clean_hmag
  ON virac2_ks16_clean (phot_h_mag);
CREATE INDEX IF NOT EXISTS virac2_ks16_clean_ksmag
  ON virac2_ks16_clean (phot_ks_mag);
CREATE INDEX IF NOT EXISTS virac2_ks16_clean_glon
  ON virac2_ks16_clean (glon);
CREATE INDEX IF NOT EXISTS virac2_ks16_clean_glat
  ON virac2_ks16_clean (glat);
CREATE INDEX IF NOT EXISTS virac2_ks16_clean_ra
  ON virac2_ks16_clean (ra);
CREATE INDEX IF NOT EXISTS virac2_ks16_clean_dec
  ON virac2_ks16_clean (dec);
CLUSTER virac2_ks16_clean_radec ON virac2_ks16_clean;
ANALYZE virac2_ks16_clean;

-- DROP TABLE IF EXISTS virac2_bad_sources CASCADE;

DROP TABLE IF EXISTS vvv_virac_common CASCADE;
CREATE TABLE vvv_virac_common (
  source_id          BIGSERIAL PRIMARY KEY,
  glon               FLOAT,
  glat               FLOAT,
  ra                 FLOAT,
  dec                FLOAT,
  parallax           FLOAT,
  parallax_error     FLOAT,
  pmra               FLOAT,
  pmra_error         FLOAT,
  pmdec              FLOAT,
  pmdec_error        FLOAT,
  uwe                FLOAT,
  phot_hw_mag        FLOAT,
  phot_hw_mag_error  FLOAT,
  phot_z_mag         FLOAT,
  phot_z_mag_error   FLOAT,
  phot_y_mag         FLOAT,
  phot_y_mag_error   FLOAT,
  phot_j_mag         FLOAT,
  phot_j_mag_error   FLOAT,
  phot_h_mag         FLOAT,
  phot_h_mag_error   FLOAT,
  phot_ks_mag        FLOAT,
  phot_ks_mag_error  FLOAT,
  astfit_epochs      INTEGER,
  astfit_params      INTEGER,
  ref_epoch          FLOAT,
  vvv_source_id1     BIGINT,
  vvv_source_id2     BIGINT,
  vvv_source_ids     VARCHAR(200),
  avg_class          FLOAT,
  max_class          INTEGER,
  Var                INTEGER,
  n_matches          INTEGER
);

ALTER TABLE vvv_virac_common ADD CONSTRAINT
  FK_vvv_virac_id FOREIGN KEY (source_id)
  REFERENCES virac2_ks16_clean (source_id) ON DELETE CASCADE;


INSERT INTO vvv_virac_common
SELECT source_id,MIN(glon) as glon,MIN(glat) as glat,MIN(ra) as ra,MIN(dec) as dec,
MIN(parallax) as parallax,MIN(parallax_error) as parallax_error,
MIN(pmra) as pmra,MIN(pmra_error) as pmra_error,MIN(pmdec) as pmdec,MIN(pmdec_error) as pmdec_error,MIN(uwe) as uwe,
  MIN(phot_hw_mag) as phot_hw_mag,MIN(phot_hw_mag_error) as phot_hw_mag_error,
  MIN(phot_z_mag) as phot_z_mag,MIN(phot_z_mag_error) as phot_z_mag_error,
  MIN(phot_y_mag) as phot_y_mag,MIN(phot_y_mag_error) as phot_y_mag_error,
  MIN(phot_j_mag) as phot_j_mag,MIN(phot_j_mag_error) as phot_j_mag_error,
  MIN(phot_h_mag) as phot_h_mag,MIN(phot_h_mag_error) as phot_h_mag_error,
  MIN(phot_ks_mag)as phot_ks_mag,MIN(phot_ks_mag_error)as phot_ks_mag_error,
  MIN(astfit_epochs) as astfit_epochs,MIN(astfit_params) as astfit_params,MIN(ref_epoch) as ref_epoch,
  MIN(aux.vvv_sid) as vvv_source_id1,MAX(aux.vvv_sid) as vvv_source_id2,STRING_AGG(aux.vvv_sid_char,'-') as vvv_source_ids, AVG(Cl) as avg_class, MAX(Cl) as max_class, MAX(Var) as Var, COUNT(*) as n_matches
 FROM (SELECT v2.*,v.source_id as vvv_sid,CAST(v.source_id AS varchar) as vvv_sid_char,v.Cl,v.Var FROM (SELECT source_id,Cl,Var,ra,dec FROM vvv42_sources_full_clean WHERE phot_ks_mag<18) as v INNER JOIN virac2_ks16_clean as v2 ON q3c_join(v.ra,v.dec,v2.ra,v2.dec,.5/3600.) ) as aux GROUP BY source_id;

CREATE INDEX IF NOT EXISTS vvv_virac_common_radec
  ON vvv_virac_common (q3c_ang2ipix(ra,dec));
CREATE INDEX IF NOT EXISTS vvv_virac_common_glonglat
  ON vvv_virac_common (q3c_ang2ipix(glon,glat));
CREATE INDEX IF NOT EXISTS vvv_virac_common_hwmag
  ON vvv_virac_common (phot_hw_mag);
CREATE INDEX IF NOT EXISTS vvv_virac_common_jmag
  ON vvv_virac_common (phot_j_mag);
CREATE INDEX IF NOT EXISTS vvv_virac_common_hmag
  ON vvv_virac_common (phot_h_mag);
CREATE INDEX IF NOT EXISTS vvv_virac_common_ksmag
  ON vvv_virac_common (phot_ks_mag);
CREATE INDEX IF NOT EXISTS vvv_virac_common_ra
  ON vvv_virac_common (ra);
CREATE INDEX IF NOT EXISTS vvv_virac_common_dec
  ON vvv_virac_common (dec);
CREATE INDEX IF NOT EXISTS vvv_virac_common_glon
  ON vvv_virac_common (glon);
CREATE INDEX IF NOT EXISTS vvv_virac_common_glat
  ON vvv_virac_common (glat);
CREATE INDEX IF NOT EXISTS vvv_virac_common_vvv1
  ON vvv_virac_common (vvv_source_id1);
CREATE INDEX IF NOT EXISTS vvv_virac_common_vvv2
  ON vvv_virac_common (vvv_source_id2);
CLUSTER vvv_virac_common_glonglat ON vvv_virac_common;
ANALYZE vvv_virac_common;



DROP TABLE IF EXISTS vvv_virac CASCADE;
CREATE TABLE vvv_virac (
  source_id          BIGSERIAL PRIMARY KEY,
  glon               FLOAT,
  glat               FLOAT,
  ra                 FLOAT,
  dec                FLOAT,
  phot_hw_mag        FLOAT,
  phot_hw_mag_error  FLOAT,
  phot_z_mag         FLOAT,
  phot_z_mag_error   FLOAT,
  phot_y_mag         FLOAT,
  phot_y_mag_error   FLOAT,
  phot_j_mag         FLOAT,
  phot_j_mag_error   FLOAT,
  phot_h_mag         FLOAT,
  phot_h_mag_error   FLOAT,
  phot_ks_mag        FLOAT,
  phot_ks_mag_error  FLOAT,
  parallax           FLOAT,
  parallax_error     FLOAT,
  pmra               FLOAT,
  pmra_error         FLOAT,
  pmdec              FLOAT,
  pmdec_error        FLOAT,
  uwe                FLOAT,
  astfit_epochs      INTEGER,
  astfit_params      INTEGER,
  ref_epoch          FLOAT,
  Cl                 INTEGER,
  Var                INTEGER,
  source             VARCHAR(3)
);


INSERT INTO vvv_virac
SELECT source_id,glon,glat,ra,dec,phot_hw_mag,phot_hw_mag_error,phot_z_mag,phot_z_mag_error,phot_y_mag,phot_y_mag_error,phot_j_mag,phot_j_mag_error,phot_h_mag,phot_h_mag_error,phot_ks_mag,phot_ks_mag_error,parallax,parallax_error,pmra,pmra_error,pmdec,pmdec_error,uwe,astfit_epochs,astfit_params,ref_epoch,max_class as Cl,Var,'V&V' as source
FROM vvv_virac_common
UNION
SELECT source_id,glon,glat,ra,dec,phot_hw_mag,phot_hw_mag_error,phot_z_mag,phot_z_mag_error,phot_y_mag,phot_y_mag_error,phot_j_mag,phot_j_mag_error,phot_h_mag,phot_h_mag_error,phot_ks_mag,phot_ks_mag_error,NULL as parallax,NULL as parallax_error,NULL as pmra,NULL as pmra_error,NULL as pmdec,NULL as pmdec_error,NULL as uwe,NULL as astfit_epochs,NULL as astfit_params,2010 as ref_epoch,Cl,Var,'VVV' as source
FROM vvv42_sources_full_clean WHERE (phot_ks_mag>16 or phot_ks_mag is null) AND (source_id not in (SELECT vvv_source_id1 FROM vvv_virac_common) OR source_id not in (SELECT vvv_source_id2 FROM vvv_virac_common))
UNION
SELECT source_id,glon,glat,ra,dec,phot_hw_mag,phot_hw_mag_error,phot_z_mag,phot_z_mag_error,phot_y_mag,phot_y_mag_error,phot_j_mag,phot_j_mag_error,phot_h_mag,phot_h_mag_error,phot_ks_mag,phot_ks_mag_error,parallax,parallax_error,pmra,pmra_error,pmdec,pmdec_error,uwe,astfit_epochs,astfit_params,ref_epoch,NULL as  Cl,NULL as Var,'VIR' as source
FROM virac2_ks16_clean WHERE source_id not in (SELECT source_id FROM vvv_virac_common);
 

CREATE INDEX IF NOT EXISTS vvv_virac_radec
  ON vvv_virac (q3c_ang2ipix(ra,dec));
CREATE INDEX IF NOT EXISTS vvv_virac_glonglat
  ON vvv_virac (q3c_ang2ipix(glon,glat));
CREATE INDEX IF NOT EXISTS vvv_virac_hwmag
  ON vvv_virac (phot_hw_mag);
CREATE INDEX IF NOT EXISTS vvv_virac_jmag
  ON vvv_virac (phot_j_mag);
CREATE INDEX IF NOT EXISTS vvv_virac_hmag
  ON vvv_virac (phot_h_mag);
CREATE INDEX IF NOT EXISTS vvv_virac_ksmag
  ON vvv_virac (phot_ks_mag);
CREATE INDEX IF NOT EXISTS vvv_virac_ra
  ON vvv_virac (ra);
CREATE INDEX IF NOT EXISTS vvv_virac_dec
  ON vvv_virac (dec);
CREATE INDEX IF NOT EXISTS vvv_virac_glon
  ON vvv_virac (glon);
CREATE INDEX IF NOT EXISTS vvv_virac_glat
  ON vvv_virac (glat);
CLUSTER vvv_virac_glonglat ON vvv_virac;
ANALYZE vvv_virac;