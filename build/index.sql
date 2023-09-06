CREATE INDEX IF NOT EXISTS sirius_sources_radec
  ON sirius_sources (q3c_ang2ipix(ra,dec));
CREATE INDEX IF NOT EXISTS sirius_sources_glonglat
  ON sirius_sources (q3c_ang2ipix(glon,glat));
CREATE INDEX IF NOT EXISTS sirius_sources_jmag
  ON sirius_sources (phot_j_mag);
CREATE INDEX IF NOT EXISTS sirius_sources_hmag
  ON sirius_sources (phot_h_mag);
CREATE INDEX IF NOT EXISTS sirius_sources_ksmag
  ON sirius_sources (phot_ks_mag);
CREATE INDEX IF NOT EXISTS sirius_sources_ra
  ON sirius_sources (ra);
CREATE INDEX IF NOT EXISTS sirius_sources_dec
  ON sirius_sources (dec);
CREATE INDEX IF NOT EXISTS sirius_sources_glon
  ON sirius_sources (glon);
CREATE INDEX IF NOT EXISTS sirius_sources_glat
  ON sirius_sources (glat);
CLUSTER sirius_sources_glonglat ON sirius_sources;
ANALYZE sirius_sources;


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


CREATE INDEX IF NOT EXISTS vvv_sources_radec
  ON vvv_sources (q3c_ang2ipix(ra,dec));
CREATE INDEX IF NOT EXISTS vvv_sources_glonglat
  ON vvv_sources (q3c_ang2ipix(glon,glat));
CREATE INDEX IF NOT EXISTS vvv_sources_jmag
  ON vvv_sources (phot_j_mag);
CREATE INDEX IF NOT EXISTS vvv_sources_hmag
  ON vvv_sources (phot_h_mag);
CREATE INDEX IF NOT EXISTS vvv_sources_ksmag
  ON vvv_sources (phot_ks_mag);
CREATE INDEX IF NOT EXISTS vvv_sources_ra
  ON vvv_sources (ra);
CREATE INDEX IF NOT EXISTS vvv_sources_dec
  ON vvv_sources (dec);
CREATE INDEX IF NOT EXISTS vvv_sources_glon
  ON vvv_sources (glon);
CREATE INDEX IF NOT EXISTS vvv_sources_glat
  ON vvv_sources (glat);
CLUSTER vvv_sources_glonglat ON vvv_sources;
ANALYZE vvv_sources;

CREATE INDEX IF NOT EXISTS gdr3_sources_tmass_designation
ON gdr3_sources (tmass_designation);
CREATE INDEX IF NOT EXISTS gdr3_sources_radec
  ON gdr3_sources (q3c_ang2ipix(ra,dec));
CREATE INDEX IF NOT EXISTS gdr3_sources_glonglat
  ON gdr3_sources (q3c_ang2ipix(glon,glat));
CREATE INDEX IF NOT EXISTS gdr3_sources_gmag
  ON gdr3_sources (phot_g_mag);
CREATE INDEX IF NOT EXISTS gdr3_sources_bpmag
  ON gdr3_sources (phot_bp_mag);
CREATE INDEX IF NOT EXISTS gdr3_sources_rpmag
  ON gdr3_sources (phot_rp_mag);
CREATE INDEX IF NOT EXISTS gdr3_sources_jmag
  ON gdr3_sources (phot_j_mag_pred);
CREATE INDEX IF NOT EXISTS gdr3_sources_hmag
  ON gdr3_sources (phot_h_mag_pred);
CREATE INDEX IF NOT EXISTS gdr3_sources_ksmag
  ON gdr3_sources (phot_ks_mag_pred);
CREATE INDEX IF NOT EXISTS gdr3_sources_ra
  ON gdr3_sources (ra);
CREATE INDEX IF NOT EXISTS gdr3_sources_dec
  ON gdr3_sources (dec);
CREATE INDEX IF NOT EXISTS gdr3_sources_glon
  ON gdr3_sources (glon);
CREATE INDEX IF NOT EXISTS gdr3_sources_glat
  ON gdr3_sources (glat);
CLUSTER gdr3_sources_glonglat ON gdr3_sources;
ANALYZE gdr3_sources;
