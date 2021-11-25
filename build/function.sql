CREATE OR REPLACE FUNCTION ifthenelse(
  BIGINT,VARCHAR,VARCHAR)
RETURNS VARCHAR AS $$
  SELECT CASE
    WHEN $1 IS NULL THEN $3 ELSE $2
  END
$$ LANGUAGE SQL;
CREATE OR REPLACE FUNCTION ifthenelse(
  REAL,VARCHAR,VARCHAR)
RETURNS VARCHAR AS $$
  SELECT CASE
    WHEN $1 IS NULL THEN $3 ELSE $2
  END
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION select_better(
  REAL, -- magnitude in the first catalog
  REAL, -- magnitude uncertainty in the first catalog
  REAL, -- magnitude in the second catalog
  REAL) -- magnitude uncertainty in the second catalog
RETURNS REAL AS $$
  SELECT CASE
    WHEN COALESCE($2,1000) < COALESCE($4,1000) THEN $1
    WHEN COALESCE($2,1000) > COALESCE($4,1000) THEN $3
    ELSE NULL
  END
$$ LANGUAGE SQL;
CREATE OR REPLACE FUNCTION select_char(
  REAL,    -- magnitude uncertainty in the first catalog
  REAL,    -- magnitude uncertainty in the second catalog
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
  REAL, -- magnitude in the first catalog
  REAL, -- magnitude in the second catalog
  REAL) -- acceptable magnitude difference
RETURNS boolean AS $$
  SELECT ABS($1-$2)<$3
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION jhk_match(
  REAL, -- J-band magnitude in the first catalog
  REAL, -- J-band magnitude in the second catalog
  REAL, -- H-band magnitude in the first catalog
  REAL, -- H-band magnitude in the second catalog
  REAL, -- K-band magnitude in the first catalog
  REAL, -- K-band magnitude in the second catalog
  REAL) -- acceptable magnitude difference
RETURNS BOOLEAN AS $$
  SELECT
    COALESCE(mag_match($1,$2,$7),True)
    AND COALESCE(mag_match($3,$4,$7),True)
    AND COALESCE(mag_match($5,$6,$7),True)
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION wrap(
  REAL) -- angle in [0, 360)
RETURNS REAL AS $$
  SELECT CASE
    WHEN $1 <= 180.0 THEN $1 ELSE $1-360.0 END
$$ LANGUAGE SQL;
