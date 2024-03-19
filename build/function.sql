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


CREATE OR REPLACE FUNCTION select_better_final(
  agg_state_arr FLOAT[] --current state (mag,mag_error)
)
RETURNS FLOAT AS $$
  SELECT agg_state_arr[1]
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION select_better(
  FLOAT, -- magnitude in the first catalog
  FLOAT, -- magnitude uncertainty in the first catalog
  FLOAT, -- magnitude in the second catalog
  FLOAT) -- magnitude uncertainty in the second catalog
RETURNS FLOAT AS $$
  SELECT CASE
    WHEN COALESCE($2,1000) < COALESCE($4,1000) THEN $1
    WHEN COALESCE($2,1000) >= COALESCE($4,1000) THEN $3
    ELSE NULL
  END
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION select_better_statetransition(
  agg_state_arr FLOAT[], --current state (mag,mag_error)
  next_mag FLOAT, -- contender for best mag
  next_err FLOAT) -- error in the contender's mag
RETURNS FLOAT[] AS $$
  SELECT CASE
    WHEN COALESCE(agg_state_arr[2],1000) >= COALESCE(next_err,1000) THEN ARRAY[next_mag::FLOAT,next_err::FLOAT]
    ELSE agg_state_arr
  END
$$ LANGUAGE SQL;

DROP AGGREGATE IF EXISTS select_better_agg(double precision,double precision);
CREATE OR REPLACE AGGREGATE select_better_agg(FLOAT,FLOAT)(
  sfunc = select_better_statetransition,
  stype = FLOAT[],
  initcond = '{-1.0,NULL}',
  finalfunc = select_better_final
);

create type my_type as (
    field_1        TEXT,
    field_2        FLOAT
);


CREATE OR REPLACE FUNCTION select_better_text(
  TEXT, -- value in the first catalog
  FLOAT, -- magnitude uncertainty in the first catalog
  TEXT, -- value in the second catalog
  FLOAT) -- magnitude uncertainty in the second catalog
RETURNS TEXT AS $$
  SELECT CASE
    WHEN COALESCE($2,1000) < COALESCE($4,1000) THEN $1
    WHEN COALESCE($2,1000) >= COALESCE($4,1000) THEN $3
    ELSE NULL
  END
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION select_better_text_statetransition(
  agg_state_arr my_type[], --current state (quantity,mag_error)
  next_val TEXT, -- contender for best mag
  next_err FLOAT) -- error in the contender's mag
RETURNS FLOAT[] AS $$
  SELECT CASE
    WHEN COALESCE(agg_state_arr[2],1000) >= COALESCE(next_err,1000) THEN ARRAY[next_val::TEXT,next_err::FLOAT]
    ELSE agg_state_arr
  END
$$ LANGUAGE SQL;

DROP AGGREGATE IF EXISTS select_better_text_agg(TEXT,FLOAT);
CREATE OR REPLACE AGGREGATE select_better_text_agg(TEXT,FLOAT)(
  sfunc = select_better_text_statetransition,
  stype = my_type[],
  finalfunc = select_better_final
);

CREATE OR REPLACE FUNCTION select_worst(
  FLOAT, -- magnitude in the first catalog
  FLOAT, -- magnitude uncertainty in the first catalog
  FLOAT, -- magnitude in the second catalog
  FLOAT) -- magnitude uncertainty in the second catalog
RETURNS FLOAT AS $$
  SELECT CASE
    WHEN COALESCE($2,1000) > COALESCE($4,1000) THEN $1
    WHEN COALESCE($2,1000) <= COALESCE($4,1000) THEN $3
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


CREATE OR REPLACE FUNCTION weighted_avg_vector(quantity numeric[],weights numeric[])
  RETURNS numeric
  LANGUAGE SQL
  IMMUTABLE
AS $$
SELECT 
  CASE WHEN (ARRAY_REMOVE(weights, NULL) = '{}') AND (ARRAY_REMOVE(quantity, NULL) != '{}') 
    THEN AVG(q)          -- if no weights are provided, then take the simple average
    ELSE SUM(q*w)/SUM(w) -- assumes that when q is null, w is also null
  END
  FROM UNNEST(quantity,weights) AS t(q,w)
$$;

CREATE OR REPLACE FUNCTION weighted_avg_error_vector(weights numeric[])
  RETURNS numeric
  LANGUAGE SQL
  IMMUTABLE
AS $$
SELECT 1/SUM(w) FROM UNNEST(weights) AS t(w)
$$;

CREATE OR REPLACE FUNCTION weighted_avg(
  FLOAT, -- quantity in the first catalog
  FLOAT, -- weight in the first catalog
  FLOAT, -- quantity in the second catalog
  FLOAT) -- weight in the second catalog
RETURNS FLOAT AS $$
  SELECT CASE 
    WHEN ($2 IS NULL) OR ($4 IS NULL) THEN 
      CASE
        WHEN $4 IS NULL THEN $1
        WHEN $2 IS NULL THEN $3
      ELSE CASE 
        WHEN ($1 IS NULL) AND ($3 IS NULL) THEN NULL --everything is null
        ELSE ROUND((COALESCE($1,$3)+COALESCE($3,$1))::numeric/2,3) --only errors are null
        END
      END
    ELSE ROUND((($1*$2+$3*$4)/($2+$4))::numeric,3)
    END
$$ LANGUAGE SQL
IMMUTABLE;

CREATE OR REPLACE FUNCTION weighted_avg_error(
  FLOAT, -- weight in the first catalog
  FLOAT) -- weight in the second catalog
RETURNS FLOAT AS $$
  SELECT CASE 
    WHEN ($1 IS NULL) AND ($2 IS NULL) THEN 
      NULL --everything is null
    ELSE 1/(COALESCE($1,0)+COALESCE($2,0))
    END
$$ LANGUAGE SQL
IMMUTABLE;


CREATE OR REPLACE FUNCTION weighted_avg3(
  FLOAT, -- quantity in the first catalog
  FLOAT, -- weight in the first catalog
  FLOAT, -- quantity in the second catalog
  FLOAT, -- weight in the second catalog
  FLOAT, -- quantity in the third catalog
  FLOAT) -- weight in the third catalog
RETURNS FLOAT AS $$
  SELECT CASE 
    WHEN ($2 IS NULL) AND ($4 IS NULL) AND ($6 IS NULL) THEN --only errors are null
        ROUND(NULLIF((COALESCE($1,0)+COALESCE($3,0)+COALESCE($5,0))::numeric/NULLIF(COALESCE($1/$1,0)+COALESCE($2/$2,0)+COALESCE($3/$3,0),0),0)::numeric,3)
      ELSE
        ROUND(NULLIF((COALESCE($1*$2,0)+COALESCE($3*$4,0)+COALESCE($5*$6,0))/NULLIF((COALESCE($2,0)*COALESCE($1/$1,0)+COALESCE($4,0)*COALESCE($3/$3,0)+COALESCE($6,0)*COALESCE($5/$5,0)),0),0)::numeric,3)
    END
$$ LANGUAGE SQL
IMMUTABLE;

CREATE OR REPLACE FUNCTION weighted_avg_error3(
  FLOAT, -- weight in the first catalog
  FLOAT, -- weight in the second catalog
  FLOAT) -- weight in the third catalog
RETURNS FLOAT AS $$
  SELECT CASE 
    WHEN ($1 IS NULL) AND ($2 IS NULL) AND ($3 IS NULL) THEN --only errors are null
        NULL
      ELSE
        1/NULLIF(COALESCE($1,0)+COALESCE($2,0)+COALESCE($3,0),0)
    END
$$ LANGUAGE SQL
IMMUTABLE;


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
$$ LANGUAGE SQL
IMMUTABLE;

CREATE OR REPLACE FUNCTION compute_hw(
  FLOAT, -- J mag
  FLOAT) -- H mag
RETURNS FLOAT AS $$
  SELECT 0.7829*$1 + 0.2171*$2- 0.0323*($1-$2)^2
$$ LANGUAGE SQL
IMMUTABLE;

CREATE OR REPLACE FUNCTION compute_hw_error(
  FLOAT, -- J mag
  FLOAT, -- J mag error
  FLOAT, -- H mag
  FLOAT) -- H mag error
RETURNS FLOAT AS $$
  SELECT sqrt(0.035^2 + (0.7829*$2)^2 + (0.2171*$4)^2 + (0.0323*2*($1-$3)*$2)^2 + (0.0323*2*($1-$3)*$4)^2)
$$ LANGUAGE SQL
IMMUTABLE;

CREATE OR REPLACE FUNCTION correct_jmag(
  FLOAT, -- vvv jmag
  FLOAT  -- 2MASS or SIRIUS jmag
  -- a = 0.160, b = -4.035, c = 25.396
)
RETURNS FLOAT AS $$
  SELECT CASE WHEN ($2 IS NULL OR $2>12) THEN $1 ELSE $1-(0.160*POWER($2,2) - 4.035*$2 + 25.396) END
$$ LANGUAGE SQL
IMMUTABLE;

CREATE OR REPLACE FUNCTION correct_hmag(
  FLOAT, -- vvv hmag
  FLOAT  -- 2MASS or SIRIUS hmag
  -- a = 0.145, b = -3.699, c = 23.547
)
RETURNS FLOAT AS $$
  SELECT CASE WHEN ($2 IS NULL OR $2>12) THEN $1 ELSE $1-(0.145*POWER($2,2) - 3.699*$2 + 23.547) END
$$ LANGUAGE SQL
IMMUTABLE;

CREATE OR REPLACE FUNCTION correct_ksmag(
  FLOAT, -- vvv ksmag
  FLOAT  -- 2MASS or SIRIUS ksmag
  -- a = 0.158, b = -3.746, c = 22.223
)
RETURNS FLOAT AS $$
  SELECT CASE WHEN ($2 IS NULL OR $2>12) THEN $1 ELSE $1-(0.158*POWER($2,2) - 3.746*$2 + 22.223) END
$$ LANGUAGE SQL
IMMUTABLE;


CREATE OR REPLACE FUNCTION compute_glon(
  FLOAT, -- RA (deg)
  FLOAT) -- DEC (deg)
RETURNS FLOAT AS $$
  SELECT DEGREES(ATAN2((+0.4941094278755837*COS(RADIANS($1))-0.4448296299600112*SIN(RADIANS($1)))*COS(RADIANS($2))+0.7469822444972189*SIN(RADIANS($2)), (-0.0548755604162154*COS(RADIANS($1))-0.8734370902348850*SIN(RADIANS($1)))*COS(RADIANS($2))-0.4838350155487132*SIN(RADIANS($2))))
$$ LANGUAGE SQL
IMMUTABLE;

CREATE OR REPLACE FUNCTION compute_glat(
  FLOAT, -- RA (deg)
  FLOAT) -- DEC (deg)
RETURNS FLOAT AS $$
  SELECT DEGREES(ATAN2((-0.8676661490190047*COS(RADIANS($1))-0.1980763734312015*SIN(RADIANS($1)))*COS(RADIANS($2))+0.4559837761750669*SIN(RADIANS($2)),SQRT(POWER((+0.4941094278755837*COS(RADIANS($1))-0.4448296299600112*SIN(RADIANS($1)))*COS(RADIANS($2))+0.7469822444972189*SIN(RADIANS($2)),2)+POWER((-0.0548755604162154*COS(RADIANS($1))-0.8734370902348850*SIN(RADIANS($1)))*COS(RADIANS($2))-0.4838350155487132*SIN(RADIANS($2)),2))))
$$ LANGUAGE SQL
IMMUTABLE;


