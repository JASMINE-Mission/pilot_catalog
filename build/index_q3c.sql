CREATE INDEX IF NOT EXISTS sirius_sources_radec
  ON sirius_sources (q3c_ang2ipix(ra,dec));
CREATE INDEX IF NOT EXISTS sirius_sources_glonglat
  ON sirius_sources (q3c_ang2ipix(glon,glat));
CREATE INDEX IF NOT EXISTS sirius_sources_jmag
  ON sirius_sources (phot_j_mag);
CREATE INDEX IF NOT EXISTS sirius_sources_hmag
  ON sirius_sources (phot_h_mag);
CREATE INDEX IF NOT EXISTS sirius_sources_kmag
  ON sirius_sources (phot_k_mag);
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
CREATE INDEX IF NOT EXISTS tmass_sources_kmag
  ON tmass_sources (phot_k_mag);
CLUSTER tmass_sources_glonglat ON tmass_sources;
ANALYZE tmass_sources;


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
CLUSTER edr3_sources_glonglat ON edr3_sources;
ANALYZE edr3_sources;
