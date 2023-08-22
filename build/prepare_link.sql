-- 2MASS
\set radius_threshold_tmass 600.

DROP TABLE IF EXISTS tmass_sources_local_density CASCADE; -- This table is the first step in the merging. It creates pairs of neighbours and merges them (and then makes a first attempt at merging groups of >2 duplicates by merging based on source_id)
CREATE TABLE tmass_sources_local_density AS
SELECT source_id,COUNT(*) as N,MAX(radius) as R,COUNT(*)/(4*PI()*POWER(sin(MAX(radius)/3600*PI()/180/2),2))/(4.25*POWER(10,10)) AS density FROM (SELECT source_id,ra,dec,aux.source_id_neighbour,aux.radius FROM tmass_sources_clean as s LEFT JOIN LATERAL(SELECT source_id as source_id_neighbour,q3c_dist(s.ra,s.dec,s2.ra,s2.dec)*3600. as radius FROM tmass_sources_clean as s2 WHERE q3c_join(s.ra,s.dec,s2.ra,s2.dec,:radius_threshold_sirius/3600) AND s.source_id!=s2.source_id ORDER BY radius ASC LIMIT 100) as aux on true) as aux2 GROUP BY source_id;



-- Sirius
\set radius_threshold_sirius 300.

--DROP TABLE IF EXISTS sirius_sources_local_density CASCADE; -- This table is the first step in the merging. It creates pairs of neighbours and merges them (and then makes a first attempt at merging groups of >2 duplicates by merging based on source_id)
--CREATE TABLE sirius_sources_local_density AS
--SELECT source_id,COUNT(*) as N,MAX(radius) as R,COUNT(*)/(4*PI()*POWER(sin(MAX(radius)/3600*PI()/180/2),2))/(4.25*POWER(10,10)) AS density FROM (SELECT source_id,ra,dec,aux.source_id_neighbour,aux.radius FROM sirius_sources_clean as s LEFT JOIN LATERAL(SELECT source_id as source_id_neighbour,q3c_dist(s.ra,s.dec,s2.ra,s2.dec)*3600. as radius FROM sirius_sources_clean as s2 WHERE q3c_join(s.ra,s.dec,s2.ra,s2.dec,:radius_threshold_sirius/3600) AND s.source_id!=s2.source_id ORDER BY radius ASC LIMIT 100) as aux on true) as aux2 GROUP BY source_id;


--SELECT source_id,COUNT(*) as N,MAX(radius) as R,COUNT(*)/(4*PI()*POWER(sin(MAX(radius)/3600*PI()/180/2),2))/(4.25*POWER(10,10)) AS density FROM sirius_sources_local_density GROUP BY source_id;