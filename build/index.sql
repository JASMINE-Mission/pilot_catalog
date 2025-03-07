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

CREATE INDEX IF NOT EXISTS vvv4_sources_radec
  ON vvv4_sources (q3c_ang2ipix(ra,dec));
CREATE INDEX IF NOT EXISTS vvv4_sources_glonglat
  ON vvv4_sources (q3c_ang2ipix(glon,glat));
CREATE INDEX IF NOT EXISTS vvv4_sources_jmag
  ON vvv4_sources (phot_j_mag);
CREATE INDEX IF NOT EXISTS vvv4_sources_hmag
  ON vvv4_sources (phot_h_mag);
CREATE INDEX IF NOT EXISTS vvv4_sources_ksmag
  ON vvv4_sources (phot_ks_mag);
CREATE INDEX IF NOT EXISTS vvv4_sources_ra
  ON vvv4_sources (ra);
CREATE INDEX IF NOT EXISTS vvv4_sources_dec
  ON vvv4_sources (dec);
CREATE INDEX IF NOT EXISTS vvv4_sources_glon
  ON vvv4_sources (glon);
CREATE INDEX IF NOT EXISTS vvv4_sources_glat
  ON vvv4_sources (glat);
CLUSTER vvv4_sources_glonglat ON vvv4_sources;
ANALYZE vvv4_sources;

CREATE INDEX IF NOT EXISTS vvv42_sources_full_full
  ON vvv42_sources_full (q3c_ang2ipix(ra,dec));
CREATE INDEX IF NOT EXISTS vvv42_sources_full_glonglat
  ON vvv42_sources_full (q3c_ang2ipix(glon,glat));
CREATE INDEX IF NOT EXISTS vvv42_sources_full_jmag
  ON vvv42_sources_full (phot_j_mag);
CREATE INDEX IF NOT EXISTS vvv42_sources_full_hmag
  ON vvv42_sources_full (phot_h_mag);
CREATE INDEX IF NOT EXISTS vvv42_sources_full_ksmag
  ON vvv42_sources_full (phot_ks_mag);
CREATE INDEX IF NOT EXISTS vvv42_sources_full_ra
  ON vvv42_sources_full (ra);
CREATE INDEX IF NOT EXISTS vvv42_sources_full_dec
  ON vvv42_sources_full (dec);
CREATE INDEX IF NOT EXISTS vvv42_sources_full_glon
  ON vvv42_sources_full (glon);
CREATE INDEX IF NOT EXISTS vvv42_sources_full_glat
  ON vvv42_sources_full (glat);
CLUSTER vvv42_sources_full_glonglat ON vvv42_sources_full;
ANALYZE vvv42_sources_full;

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
CREATE INDEX IF NOT EXISTS gdr3_sources_radec_sirius
  ON gdr3_sources (q3c_ang2ipix(ra_sirius,dec_sirius));
CREATE INDEX IF NOT EXISTS gdr3_sources_radec_vvv
  ON gdr3_sources (q3c_ang2ipix(ra_vvv,dec_vvv));
CREATE INDEX IF NOT EXISTS gdr3_sources_ra
  ON gdr3_sources (ra);
CREATE INDEX IF NOT EXISTS gdr3_sources_dec
  ON gdr3_sources (dec);
CREATE INDEX IF NOT EXISTS gdr3_sources_ra_sirius
  ON gdr3_sources (ra_sirius);
CREATE INDEX IF NOT EXISTS gdr3_sources_dec_sirius
  ON gdr3_sources (dec_sirius);
CREATE INDEX IF NOT EXISTS gdr3_sources_ra_vvv
  ON gdr3_sources (ra_vvv);
CREATE INDEX IF NOT EXISTS gdr3_sources_dec_vvv
  ON gdr3_sources (dec_vvv);
CREATE INDEX IF NOT EXISTS gdr3_sources_glon
  ON gdr3_sources (glon);
CREATE INDEX IF NOT EXISTS gdr3_sources_glat
  ON gdr3_sources (glat);
CLUSTER gdr3_sources_glonglat ON gdr3_sources;
ANALYZE gdr3_sources;


CREATE INDEX IF NOT EXISTS virac2_ks16_radec
  ON virac2_ks16 (q3c_ang2ipix(ra,dec));
CREATE INDEX IF NOT EXISTS virac2_ks16_glonglat
  ON virac2_ks16 (q3c_ang2ipix(glon,glat));
CREATE INDEX IF NOT EXISTS virac2_ks16_jmag
  ON virac2_ks16 (phot_j_mean_mag);
CREATE INDEX IF NOT EXISTS virac2_ks16_hmag
  ON virac2_ks16 (phot_h_mean_mag);
CREATE INDEX IF NOT EXISTS virac2_ks16_ksmag
  ON virac2_ks16 (phot_ks_mean_mag);
CREATE INDEX IF NOT EXISTS virac2_ks16_ra
  ON virac2_ks16 (ra);
CREATE INDEX IF NOT EXISTS virac2_ks16_dec
  ON virac2_ks16 (dec);
CREATE INDEX IF NOT EXISTS virac2_ks16_glon
  ON virac2_ks16 (glon);
CREATE INDEX IF NOT EXISTS virac2_ks16_glat
  ON virac2_ks16 (glat);
CLUSTER virac2_ks16_glonglat ON virac2_ks16;
ANALYZE virac2_ks16;



CREATE INDEX IF NOT EXISTS virac2_ks16_bad_radec
  ON virac2_ks16_bad (q3c_ang2ipix(ra,dec));
CREATE INDEX IF NOT EXISTS virac2_ks16_bad_glonglat
  ON virac2_ks16_bad (q3c_ang2ipix(glon,glat));
CREATE INDEX IF NOT EXISTS virac2_ks16_bad_jmag
  ON virac2_ks16_bad (phot_j_mean_mag);
CREATE INDEX IF NOT EXISTS virac2_ks16_bad_hmag
  ON virac2_ks16_bad (phot_h_mean_mag);
CREATE INDEX IF NOT EXISTS virac2_ks16_bad_ksmag
  ON virac2_ks16_bad (phot_ks_mean_mag);
CREATE INDEX IF NOT EXISTS virac2_ks16_bad_ra
  ON virac2_ks16_bad (ra);
CREATE INDEX IF NOT EXISTS virac2_ks16_bad_dec
  ON virac2_ks16_bad (dec);
CREATE INDEX IF NOT EXISTS virac2_ks16_bad_glon
  ON virac2_ks16_bad (glon);
CREATE INDEX IF NOT EXISTS virac2_ks16_bad_glat
  ON virac2_ks16_bad (glat);
CLUSTER virac2_ks16_bad_glonglat ON virac2_ks16_bad;
ANALYZE virac2_ks16_bad;