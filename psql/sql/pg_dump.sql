BEGIN;
--
-- PostgreSQL database dump
--

-- Dumped from database version 13.5 (Debian 13.5-1.pgdg110+1)
-- Dumped by pg_dump version 13.5 (Debian 13.5-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: q3c; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS q3c WITH SCHEMA public;


--
-- Name: EXTENSION q3c; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION q3c IS 'q3c sky indexing plugin';


--
-- Name: choice(integer, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.choice(integer, integer, character varying, character varying) RETURNS character varying
    LANGUAGE sql
    AS $_$                                                           
  SELECT CASE                                                                   
    WHEN $1 IS NULL THEN $3 ELSE $4                                             
  END                                                                           
$_$;


ALTER FUNCTION public.choice(integer, integer, character varying, character varying) OWNER TO admin;

--
-- Name: ifthenelse(real, character varying, character varying); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.ifthenelse(real, character varying, character varying) RETURNS character varying
    LANGUAGE sql
    AS $_$
  SELECT CASE
    WHEN $1 IS NULL THEN $3 ELSE $2
  END
$_$;


ALTER FUNCTION public.ifthenelse(real, character varying, character varying) OWNER TO admin;

--
-- Name: ifthenelse(double precision, character varying, character varying); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.ifthenelse(double precision, character varying, character varying) RETURNS character varying
    LANGUAGE sql
    AS $_$
  SELECT CASE
    WHEN $1 IS NULL THEN $3 ELSE $2
  END
$_$;


ALTER FUNCTION public.ifthenelse(double precision, character varying, character varying) OWNER TO admin;

--
-- Name: ifthenelse(integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.ifthenelse(integer, character varying, character varying) RETURNS character varying
    LANGUAGE sql
    AS $_$                                                                                             
  SELECT CASE                                                                                                     
    WHEN $1 IS NULL THEN $2 ELSE $3                                                                               
  END                                                                                                             
$_$;


ALTER FUNCTION public.ifthenelse(integer, character varying, character varying) OWNER TO admin;

--
-- Name: ifthenelse(bigint, character varying, character varying); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.ifthenelse(bigint, character varying, character varying) RETURNS character varying
    LANGUAGE sql
    AS $_$
  SELECT CASE
    WHEN $1 IS NULL THEN $3 ELSE $2
  END
$_$;


ALTER FUNCTION public.ifthenelse(bigint, character varying, character varying) OWNER TO admin;

--
-- Name: ifthenelse(integer, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.ifthenelse(integer, integer, character varying, character varying) RETURNS character varying
    LANGUAGE sql
    AS $_$                                                           
  SELECT CASE                                                                   
    WHEN $1 IS NULL THEN $3 ELSE $4                                             
  END                                                                           
$_$;


ALTER FUNCTION public.ifthenelse(integer, integer, character varying, character varying) OWNER TO admin;

--
-- Name: jasmine_field(real, real); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.jasmine_field(real, real) RETURNS boolean
    LANGUAGE sql
    AS $_$
  SELECT
    q3c_radial_query($1,$2,0.0,0.0,0.7)
    OR (($1 BETWEEN -2.0 AND 0.0) AND ($2 BETWEEN 0.0 AND 0.3))
$_$;


ALTER FUNCTION public.jasmine_field(real, real) OWNER TO admin;

--
-- Name: jasmine_field_1(real, real); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.jasmine_field_1(real, real) RETURNS boolean
    LANGUAGE sql
    AS $_$
  SELECT
    q3c_radial_query($1,$2,0.0,0.0,0.7)
$_$;


ALTER FUNCTION public.jasmine_field_1(real, real) OWNER TO admin;

--
-- Name: jasmine_field_2(real, real); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.jasmine_field_2(real, real) RETURNS boolean
    LANGUAGE sql
    AS $_$
  SELECT
    (($1 BETWEEN -2.0 AND 0.0) AND ($2 BETWEEN 0.0 AND 0.3))
$_$;


ALTER FUNCTION public.jasmine_field_2(real, real) OWNER TO admin;

--
-- Name: jhk_match(real, real, real, real, real, real, real); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.jhk_match(real, real, real, real, real, real, real) RETURNS boolean
    LANGUAGE sql
    AS $_$
  SELECT
    COALESCE(mag_match($1,$2,$7),True)
    AND COALESCE(mag_match($3,$4,$7),True)
    AND COALESCE(mag_match($5,$6,$7),True)
$_$;


ALTER FUNCTION public.jhk_match(real, real, real, real, real, real, real) OWNER TO admin;

--
-- Name: jhk_match(double precision, double precision, double precision, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.jhk_match(double precision, double precision, double precision, double precision, double precision, double precision, double precision) RETURNS boolean
    LANGUAGE sql
    AS $_$
  SELECT
    COALESCE(mag_match($1,$2,$7),True)
    AND COALESCE(mag_match($3,$4,$7),True)
    AND COALESCE(mag_match($5,$6,$7),True)
$_$;


ALTER FUNCTION public.jhk_match(double precision, double precision, double precision, double precision, double precision, double precision, double precision) OWNER TO admin;

--
-- Name: jhk_match(numeric, numeric, numeric, numeric, numeric, numeric, numeric); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.jhk_match(numeric, numeric, numeric, numeric, numeric, numeric, numeric) RETURNS boolean
    LANGUAGE sql
    AS $_$                                                         
  SELECT                                                                        
    COALESCE(                                                                   
      COALESCE(mag_match($1,$2,$7),True)                                        
      AND COALESCE(mag_match($3,$4,$7),True)                                    
      AND COALESCE(mag_match($5,$6,$7),True),                                   
      True)                                                                     
$_$;


ALTER FUNCTION public.jhk_match(numeric, numeric, numeric, numeric, numeric, numeric, numeric) OWNER TO admin;

--
-- Name: mag_match(real, real, real); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.mag_match(real, real, real) RETURNS boolean
    LANGUAGE sql
    AS $_$
  SELECT ABS($1-$2)<$3
$_$;


ALTER FUNCTION public.mag_match(real, real, real) OWNER TO admin;

--
-- Name: mag_match(double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.mag_match(double precision, double precision, double precision) RETURNS boolean
    LANGUAGE sql
    AS $_$
  SELECT ABS($1-$2)<$3
$_$;


ALTER FUNCTION public.mag_match(double precision, double precision, double precision) OWNER TO admin;

--
-- Name: mag_match(numeric, numeric, numeric); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.mag_match(numeric, numeric, numeric) RETURNS boolean
    LANGUAGE sql
    AS $_$                                                         
  SELECT ABS($1-$2)<$3                                                          
$_$;


ALTER FUNCTION public.mag_match(numeric, numeric, numeric) OWNER TO admin;

--
-- Name: select_better(real, real, real, real); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.select_better(real, real, real, real) RETURNS real
    LANGUAGE sql
    AS $_$
  SELECT CASE
    WHEN COALESCE($2,1000) < COALESCE($4,1000) THEN $1
    WHEN COALESCE($2,1000) > COALESCE($4,1000) THEN $3
    ELSE NULL
  END
$_$;


ALTER FUNCTION public.select_better(real, real, real, real) OWNER TO admin;

--
-- Name: select_better(double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.select_better(double precision, double precision, double precision, double precision) RETURNS double precision
    LANGUAGE sql
    AS $_$
  SELECT CASE
    WHEN COALESCE($2,1000) < COALESCE($4,1000) THEN $1
    WHEN COALESCE($2,1000) > COALESCE($4,1000) THEN $3
    ELSE NULL
  END
$_$;


ALTER FUNCTION public.select_better(double precision, double precision, double precision, double precision) OWNER TO admin;

--
-- Name: select_char(real, real, character varying, character varying); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.select_char(real, real, character varying, character varying) RETURNS character varying
    LANGUAGE sql
    AS $_$
  SELECT CASE
    WHEN COALESCE($1,1000) < COALESCE($2,1000) THEN $3
    WHEN COALESCE($1,1000) > COALESCE($2,1000) THEN $4
    ELSE NULL
  END
$_$;


ALTER FUNCTION public.select_char(real, real, character varying, character varying) OWNER TO admin;

--
-- Name: select_char(double precision, double precision, character varying, character varying); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.select_char(double precision, double precision, character varying, character varying) RETURNS character varying
    LANGUAGE sql
    AS $_$
  SELECT CASE
    WHEN COALESCE($1,1000) < COALESCE($2,1000) THEN $3
    WHEN COALESCE($1,1000) > COALESCE($2,1000) THEN $4
    ELSE NULL
  END
$_$;


ALTER FUNCTION public.select_char(double precision, double precision, character varying, character varying) OWNER TO admin;

--
-- Name: within_jasmine_field(real, real); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.within_jasmine_field(real, real) RETURNS boolean
    LANGUAGE sql
    AS $_$
  SELECT
    q3c_radial_query($1,$2,0.0,0.0,0.7)
    OR (($1 BETWEEN -2.0 AND 0.0) AND ($2 BETWEEN 0.0 AND 0.3))
$_$;


ALTER FUNCTION public.within_jasmine_field(real, real) OWNER TO admin;

--
-- Name: within_jasmine_field(double precision, double precision); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.within_jasmine_field(double precision, double precision) RETURNS boolean
    LANGUAGE sql
    AS $_$
  SELECT
    q3c_radial_query($1,$2,0.0,0.0,0.7)
    OR (($1 BETWEEN -2.0 AND 0.0) AND ($2 BETWEEN 0.0 AND 0.3))
$_$;


ALTER FUNCTION public.within_jasmine_field(double precision, double precision) OWNER TO admin;

--
-- Name: within_jasmine_region_1(real, real); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.within_jasmine_region_1(real, real) RETURNS boolean
    LANGUAGE sql
    AS $_$
  SELECT
    q3c_radial_query($1,$2,0.0,0.0,0.7)
$_$;


ALTER FUNCTION public.within_jasmine_region_1(real, real) OWNER TO admin;

--
-- Name: within_jasmine_region_1(double precision, double precision); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.within_jasmine_region_1(double precision, double precision) RETURNS boolean
    LANGUAGE sql
    AS $_$
  SELECT
    q3c_radial_query($1,$2,0.0,0.0,0.7)
$_$;


ALTER FUNCTION public.within_jasmine_region_1(double precision, double precision) OWNER TO admin;

--
-- Name: within_jasmine_region_2(real, real); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.within_jasmine_region_2(real, real) RETURNS boolean
    LANGUAGE sql
    AS $_$
  SELECT
    (($1 BETWEEN -2.0 AND 0.0) AND ($2 BETWEEN 0.0 AND 0.3))
$_$;


ALTER FUNCTION public.within_jasmine_region_2(real, real) OWNER TO admin;

--
-- Name: within_jasmine_region_2(double precision, double precision); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.within_jasmine_region_2(double precision, double precision) RETURNS boolean
    LANGUAGE sql
    AS $_$
  SELECT
    (($1 BETWEEN -2.0 AND 0.0) AND ($2 BETWEEN 0.0 AND 0.3))
$_$;


ALTER FUNCTION public.within_jasmine_region_2(double precision, double precision) OWNER TO admin;

--
-- Name: wrap(real); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.wrap(real) RETURNS real
    LANGUAGE sql
    AS $_$
  SELECT CASE
    WHEN $1 <= 180.0 THEN $1 ELSE $1-360.0 END
$_$;


ALTER FUNCTION public.wrap(real) OWNER TO admin;

--
-- Name: wrap(double precision); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.wrap(double precision) RETURNS double precision
    LANGUAGE sql
    AS $_$
  SELECT CASE
    WHEN $1 <= 180.0 THEN $1 ELSE $1-360.0 END
$_$;


ALTER FUNCTION public.wrap(double precision) OWNER TO admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: edr3_sources; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.edr3_sources (
    source_id bigint NOT NULL,
    ra real NOT NULL,
    "dec" real NOT NULL,
    glon real NOT NULL,
    glat real NOT NULL,
    parallax real,
    parallax_error real,
    pm real,
    pmra real,
    pmra_error real,
    pmdec real,
    pmdec_error real,
    phot_g_mag real,
    phot_g_mag_error real,
    phot_bp_mag real,
    phot_bp_mag_error real,
    phot_rp_mag real,
    phot_rp_mag_error real
);


ALTER TABLE public.edr3_sources OWNER TO admin;

--
-- Name: merged_sources; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.merged_sources (
    source_id bigint NOT NULL,
    tmass_source_id bigint,
    sirius_source_id bigint,
    vvv_source_id bigint,
    glon real,
    glat real,
    ra real,
    "dec" real,
    position_source character varying(1),
    phot_hw_mag real,
    phot_hw_mag_error real,
    phot_hw_mag_source character varying(1),
    phot_j_mag real,
    phot_j_mag_error real,
    phot_j_mag_source character varying(1),
    phot_h_mag real,
    phot_h_mag_error real,
    phot_h_mag_source character varying(1),
    phot_ks_mag real,
    phot_ks_mag_error real,
    phot_ks_mag_source character varying(1)
);


ALTER TABLE public.merged_sources OWNER TO admin;

--
-- Name: merged_sources_source_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.merged_sources_source_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.merged_sources_source_id_seq OWNER TO admin;

--
-- Name: merged_sources_source_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.merged_sources_source_id_seq OWNED BY public.merged_sources.source_id;


--
-- Name: sirius_sources_orig; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.sirius_sources_orig (
    source_id bigint NOT NULL,
    glon real NOT NULL,
    glat real NOT NULL,
    ra real NOT NULL,
    "dec" real NOT NULL,
    position_j_x real,
    position_j_y real,
    phot_j_mag real,
    phot_j_mag_error real,
    position_h_x real,
    position_h_y real,
    phot_h_mag real,
    phot_h_mag_error real,
    position_ks_x real,
    position_ks_y real,
    phot_ks_mag real,
    phot_ks_mag_error real,
    plate_name character varying(16) NOT NULL
);


ALTER TABLE public.sirius_sources_orig OWNER TO admin;

--
-- Name: sirius_sources; Type: MATERIALIZED VIEW; Schema: public; Owner: admin
--

CREATE MATERIALIZED VIEW public.sirius_sources AS
 SELECT sirius_sources_orig.source_id,
    sirius_sources_orig.glon,
    sirius_sources_orig.glat,
    sirius_sources_orig.ra,
    sirius_sources_orig."dec",
    sirius_sources_orig.position_j_x,
    sirius_sources_orig.position_j_y,
    sirius_sources_orig.phot_j_mag,
    sirius_sources_orig.phot_j_mag_error,
    sirius_sources_orig.position_h_x,
    sirius_sources_orig.position_h_y,
    sirius_sources_orig.phot_h_mag,
    sirius_sources_orig.phot_h_mag_error,
    sirius_sources_orig.position_ks_x,
    sirius_sources_orig.position_ks_y,
    sirius_sources_orig.phot_ks_mag,
    sirius_sources_orig.phot_ks_mag_error,
    sirius_sources_orig.plate_name
   FROM public.sirius_sources_orig
  WHERE (((sirius_sources_orig.glon >= ('-2.5'::numeric)::double precision) AND (sirius_sources_orig.glon <= (1.2)::double precision)) AND ((sirius_sources_orig.glat >= ('-1.2'::numeric)::double precision) AND (sirius_sources_orig.glat <= (1.2)::double precision)))
  WITH NO DATA;


ALTER TABLE public.sirius_sources OWNER TO admin;

--
-- Name: sirius_sources_orig_source_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.sirius_sources_orig_source_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sirius_sources_orig_source_id_seq OWNER TO admin;

--
-- Name: sirius_sources_orig_source_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.sirius_sources_orig_source_id_seq OWNED BY public.sirius_sources_orig.source_id;


--
-- Name: tmass_sources; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.tmass_sources (
    source_id bigint NOT NULL,
    ra real NOT NULL,
    "dec" real NOT NULL,
    designation character varying(32) NOT NULL,
    phot_j_mag real,
    phot_j_cmsig real,
    phot_j_mag_error real,
    phot_j_snr real,
    phot_h_mag real,
    phot_h_cmsig real,
    phot_h_mag_error real,
    phot_h_snr real,
    phot_ks_mag real,
    phot_ks_cmsig real,
    phot_ks_mag_error real,
    phot_ks_snr real,
    quality_flag character varying(3) NOT NULL,
    contaminated integer NOT NULL,
    glon real NOT NULL,
    glat real NOT NULL,
    rd_flg character varying(3) NOT NULL,
    color_j_h real,
    color_h_ks real,
    color_j_ks real
);


ALTER TABLE public.tmass_sources OWNER TO admin;

--
-- Name: tmass_sources_source_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.tmass_sources_source_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tmass_sources_source_id_seq OWNER TO admin;

--
-- Name: tmass_sources_source_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.tmass_sources_source_id_seq OWNED BY public.tmass_sources.source_id;


--
-- Name: virac_sources; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.virac_sources (
    source_id bigint NOT NULL,
    ra real NOT NULL,
    "dec" real NOT NULL,
    pm real,
    pmra real,
    pmra_error real,
    pmdec real,
    pmdec_error real,
    phot_z_flag real,
    phot_z_mag real,
    phot_z_mag_error real,
    phot_y_flag real,
    phot_y_mag real,
    phot_y_mag_error real,
    phot_j_flag real,
    phot_j_mag real,
    phot_j_mag_error real,
    phot_h_flag real,
    phot_h_mag real,
    phot_h_mag_error real,
    phot_ks_flag real,
    phot_ks_mag real,
    phot_ks_mag_error real,
    glon real NOT NULL,
    glat real NOT NULL
);


ALTER TABLE public.virac_sources OWNER TO admin;

--
-- Name: merged_sources source_id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.merged_sources ALTER COLUMN source_id SET DEFAULT nextval('public.merged_sources_source_id_seq'::regclass);


--
-- Name: sirius_sources_orig source_id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.sirius_sources_orig ALTER COLUMN source_id SET DEFAULT nextval('public.sirius_sources_orig_source_id_seq'::regclass);


--
-- Name: tmass_sources source_id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.tmass_sources ALTER COLUMN source_id SET DEFAULT nextval('public.tmass_sources_source_id_seq'::regclass);


--
-- Name: TABLE edr3_sources; Type: ACL; Schema: public; Owner: admin
--

GRANT SELECT ON TABLE public.edr3_sources TO jasmine_user;


--
-- Name: TABLE merged_sources; Type: ACL; Schema: public; Owner: admin
--

GRANT SELECT ON TABLE public.merged_sources TO jasmine_user;


--
-- Name: TABLE sirius_sources_orig; Type: ACL; Schema: public; Owner: admin
--

GRANT SELECT ON TABLE public.sirius_sources_orig TO jasmine_user;


--
-- Name: TABLE sirius_sources; Type: ACL; Schema: public; Owner: admin
--

GRANT SELECT ON TABLE public.sirius_sources TO jasmine_user;


--
-- Name: TABLE tmass_sources; Type: ACL; Schema: public; Owner: admin
--

GRANT SELECT ON TABLE public.tmass_sources TO jasmine_user;


--
-- Name: TABLE virac_sources; Type: ACL; Schema: public; Owner: admin
--

GRANT SELECT ON TABLE public.virac_sources TO jasmine_user;


--
-- PostgreSQL database dump complete
--

COMMIT;
