# VVV catalogue DR2

## Schema

## Source
[Vizier][tapvizier]

``` sql
SELECT
  srcid as source_id,
  GLON as glon,
  GLAT as glat,
  RAJ2000 as ra,
  DEJ2000 as dec,
  Zmag3 as phot_z_mag,
  e_Zmag3 as phot_z_mag_error,
  Ymag3 as phot_y_mag,
  e_Ymag3 as phot_y_mag_error,
  Jmag3 as phot_j_mag,
  e_Jmag3 as phot_j_mag_error,
  Hmag3 as phot_h_mag,
  e_Hmag3 as phot_h_mag_error,
  Ksmag3 as phot_ks_mag,
  e_Ksmag3 as phot_ks_mag_error
FROM
  "II/348/vvv2"
WHERE
   1 = CONTAINS(
         POINT('FK5', RAJ2000, DEJ2000),
         POLYGON('FK5',
           268.28239829, -28.5243427,
           265.95589414, -27.28605622,
           263.70668889, -30.41734933,
           266.07860638, -31.69475218))
```

[tapvizier]: http://tapvizier.u-strasbg.fr/adql/
