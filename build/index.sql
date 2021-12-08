CREATE INDEX IF NOT EXISTS sirius_sources_orig_radec
  ON sirius_sources_orig (q3c_ang2ipix(ra,dec));
CREATE INDEX IF NOT EXISTS sirius_sources_orig_glonglat
  ON sirius_sources_orig (q3c_ang2ipix(glon,glat));
CREATE INDEX IF NOT EXISTS sirius_sources_orig_jmag
  ON sirius_sources_orig (phot_j_mag);
CREATE INDEX IF NOT EXISTS sirius_sources_orig_hmag
  ON sirius_sources_orig (phot_h_mag);
CREATE INDEX IF NOT EXISTS sirius_sources_orig_ksmag
  ON sirius_sources_orig (phot_ks_mag);
CREATE INDEX IF NOT EXISTS sirius_sources_orig_ra
  ON sirius_sources_orig (ra);
CREATE INDEX IF NOT EXISTS sirius_sources_orig_dec
  ON sirius_sources_orig (dec);
CREATE INDEX IF NOT EXISTS sirius_sources_orig_glon
  ON sirius_sources_orig (glon);
CREATE INDEX IF NOT EXISTS sirius_sources_orig_glat
  ON sirius_sources_orig (glat);
CLUSTER sirius_sources_orig_glonglat ON sirius_sources_orig;
ANALYZE sirius_sources_orig;


CREATE INDEX IF NOT EXISTS tmass_sources_radec
  ON tmass_sources (q3c_ang2ipix(ra,dec));
CREATE INDEX IF NOT EXISTS tmass_sources_glonglat
  ON tmass_sources (q3c_ang2ipix(glon,glat));
CREATE INDEX IF NOT EXISTS tmass_sources_jmag
  ON tmass_sources (phot_j_mag);
CREATE INDEX IF NOT EXISTS tmass_sources_hmag
  ON tmass_sources (phot_h_mag);
CREATE INDEX IF NOT EXISTS tmass_sources_ksmag
  ON tmass_sources (phot_ks_mag);
CREATE INDEX IF NOT EXISTS tmass_sources_ra
  ON tmass_sources (ra);
CREATE INDEX IF NOT EXISTS tmass_sources_dec
  ON tmass_sources (dec);
CREATE INDEX IF NOT EXISTS tmass_sources_glon
  ON tmass_sources (glon);
CREATE INDEX IF NOT EXISTS tmass_sources_glat
  ON tmass_sources (glat);
CLUSTER tmass_sources_glonglat ON tmass_sources;
ANALYZE tmass_sources;


CREATE INDEX IF NOT EXISTS vvv_sources_orig_radec
  ON vvv_sources_orig (q3c_ang2ipix(ra,dec));
CREATE INDEX IF NOT EXISTS vvv_sources_orig_glonglat
  ON vvv_sources_orig (q3c_ang2ipix(glon,glat));
CREATE INDEX IF NOT EXISTS vvv_sources_orig_z1mag
  ON vvv_sources_orig (phot_z1_mag);
CREATE INDEX IF NOT EXISTS vvv_sources_orig_z2mag
  ON vvv_sources_orig (phot_z2_mag);
CREATE INDEX IF NOT EXISTS vvv_sources_orig_y1mag
  ON vvv_sources_orig (phot_y1_mag);
CREATE INDEX IF NOT EXISTS vvv_sources_orig_y2mag
  ON vvv_sources_orig (phot_y2_mag);
CREATE INDEX IF NOT EXISTS vvv_sources_orig_j1mag
  ON vvv_sources_orig (phot_j1_mag);
CREATE INDEX IF NOT EXISTS vvv_sources_orig_j2mag
  ON vvv_sources_orig (phot_j2_mag);
CREATE INDEX IF NOT EXISTS vvv_sources_orig_h1mag
  ON vvv_sources_orig (phot_h1_mag);
CREATE INDEX IF NOT EXISTS vvv_sources_orig_h2mag
  ON vvv_sources_orig (phot_h2_mag);
CREATE INDEX IF NOT EXISTS vvv_sources_orig_k1mag
  ON vvv_sources_orig (phot_ks1_mag);
CREATE INDEX IF NOT EXISTS vvv_sources_orig_k2mag
  ON vvv_sources_orig (phot_ks2_mag);
CREATE INDEX IF NOT EXISTS vvv_sources_orig_ra
  ON vvv_sources_orig (ra);
CREATE INDEX IF NOT EXISTS vvv_sources_orig_dec
  ON vvv_sources_orig (dec);
CREATE INDEX IF NOT EXISTS vvv_sources_orig_glon
  ON vvv_sources_orig (glon);
CREATE INDEX IF NOT EXISTS vvv_sources_orig_glat
  ON vvv_sources_orig (glat);
CLUSTER vvv_sources_orig_glonglat ON vvv_sources_orig;
ANALYZE vvv_sources_orig;


CREATE INDEX IF NOT EXISTS edr3_sources_radec
  ON edr3_sources (q3c_ang2ipix(ra,dec));
CREATE INDEX IF NOT EXISTS edr3_sources_glonglat
  ON edr3_sources (q3c_ang2ipix(glon,glat));
CREATE INDEX IF NOT EXISTS edr3_sources_gmag
  ON edr3_sources (phot_g_mag);
CREATE INDEX IF NOT EXISTS edr3_sources_bpmag
  ON edr3_sources (phot_bp_mag);
CREATE INDEX IF NOT EXISTS edr3_sources_rpmag
  ON edr3_sources (phot_rp_mag);
CREATE INDEX IF NOT EXISTS edr3_sources_ra
  ON edr3_sources (ra);
CREATE INDEX IF NOT EXISTS edr3_sources_dec
  ON edr3_sources (dec);
CREATE INDEX IF NOT EXISTS edr3_sources_glon
  ON edr3_sources (glon);
CREATE INDEX IF NOT EXISTS edr3_sources_glat
  ON edr3_sources (glat);
CLUSTER edr3_sources_glonglat ON edr3_sources;
ANALYZE edr3_sources;
