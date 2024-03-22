DROP TABLE IF EXISTS merged_sources_dups_clean CASCADE;
CREATE TABLE merged_sources_dups_clean AS
SELECT * FROM (SELECT d1.source_id,AVG(d1.ra) as ra,AVG(d1.dec) as dec,AVG(d1.phot_error) as phot_error,select_better_agg(aux.source_id,aux.phot_error) as source_id_best,select_better_agg(aux.ra,aux.phot_error) as ra_best,select_better_agg(aux.dec,aux.phot_error) as dec_best FROM merged_sources_dups_candidates2_full as d1, LATERAL(
    SELECT * FROM merged_sources_dups_candidates2_full as d2 WHERE q3c_dist(d1.ra,d1.dec,d2.ra,d2.dec)<1.0/3600
) AS aux GROUP BY d1.source_id) AS aux2 ORDER BY aux2.source_id_best;