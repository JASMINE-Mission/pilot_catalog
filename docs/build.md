# Build Database
## Fetch the repository

Clone the [repository][repo] by typing the following line. Otherwise, you can download a zipped archive from the GitHub repository page.

``` console
$ git clone https://github.com/JASMINE-Mission/pilot_catalog
```

[repo]: https://github.com/JASMINE-Mission/pilot_catalog


## Install Docker

Install `Docker` and `docker-compose` in your environment. Refer to the [official page][docker].

[docker]: https://docs.docker.com/get-docker/


## Build PostgreSQL image

Build a docker image for the database. Type the following command in the project root directory. A docker image of PostgreSQL-13 is fetched, and an empty database is build.

``` console
$ make build-psql
```

Then, launch a new terminal and start the PostgreSQL server. Type the following command in the project root directory. The configuration is written in `docker-compose.yaml`. When the SQL server starts without any troubles, you can access it at `localhost:15432`.

``` console
$ docker-compose up
```

## Set up the database
By executing the following line, tables and functions are defined in the database.

``` console
$ make initialize
```

## Catalog
Create a directory `data/catalog` in the repository root. Then, download catalog files. Visit [the catalog download page][download].


[download]: http://exoplanets.sakura.ne.jp/jasmine/


### 2MASS
Download `2mass_psc_jasmine_field.csv` from [the catalog download page][download] and store it in `data/catalog/`. Use the following command to include the 2MASS catalog data into the database.

``` console
$ psql -h localhost -p 15432 -d jasmine -U admin \
    -c "COPY tmass_sources \
    (ra,dec,designation,\
     phot_j_mag,phot_j_cmsig,phot_j_mag_error,phot_j_snr,\
     phot_h_mag,phot_h_cmsig,phot_h_mag_error,phot_h_snr,\
     phot_ks_mag,phot_ks_cmsig,phot_ks_mag_error,phot_ks_snr,\
     quality_flag,contaminated,glon,glat,rd_flg,\
     color_j_h,color_h_ks,color_j_ks) \
    FROM '/data/catalog/2mass_psc_jasmine_field.csv' \
    DELIMITER',' CSV HEADER;"
```

How the CSV file is prepared is described in [the 2MASS page][2mass].

[2mass]: /source/2mass


### VVV
Download `vvv_348dr2_catalog.csv` from [the catalog download page][download] and store it in `data/catalog/`. Use the following command to include the VVV catalog data into the database.

``` console
$ psql -h localhost -p 15432 -d jasmine -U admin \
    -c "COPY vvv_sources \
    (source_id,glon,glat,ra,dec,\
     phot_z_flag,phot_z_mag,phot_z_mag_error,\
     phot_y_flag,phot_y_mag,phot_y_mag_error,\
     phot_j_flag,phot_j_mag,phot_j_mag_error,\
     phot_h_flag,phot_h_mag,phot_h_mag_error,\
     phot_ks_flag,phot_ks_mag,phot_ks_mag_error) \
    FROM '/data/catalog/vvv_348dr2_catalog.csv' \
    DELIMITER ',' CSV HEADER;"
```

How the CSV file is prepared is described in [the VVV page][vvv_dr2].

[vvv_dr2]: /source/vvv_dr2


### SIRIUS
Download `sirius_jasmine_field.csv` from [the catalog download page][download] and store it in `data/catalog/`. The SIRIUS catalog is password protedted. Please contact a member of the JASMINE project. Use the following command to include the SIRIUS catalog data into the database.

``` console
$ psql -h localhost -p 15432 -d jasmine -U admin \
    -c "COPY sirius_sources_orig \
    (glon,glat,ra,dec,position_j_x,position_j_y,phot_j_mag,\
     phot_j_mag_error,position_h_x,position_h_y,phot_h_mag,\
     phot_h_mag_error,position_ks_x,position_ks_y,phot_ks_mag,\
     phot_ks_mag_error,plate_name) \
    FROM '/data/catalog/sirius_jasmine_field.csv' \
    DELIMITER ',' CSV HEADER;"
```

The original catalog contains objects outside of the nominal field. The `sirius_sources` is a view of `sirius_sources_orig`, where objects outside of the JASMINE field are removed.


How the CSV file is prepared is described in [the SIRIUS page][sirius].

[sirius]: /source/sirius


### Gaia DR3
Download `gaia_dr3_jasmine_field.csv` from [the catalog download page][download] and store it in `data/catalog/`. Use the following command to include the Gaia DR3 catalog data into the database.


``` console
$ psql -h localhost -p 15432 -d jasmine -U admin \
    -c "COPY gdr3_sources \
    (source_id,ra,dec,glon,glat,elon,elat,\
     parallax,parallax_error,ruwe,\
     pm,pmra,pmra_error,pmdec,pmdec_error,rv,rv_error,\
     phot_g_mag,phot_g_mag_error,\
     phot_bp_mag,phot_bp_mag_error,\
     phot_rp_mag,phot_rp_mag_error,\
     phot_variable_flag,non_single_star,\
     distance,distance_lower,distance_upper,\
     ag,ag_lower,ag_upper,a0,a0_lower,a0_upper) \
    FROM '/data/catalog/gaia_dr3_gccat.csv' \
    DELIMITER',' CSV HEADER;"
```

How the CSV file is prepared is described in [the Gaia DR3 page][gaia_dr3].

[gaiadr3]: /source/gaia_dr3



## Compile Merged Catalog
A merged catalog is compiled from the 2MASS, VVV, and SIRIUS catalogs. Type the following command.

```
$ make merge
```

The merged catalog contains sources from the three catalogs. Sources that seem identical (within 1.0&Prime;, similar magnitudes) are marged into a single source in the merged catalog. The Hw magnitude is newly defined.


## Configure the database
Type the following commands to set up indeces and a link table connecting the merged catalog and Gaia DR3 catalog. This process is a bit time-consuming.

``` console
$ make index
$ make link
```
