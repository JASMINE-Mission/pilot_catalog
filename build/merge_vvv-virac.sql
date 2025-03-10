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
  MIN(astfit_epochs) as astfit_epochs,MIN(asfit_params) as astfit_params,MIN(ref_epoch) as ref_epoch,
  MIN(aux.vvv_sid) as vvv_source_id1,MAX(aux.vvv_sid) as vvv_source_id2,STRING_AGG(aux.vvv_sid_char,'-') as vvv_source_ids, AVG(Cl) as avg_class, MAX(Cl) as max_class, MAX(Var) as Var, COUNT(*) as n_matches
 FROM (SELECT v2.*,v.source_id as vvv_sid,CAST(v.source_id AS varchar) as vvv_sid_char,v.Cl,v.Var FROM (SELECT source_id,Cl,Var,ra,dec FROM vvv42_sources_full WHERE phot_ks_mag<18) as v INNER JOIN virac2_ks16_clean as v2 ON q3c_join(v.ra,v.dec,v2.ra,v2.dec,.5/3600.) ) as aux GROUP BY source_id;

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
CLUSTER vvv_virac_common_glonglat ON vvv_virac_common;
ANALYZE vvv_virac_common;
