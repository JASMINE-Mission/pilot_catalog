\set angdist_threshold 0.4/3600
\set magdiff_threshold 5.



DROP TABLE IF EXISTS merged_sources_confusion_04_5 CASCADE; 

CREATE TABLE merged_sources_confusion_04_5 AS
SELECT m.source_id,COUNT(aux.sid),m.glon,m.glat,m.phot_j_mag,m.phot_h_mag,m.phot_ks_mag,m.phot_hw_mag FROM merged_sources as m, LATERAL (SELECT m1.source_id as sid,m1.glon,m1.glat,m1.phot_j_mag,m1.phot_h_mag,m1.phot_ks_mag FROM merged_sources as m1 WHERE q3c_join(m.ra,m.dec,m1.ra,m1.dec,:angdist_threshold)) aux WHERE jhk_match(aux.phot_j_mag,m.phot_j_mag,aux.phot_h_mag,m.phot_h_mag,aux.phot_ks_mag,m.phot_ks_mag,:magdiff_threshold) GROUP BY m.source_id;


DROP TABLE IF EXISTS vvv4_confusion_04_5 CASCADE; 
CREATE TABLE vvv4_confusion_04_5 AS
SELECT m.source_id,COUNT(aux.sid),m.glon,m.glat,m.phot_j_mag,m.phot_h_mag,m.phot_ks_mag,m.phot_hw_mag FROM vvv4_sources as m, LATERAL (SELECT m1.source_id as sid,m1.glon,m1.glat,m1.phot_j_mag,m1.phot_h_mag,m1.phot_ks_mag FROM vvv4_sources as m1 WHERE q3c_join(m.ra,m.dec,m1.ra,m1.dec,:angdist_threshold)) aux WHERE jhk_match(aux.phot_j_mag,m.phot_j_mag,aux.phot_h_mag,m.phot_h_mag,aux.phot_ks_mag,m.phot_ks_mag,:magdiff_threshold) GROUP BY m.source_id;

DROP TABLE IF EXISTS vvv4_clean_confusion_04_5 CASCADE; 
CREATE TABLE vvv4_clean_confusion_04_5 AS
SELECT m.source_id,COUNT(aux.sid),m.glon,m.glat,m.phot_j_mag,m.phot_h_mag,m.phot_ks_mag,m.phot_hw_mag FROM vvv4_sources_clean as m, LATERAL (SELECT m1.source_id as sid,m1.glon,m1.glat,m1.phot_j_mag,m1.phot_h_mag,m1.phot_ks_mag FROM vvv4_sources_clean as m1 WHERE q3c_join(m.ra,m.dec,m1.ra,m1.dec,:angdist_threshold)) aux WHERE jhk_match(aux.phot_j_mag,m.phot_j_mag,aux.phot_h_mag,m.phot_h_mag,aux.phot_ks_mag,m.phot_ks_mag,:magdiff_threshold) GROUP BY m.source_id;



DROP TABLE IF EXISTS sirius_confusion_04_5 CASCADE; 
CREATE TABLE sirius_confusion_04_5 AS
SELECT m.source_id,COUNT(aux.sid),m.glon,m.glat,m.phot_j_mag,m.phot_h_mag,m.phot_ks_mag,m.phot_hw_mag FROM sirius_sources as m, LATERAL (SELECT m1.source_id as sid,m1.glon,m1.glat,m1.phot_j_mag,m1.phot_h_mag,m1.phot_ks_mag FROM sirius_sources as m1 WHERE q3c_join(m.ra,m.dec,m1.ra,m1.dec,:angdist_threshold)) aux WHERE jhk_match(aux.phot_j_mag,m.phot_j_mag,aux.phot_h_mag,m.phot_h_mag,aux.phot_ks_mag,m.phot_ks_mag,:magdiff_threshold) GROUP BY m.source_id;

DROP TABLE IF EXISTS sirius_clean_confusion_04_5 CASCADE; 
CREATE TABLE sirius_clean_confusion_04_5 AS
SELECT m.source_id,COUNT(aux.sid),m.glon,m.glat,m.phot_j_mag,m.phot_h_mag,m.phot_ks_mag,m.phot_hw_mag FROM sirius_sources_clean as m, LATERAL (SELECT m1.source_id as sid,m1.glon,m1.glat,m1.phot_j_mag,m1.phot_h_mag,m1.phot_ks_mag FROM sirius_sources_clean as m1 WHERE q3c_join(m.ra,m.dec,m1.ra,m1.dec,:angdist_threshold)) aux WHERE jhk_match(aux.phot_j_mag,m.phot_j_mag,aux.phot_h_mag,m.phot_h_mag,aux.phot_ks_mag,m.phot_ks_mag,:magdiff_threshold) GROUP BY m.source_id;



\set angdist_threshold 0.4/3600
\set magdiff_threshold 7.5

DROP TABLE IF EXISTS merged_sources_confusion_04_75 CASCADE; 

CREATE TABLE merged_sources_confusion_04_75 AS
SELECT m.source_id,COUNT(aux.sid),m.glon,m.glat,m.phot_j_mag,m.phot_h_mag,m.phot_ks_mag,m.phot_hw_mag FROM merged_sources as m, LATERAL (SELECT m1.source_id as sid,m1.glon,m1.glat,m1.phot_j_mag,m1.phot_h_mag,m1.phot_ks_mag FROM merged_sources as m1 WHERE q3c_join(m.ra,m.dec,m1.ra,m1.dec,:angdist_threshold)) aux WHERE jhk_match(aux.phot_j_mag,m.phot_j_mag,aux.phot_h_mag,m.phot_h_mag,aux.phot_ks_mag,m.phot_ks_mag,:magdiff_threshold) GROUP BY m.source_id;



\set angdist_threshold 1.2/3600
\set magdiff_threshold 5.

DROP TABLE IF EXISTS merged_sources_confusion_12_5 CASCADE; 

CREATE TABLE merged_sources_confusion_12_5 AS
SELECT m.source_id,COUNT(aux.sid),m.glon,m.glat,m.phot_j_mag,m.phot_h_mag,m.phot_ks_mag,m.phot_hw_mag FROM merged_sources as m, LATERAL (SELECT m1.source_id as sid,m1.glon,m1.glat,m1.phot_j_mag,m1.phot_h_mag,m1.phot_ks_mag FROM merged_sources as m1 WHERE q3c_join(m.ra,m.dec,m1.ra,m1.dec,:angdist_threshold)) aux WHERE jhk_match(aux.phot_j_mag,m.phot_j_mag,aux.phot_h_mag,m.phot_h_mag,aux.phot_ks_mag,m.phot_ks_mag,:magdiff_threshold) GROUP BY m.source_id;
