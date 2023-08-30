-- 2MASS
\set radius_threshold_tmass 150.

DROP TABLE IF EXISTS tmass_sources_local_density CASCADE; -- This table is the first step in the merging. It estimates de local density around each source.
CREATE TABLE tmass_sources_local_density AS
SELECT t.source_id, COUNT(radius) N, MAX(radius) R, COUNT(radius)/(4*PI()*POWER(sin(MAX(radius)/3600*PI()/180/2),2))/(4.25*POWER(10,10)) AS density
FROM tmass_sources_clean as t,
  LATERAL (
    SELECT q3c_dist(t.ra,t.dec,t2.ra,t2.dec)*3600. as radius FROM tmass_sources_clean as t2 WHERE q3c_join(t.ra,t.dec,t2.ra,t2.dec,:radius_threshold_tmass/3600.)
    ORDER BY radius ASC
    LIMIT 100
  ) neighbours
GROUP BY t.source_id;


-- VVV
\set radius_threshold_vvv 50.

DROP TABLE IF EXISTS vvv_sources_local_density CASCADE;
CREATE TABLE vvv_sources_local_density AS
SELECT v.source_id, COUNT(radius) N, MAX(radius) R, COUNT(radius)/(4*PI()*POWER(sin(MAX(radius)/3600*PI()/180/2),2))/(4.25*POWER(10,10)) AS density
FROM vvv_sources_clean as v,
  LATERAL (
    SELECT q3c_dist(v.ra,v.dec,v2.ra,v2.dec)*3600. as radius FROM vvv_sources_clean as v2 WHERE q3c_join(v.ra,v.dec,v2.ra,v2.dec,:radius_threshold_vvv/3600.)
    ORDER BY radius ASC
    LIMIT 100
  ) neighbours
GROUP BY v.source_id;


-- Sirius
\set radius_threshold_sirius 50.

DROP TABLE IF EXISTS sirius_sources_local_density CASCADE; 
CREATE TABLE sirius_sources_local_density AS
SELECT s.source_id, COUNT(radius) N, MAX(radius) R, COUNT(radius)/(4*PI()*POWER(sin(MAX(radius)/3600*PI()/180/2),2))/(4.25*POWER(10,10)) AS density
FROM sirius_sources_clean as s,
  LATERAL (
    SELECT q3c_dist(s.ra,s.dec,s2.ra,s2.dec)*3600. as radius FROM sirius_sources_clean as s2 WHERE q3c_join(s.ra,s.dec,s2.ra,s2.dec,:radius_threshold_sirius/3600.)
    ORDER BY radius ASC
    LIMIT 100
  ) neighbours
GROUP BY s.source_id;





-- SELECT MIN(N),MAX(N),MIN(R),MAX(R) FROM (SELECT COUNT(radius) N, MAX(radius) R
-- FROM vvv_sources_clean as v,
--   LATERAL (
--     SELECT q3c_dist(v.ra,v.dec,v2.ra,v2.dec)*3600. as radius FROM vvv_sources_clean as v2 WHERE q3c_join(v.ra,v.dec,v2.ra,v2.dec,50./3600.)
--     ORDER BY radius ASC
--     LIMIT 100
--   ) neighbours
-- GROUP BY v.source_id LIMIT 1000) as aux2;