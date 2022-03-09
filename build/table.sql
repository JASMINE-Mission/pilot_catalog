CREATE TABLE IF NOT EXISTS sirius_sources (
  source_id          BIGSERIAL PRIMARY KEY,
  glon               FLOAT(10) NOT NULL,
  glat               FLOAT(10) NOT NULL,
  ra                 FLOAT(10) NOT NULL,
  dec                FLOAT(10) NOT NULL,
  position_j_x       FLOAT(10),
  position_j_y       FLOAT(10),
  phot_j_mag         FLOAT(10),
  phot_j_mag_error   FLOAT(10),
  position_h_x       FLOAT(10),
  position_h_y       FLOAT(10),
  phot_h_mag         FLOAT(10),
  phot_h_mag_error   FLOAT(10),
  position_ks_x      FLOAT(10),
  position_ks_y      FLOAT(10),
  phot_ks_mag        FLOAT(10),
  phot_ks_mag_error  FLOAT(10),
  plate_name         VARCHAR(16) NOT NULL
);


CREATE TABLE IF NOT EXISTS tmass_sources (
  source_id          BIGSERIAL PRIMARY KEY,
  ra                 FLOAT(10) NOT NULL,
  dec                FLOAT(10) NOT NULL,
  designation        VARCHAR(32) NOT NULL,
  phot_j_mag         FLOAT(10),
  phot_j_cmsig       FLOAT(10),
  phot_j_mag_error   FLOAT(10),
  phot_j_snr         FLOAT(10),
  phot_h_mag         FLOAT(10),
  phot_h_cmsig       FLOAT(10),
  phot_h_mag_error   FLOAT(10),
  phot_h_snr         FLOAT(10),
  phot_ks_mag        FLOAT(10),
  phot_ks_cmsig      FLOAT(10),
  phot_ks_mag_error  FLOAT(10),
  phot_ks_snr        FLOAT(10),
  quality_flag       VARCHAR(3) NOT NULL,
  contaminated       INTEGER NOT NULL,
  glon               FLOAT(10) NOT NULL,
  glat               FLOAT(10) NOT NULL,
  rd_flg             VARCHAR(3) NOT NULL,
  color_j_h          FLOAT(10),
  color_h_ks         FLOAT(10),
  color_j_ks         FLOAT(10)
);


CREATE TABLE IF NOT EXISTS vvv_sources (
  source_id         BIGINT PRIMARY KEY,
  glon              FLOAT(10) NOT NULL,
  glat              FLOAT(10) NOT NULL,
  ra                FLOAT(10) NOT NULL,
  dec               FLOAT(10) NOT NULL,
  phot_z_flag       INTEGER,
  phot_z_mag        FLOAT(10),
  phot_z_mag_error  FLOAT(10),
  phot_y_flag       INTEGER,
  phot_y_mag        FLOAT(10),
  phot_y_mag_error  FLOAT(10),
  phot_j_flag       INTEGER,
  phot_j_mag        FLOAT(10),
  phot_j_mag_error  FLOAT(10),
  phot_h_flag       INTEGER,
  phot_h_mag        FLOAT(10),
  phot_h_mag_error  FLOAT(10),
  phot_ks_flag      INTEGER,
  phot_ks_mag       FLOAT(10),
  phot_ks_mag_error FLOAT(10)
);


CREATE TABLE IF NOT EXISTS edr3_sources (
  source_id          BIGINT PRIMARY KEY,
  ra                 FLOAT(10) NOT NULL,
  dec                FLOAT(10) NOT NULL,
  glon               FLOAT(10) NOT NULL,
  glat               FLOAT(10) NOT NULL,
  parallax           FLOAT(10),
  parallax_error     FLOAT(10),
  pm                 FLOAT(10),
  pmra               FLOAT(10),
  pmra_error         FLOAT(10),
  pmdec              FLOAT(10),
  pmdec_error        FLOAT(10),
  phot_g_mag         FLOAT(10),
  phot_g_mag_error   FLOAT(10),
  phot_bp_mag        FLOAT(10),
  phot_bp_mag_error  FLOAT(10),
  phot_rp_mag        FLOAT(10),
  phot_rp_mag_error  FLOAT(10)
);
