-- removing bad sources from the VVV-VIRAC crossmatch

DROP TABLE IF EXISTS vvv_virac_clean CASCADE; -- This table is the first step in the merging. It creates pairs of neighbours and merges them (and then makes a first attempt at merging groups of >2 duplicates by merging based on source_id)
CREATE TABLE vvv_virac_clean AS
SELECT * FROM vvv_virac WHERE not (source='VIR' AND uwe>1) and (Cl=-1 or Cl=-2 or Cl is NULL);