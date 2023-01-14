CREATE OR REPLACE FUNCTION ifthenelse(
  BIGINT,VARCHAR,VARCHAR)
RETURNS VARCHAR AS $$
  SELECT CASE
    WHEN $1 IS NULL THEN $3 ELSE $2
  END
$$ LANGUAGE SQL;
CREATE OR REPLACE FUNCTION ifthenelse(
  FLOAT,VARCHAR,VARCHAR)
RETURNS VARCHAR AS $$
  SELECT CASE
    WHEN $1 IS NULL THEN $3 ELSE $2
  END
$$ LANGUAGE SQL;
CREATE OR REPLACE FUNCTION ifthenelse(
  BOOLEAN,FLOAT,FLOAT)
RETURNS FLOAT AS $$
  SELECT CASE
    WHEN $1 IS True THEN $2 ELSE $3
  END
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION select_better(
  FLOAT, -- magnitude in the first catalog
  FLOAT, -- magnitude uncertainty in the first catalog
  FLOAT, -- magnitude in the second catalog
  FLOAT) -- magnitude uncertainty in the second catalog
RETURNS FLOAT AS $$
  SELECT CASE
    WHEN COALESCE($2,1000) < COALESCE($4,1000) THEN $1
    WHEN COALESCE($2,1000) > COALESCE($4,1000) THEN $3
    ELSE NULL
  END
$$ LANGUAGE SQL;
CREATE OR REPLACE FUNCTION select_char(
  FLOAT,    -- magnitude uncertainty in the first catalog
  FLOAT,    -- magnitude uncertainty in the second catalog
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
  FLOAT, -- magnitude in the first catalog
  FLOAT, -- magnitude in the second catalog
  FLOAT) -- acceptable magnitude difference
RETURNS boolean AS $$
  SELECT ABS($1-$2)<$3
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION jhk_match(
  FLOAT, -- J-band magnitude in the first catalog
  FLOAT, -- J-band magnitude in the second catalog
  FLOAT, -- H-band magnitude in the first catalog
  FLOAT, -- H-band magnitude in the second catalog
  FLOAT, -- K-band magnitude in the first catalog
  FLOAT, -- K-band magnitude in the second catalog
  FLOAT) -- acceptable magnitude difference
RETURNS BOOLEAN AS $$
  SELECT
    COALESCE(mag_match($1,$2,$7),True)
    AND COALESCE(mag_match($3,$4,$7),True)
    AND COALESCE(mag_match($5,$6,$7),True)
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION wrap(
  FLOAT) -- angle in [0, 360)
RETURNS FLOAT AS $$
  SELECT CASE
    WHEN $1 <= 180.0 THEN $1 ELSE $1-360.0 END
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION within_jasmine_field(
  FLOAT, -- Galactic Longitude
  FLOAT) -- Galactic Latitude
RETURNS BOOLEAN AS $$
  SELECT
    q3c_radial_query($1,$2,0.0,0.0,0.7)
    OR (($1 BETWEEN -2.0 AND 0.0) AND ($2 BETWEEN 0.0 AND 0.3))
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION within_jasmine_region_1(
  FLOAT, -- Galactic Longitude
  FLOAT) -- Galactic Latitude
RETURNS BOOLEAN AS $$
  SELECT
    q3c_radial_query($1,$2,0.0,0.0,0.7)
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION within_jasmine_region_2(
  FLOAT, -- Galactic Longitude
  FLOAT) -- Galactic Latitude
RETURNS BOOLEAN AS $$
  SELECT
    (($1 BETWEEN -2.0 AND 0.0) AND ($2 BETWEEN 0.0 AND 0.3))
$$ LANGUAGE SQL;
