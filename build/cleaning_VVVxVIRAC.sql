-- removing bad sources from the VVV-VIRAC crossmatch

DROP TABLE IF EXISTS vvv_virac_clean CASCADE; -- This table is the first step in the merging. It creates pairs of neighbours and merges them (and then makes a first attempt at merging groups of >2 duplicates by merging based on source_id)
CREATE TABLE vvv_virac_clean AS
SELECT * FROM vvv_virac WHERE not (source='VIR' AND uwe>1) and (Cl=-1 or Cl=-2 or Cl is NULL);

CREATE INDEX IF NOT EXISTS vvv_virac_clean_sourceid
  ON vvv_virac_clean (source_id);
CREATE INDEX IF NOT EXISTS vvv_virac_clean_source
  ON vvv_virac_clean (source);
CREATE INDEX IF NOT EXISTS vvv_virac_clean_radec
  ON vvv_virac_clean (q3c_ang2ipix(ra,dec));
CREATE INDEX IF NOT EXISTS vvv_virac_clean_glonglat
  ON vvv_virac_clean (q3c_ang2ipix(glon,glat));
CREATE INDEX IF NOT EXISTS vvv_virac_clean_hwmag
  ON vvv_virac_clean (phot_hw_mag);
CREATE INDEX IF NOT EXISTS vvv_virac_clean_jmag
  ON vvv_virac_clean (phot_j_mag);
CREATE INDEX IF NOT EXISTS vvv_virac_clean_hmag
  ON vvv_virac_clean (phot_h_mag);
CREATE INDEX IF NOT EXISTS vvv_virac_clean_ksmag
  ON vvv_virac_clean (phot_ks_mag);
CREATE INDEX IF NOT EXISTS vvv_virac_clean_ra
  ON vvv_virac_clean (ra);
CREATE INDEX IF NOT EXISTS vvv_virac_clean_dec
  ON vvv_virac_clean (dec);
CREATE INDEX IF NOT EXISTS vvv_virac_clean_glon
  ON vvv_virac_clean (glon);
CREATE INDEX IF NOT EXISTS vvv_virac_clean_glat
  ON vvv_virac_clean (glat);
CLUSTER vvv_virac_clean_glonglat ON vvv_virac_clean;
ANALYZE vvv_virac_clean;