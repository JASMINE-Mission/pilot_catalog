CREATE OR REPLACE FUNCTION ifthenelse(
  BIGINT,VARCHAR,VARCHAR)
RETURNS VARCHAR AS $$
  SELECT CASE
    WHEN $1 IS NULL THEN $3 ELSE $2
  END
$$ LANGUAGE SQL;
CREATE OR REPLACE FUNCTION ifthenelse(
  FLOAT8,VARCHAR,VARCHAR)
RETURNS VARCHAR AS $$
  SELECT CASE
    WHEN $1 IS NULL THEN $3 ELSE $2
  END
$$ LANGUAGE SQL;
CREATE OR REPLACE FUNCTION ifthenelse(
  BOOLEAN,FLOAT8,FLOAT8)
RETURNS FLOAT8 AS $$
  SELECT CASE
    WHEN $1 IS True THEN $2 ELSE $3
  END
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION select_better(
  FLOAT8, -- magnitude in the first catalog
  FLOAT8, -- magnitude uncertainty in the first catalog
  FLOAT8, -- magnitude in the second catalog
  FLOAT8) -- magnitude uncertainty in the second catalog
RETURNS FLOAT8 AS $$
  SELECT CASE
    WHEN COALESCE($2,1000) < COALESCE($4,1000) THEN $1
    WHEN COALESCE($2,1000) > COALESCE($4,1000) THEN $3
    ELSE NULL
  END
$$ LANGUAGE SQL;
CREATE OR REPLACE FUNCTION select_char(
  FLOAT8,    -- magnitude uncertainty in the first catalog
  FLOAT8,    -- magnitude uncertainty in the second catalog
  VARCHAR, -- letter of the first catalog
  VARCHAR) -- letter of the second catalog
RETURNS VARCHAR AS $$
  SELECT CASE
    WHEN COALESCE($1,1000) < COALESCE($2,1000) THEN $3
    WHEN COALESCE($1,1000) > COALESCE($2,1000) THEN $4
    ELSE NULL
  END
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION mag_match(
  FLOAT8, -- magnitude in the first catalog
  FLOAT8, -- magnitude in the second catalog
  FLOAT8) -- acceptable magnitude difference
RETURNS boolean AS $$
  SELECT ABS($1-$2)<$3
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION jhk_match(
  FLOAT8, -- J-band magnitude in the first catalog
  FLOAT8, -- J-band magnitude in the second catalog
  FLOAT8, -- H-band magnitude in the first catalog
  FLOAT8, -- H-band magnitude in the second catalog
  FLOAT8, -- K-band magnitude in the first catalog
  FLOAT8, -- K-band magnitude in the second catalog
  FLOAT8) -- acceptable magnitude difference
RETURNS BOOLEAN AS $$
  SELECT
    COALESCE(mag_match($1,$2,$7),True)
    AND COALESCE(mag_match($3,$4,$7),True)
    AND COALESCE(mag_match($5,$6,$7),True)
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION wrap(
  FLOAT8) -- angle in [0, 360)
RETURNS FLOAT8 AS $$
  SELECT CASE
    WHEN $1 <= 180.0 THEN $1 ELSE $1-360.0 END
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION within_jasmine_field(
  FLOAT8, -- Galactic Longitude
  FLOAT8) -- Galactic Latitude
RETURNS BOOLEAN AS $$
  SELECT
    (($1 BETWEEN -1.4 AND 0.7) AND ($2 BETWEEN -0.6 AND 0.6))
$$ LANGUAGE SQL;
