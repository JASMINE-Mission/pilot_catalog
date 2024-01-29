\set radius_threshold 60.
\set hwmagdiff_threshold 1.



DROP TABLE IF EXISTS merged_sources_local_density_jasmine_2magfainter CASCADE; -- This table is the first step in the merging. It estimates de local density around each source.

CREATE TABLE merged_sources_local_density_jasmine_2magfainter (
  source_id         BIGSERIAL PRIMARY KEY,
  glon              BIGINT NOT NULL,
  glat              BIGINT NOT NULL,
  phot_hw_mag       FLOAT(10) NOT NULL,
  n                 INT,
  rmin              FLOAT(10),
  rmean             FLOAT(10),
  rmax              FLOAT(10),
  density           FLOAT(10),
  hwmin             FLOAT(10),
  hwmax             FLOAT(10)
);

WITH m AS (SELECT * FROM merged_sources WHERE phot_hw_mag<10)
INSERT INTO merged_sources_local_density_jasmine_2magfainter
SELECT m.source_id,MIN(m.glon) glon,MIN(m.glat) glat,MIN(m.phot_hw_mag) phot_hw_mag, COUNT(radius) N, MIN(radius) Rmin, AVG(radius) Rmean, MAX(radius) Rmax, COUNT(radius)/(4*PI()*POWER(sin(MAX(radius)/3600*PI()/180/2),2))/(4.25*POWER(10,10)) AS density,MIN(hw) as min_hw_mag_neighbours,MAX(hw) as max_hw_mag_neighbours
FROM m,
  LATERAL (
    SELECT q3c_dist(m.ra,m.dec,m1.ra,m1.dec)*3600. as radius, m1.phot_hw_mag as hw FROM merged_sources as m1 WHERE m1.source_id!=m.source_id and m1.phot_hw_mag<=m.phot_hw_mag+:hwmagdiff_threshold and ABS(m.ra-m1.ra)<1 and ABS(m.dec-m1.dec)<1
    ORDER BY radius ASC
    LIMIT 100
  ) neighbours
GROUP BY m.source_id;
