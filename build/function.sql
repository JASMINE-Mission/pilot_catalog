CREATE OR REPLACE FUNCTION ifthenelse(
  bigint,varchar,varchar)
RETURNS VARCHAR AS $$
  SELECT CASE
    WHEN $1 IS NULL THEN $3 ELSE $2
  END
$$ LANGUAGE SQL;
CREATE OR REPLACE FUNCTION ifthenelse(
  real,varchar,varchar)
RETURNS VARCHAR AS $$
  SELECT CASE
    WHEN $1 IS NULL THEN $3 ELSE $2
  END
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION mag_match(
  real, -- magnitude of the first catalog
  real, -- magnitude of the second catalog
  real) -- acceptable magnitude difference
RETURNS boolean AS $$
  SELECT ABS($1-$2)<$3
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION jhk_match(
  real, -- J-band magnitude of the first catalog
  real, -- J-band magnitude of the second catalog
  real, -- H-band magnitude of the first catalog
  real, -- H-band magnitude of the second catalog
  real, -- K-band magnitude of the first catalog
  real, -- K-band magnitude of the second catalog
  real) -- acceptable magnitude difference
RETURNS boolean AS $$
  SELECT
    COALESCE(mag_match($1,$2,$7),True)
    AND COALESCE(mag_match($3,$4,$7),True)
    AND COALESCE(mag_match($5,$6,$7),True)
$$ LANGUAGE SQL;
