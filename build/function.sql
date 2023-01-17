CREATE OR REPLACE FUNCTION ifthenelse(
  BIGINT,
  VARCHAR,
  VARCHAR)
RETURNS VARCHAR AS $$
  SELECT CASE
    WHEN $1 IS NULL THEN $3 ELSE $2
  END
$$ LANGUAGE SQL;
CREATE OR REPLACE FUNCTION ifthenelse(
  DOUBLE PRECISION,
  VARCHAR,
  VARCHAR)
RETURNS VARCHAR AS $$
  SELECT CASE
    WHEN $1 IS NULL THEN $3 ELSE $2
  END
$$ LANGUAGE SQL;
CREATE OR REPLACE FUNCTION ifthenelse(
  BOOLEAN,
  DOUBLE PRECISION,
  DOUBLE PRECISION)
RETURNS DOUBLE PRECISION AS $$
  SELECT CASE
    WHEN $1 IS True THEN $2 ELSE $3
  END
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION select_better(
  DOUBLE PRECISION, -- magnitude in the first catalog
  DOUBLE PRECISION, -- magnitude uncertainty in the first catalog
  DOUBLE PRECISION, -- magnitude in the second catalog
  DOUBLE PRECISION) -- magnitude uncertainty in the second catalog
RETURNS DOUBLE PRECISION AS $$
  SELECT CASE
    WHEN COALESCE($2,1000) < COALESCE($4,1000) THEN $1
    WHEN COALESCE($2,1000) > COALESCE($4,1000) THEN $3
    ELSE NULL
  END
$$ LANGUAGE SQL;
CREATE OR REPLACE FUNCTION select_char(
  DOUBLE PRECISION, -- magnitude uncertainty in the first catalog
  DOUBLE PRECISION, -- magnitude uncertainty in the second catalog
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
  DOUBLE PRECISION, -- magnitude in the first catalog
  DOUBLE PRECISION, -- magnitude in the second catalog
  DOUBLE PRECISION) -- acceptable magnitude difference
RETURNS boolean AS $$
  SELECT ABS($1-$2)<$3
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION jhk_match(
  DOUBLE PRECISION, -- J-band magnitude in the first catalog
  DOUBLE PRECISION, -- J-band magnitude in the second catalog
  DOUBLE PRECISION, -- H-band magnitude in the first catalog
  DOUBLE PRECISION, -- H-band magnitude in the second catalog
  DOUBLE PRECISION, -- K-band magnitude in the first catalog
  DOUBLE PRECISION, -- K-band magnitude in the second catalog
  DOUBLE PRECISION) -- acceptable magnitude difference
RETURNS BOOLEAN AS $$
  SELECT
    COALESCE(mag_match($1,$2,$7),True)
    AND COALESCE(mag_match($3,$4,$7),True)
    AND COALESCE(mag_match($5,$6,$7),True)
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION wrap(
  DOUBLE PRECISION) -- angle in [0, 360)
RETURNS DOUBLE PRECISION AS $$
  SELECT CASE
    WHEN $1 <= 180.0 THEN $1 ELSE $1-360.0 END
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION within_jasmine_field(
  DOUBLE PRECISION, -- Galactic Longitude
  DOUBLE PRECISION) -- Galactic Latitude
RETURNS BOOLEAN AS $$
  SELECT
    (($1 BETWEEN -1.4 AND 0.7) AND ($2 BETWEEN -0.6 AND 0.6))
$$ LANGUAGE SQL;
