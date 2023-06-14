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
  FLOAT,
  VARCHAR,
  VARCHAR)
RETURNS VARCHAR AS $$
  SELECT CASE
    WHEN $1 IS NULL THEN $3 ELSE $2
  END
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION ifthenelse(
  BOOLEAN,
  FLOAT,
  FLOAT)
RETURNS FLOAT AS $$
  SELECT CASE
    WHEN $1 IS True THEN $2 ELSE $3
  END
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION compute_average(
  FLOAT, -- magnitude in the first catalog
  FLOAT, -- magnitude uncertainty in the first catalog
  FLOAT, -- magnitude in the second catalog
  FLOAT) -- magnitude uncertainty in the second catalog
RETURNS FLOAT AS $$
  SELECT (COALESCE($1*$2,0)+COALESCE($3*$4,0))/(COALESCE($2,1)*COALESCE($4,1))
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
  FLOAT, -- magnitude uncertainty in the first catalog
  FLOAT, -- magnitude uncertainty in the second catalog
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
    (($1 BETWEEN -1.4 AND 0.7) AND ($2 BETWEEN -0.6 AND 0.6))
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION weighted_avg(
  FLOAT, -- magnitude in the first catalog
  FLOAT, -- magnitude uncertainty in the first catalog
  FLOAT, -- magnitude in the second catalog
  FLOAT) -- magnitude uncertainty in the second catalog
RETURNS FLOAT AS $$
  SELECT CASE 
    WHEN ($2 IS NULL) OR ($4 IS NULL) THEN CASE
      WHEN COALESCE($2,1000) < COALESCE($4,1000) THEN $1
      WHEN COALESCE($2,1000) > COALESCE($4,1000) THEN $3
      ELSE CASE 
        WHEN ($1 IS NULL) AND ($3 IS NULL) THEN NULL
        ELSE (COALESCE($1,$3)+COALESCE($3,$1))/2 
        END
      END
    ELSE ($1/$2+$3/$4)/(1/$2+1/$4)
    END
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION select_max(
  FLOAT, -- value in the first catalog
  FLOAT) -- value in the second catalog
RETURNS FLOAT AS $$
  SELECT CASE
    WHEN COALESCE($1,-1000) < COALESCE($2,-1000) THEN $2
    WHEN COALESCE($1,-1000) > COALESCE($2,-1000) THEN $1
    ELSE CASE WHEN ($1 IS NULL) AND ($2 IS NULL) THEN NULL 
      ELSE COALESCE($1,$2) END
  END
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION compute_hw(
  FLOAT, -- J mag
  FLOAT) -- H mag
RETURNS FLOAT AS $$
  SELECT 0.7829*$1 + 0.2171*$2- 0.0323*($1-$2)^2
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION compute_hw_error(
  FLOAT, -- J mag
  FLOAT, -- J mag error
  FLOAT, -- H mag
  FLOAT) -- H mag error
RETURNS FLOAT AS $$
  SELECT sqrt(0.035^2 + (0.7829*$2)^2 + (0.2171*$4)^2 + (0.0323*2*($1-$3)*$2)^2 + (0.0323*2*($1-$3)*$4)^2)
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION compute_glon(
  FLOAT, -- RA (deg)
  FLOAT) -- DEC (deg)
RETURNS FLOAT AS $$
  SELECT ATAN2((+0.4941094278755837*COS(RADIANS($1))-0.4448296299600112*SIN(RADIANS($1)))*COS($2)+0.7469822444972189*SIN($2),(-0.0548755604162154*COS(RADIANS($1))-0.8734370902348850*SIN(RADIANS($1)))*COS($2)-0.4838350155487132*SIN($2))
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION compute_glat(
  FLOAT, -- RA (deg)
  FLOAT) -- DEC (deg)
RETURNS FLOAT AS $$
  SELECT ATAN2((-0.8676661490190047*COS(RADIANS($1))-0.1980763734312015*SIN(RADIANS($1)))*COS(RADIANS($2))+0.4559837761750669*SIN(RADIANS($2)),SQRT(POWER((+0.4941094278755837*COS(RADIANS($1))-0.4448296299600112*SIN(RADIANS($1)))*COS($2)+0.7469822444972189*SIN($2),2)+POWER((-0.0548755604162154*COS(RADIANS($1))-0.8734370902348850*SIN(RADIANS($1)))*COS($2)-0.4838350155487132*SIN($2),2)))
$$ LANGUAGE SQL;


