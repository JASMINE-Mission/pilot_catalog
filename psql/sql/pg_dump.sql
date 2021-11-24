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
-- Name: mag_match(numeric, numeric, numeric); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.mag_match(numeric, numeric, numeric) RETURNS boolean
    LANGUAGE sql
    AS $_$                                                         
  SELECT ABS($1-$2)<$3                                                          
$_$;


ALTER FUNCTION public.mag_match(numeric, numeric, numeric) OWNER TO admin;

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
    position_k_x real,
    position_k_y real,
    phot_k_mag real,
    phot_k_mag_error real,
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
    sirius_sources_orig.position_k_x,
    sirius_sources_orig.position_k_y,
    sirius_sources_orig.phot_k_mag,
    sirius_sources_orig.phot_k_mag_error,
    sirius_sources_orig.plate_name
   FROM public.sirius_sources_orig
  WHERE (((sirius_sources_orig.glon >= ('-2.5'::numeric)::double precision) AND (sirius_sources_orig.glon <= (1.2)::double precision)) AND ((sirius_sources_orig.glat >= ('-1.2'::numeric)::double precision) AND (sirius_sources_orig.glat <= (1.2)::double precision)))
  WITH NO DATA;


ALTER TABLE public.sirius_sources OWNER TO admin;

--
-- Name: sirius_sources_sirius_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.sirius_sources_sirius_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sirius_sources_sirius_id_seq OWNER TO admin;

--
-- Name: sirius_sources_sirius_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.sirius_sources_sirius_id_seq OWNED BY public.sirius_sources_orig.source_id;


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
    phot_k_mag real,
    phot_k_cmsig real,
    phot_k_mag_error real,
    phot_k_snr real,
    quality_flag character varying(3) NOT NULL,
    contaminated integer NOT NULL,
    glon real NOT NULL,
    glat real NOT NULL,
    rd_flg character varying(3) NOT NULL,
    color_j_h real,
    color_h_k real,
    color_j_k real
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
-- Name: vvv_sources_orig; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.vvv_sources_orig (
    source_id bigint NOT NULL,
    glon real NOT NULL,
    glat real NOT NULL,
    ra real NOT NULL,
    "dec" real NOT NULL,
    phot_z1_mag real,
    phot_z1_mag_error real,
    phot_z2_mag real,
    phot_z2_mag_error real,
    phot_y1_mag real,
    phot_y1_mag_error real,
    phot_y2_mag real,
    phot_y2_mag_error real,
    phot_j1_mag real,
    phot_j1_mag_error real,
    phot_j2_mag real,
    phot_j2_mag_error real,
    phot_h1_mag real,
    phot_h1_mag_error real,
    phot_h2_mag real,
    phot_h2_mag_error real,
    phot_k1_mag real,
    phot_k1_mag_error real,
    phot_k2_mag real,
    phot_k2_mag_error real,
    pstar real NOT NULL,
    psaturated real NOT NULL
);


ALTER TABLE public.vvv_sources_orig OWNER TO admin;

--
-- Name: vvv_sources; Type: VIEW; Schema: public; Owner: admin
--

CREATE VIEW public.vvv_sources AS
 SELECT vvv_sources_orig.source_id,
    vvv_sources_orig.glon,
    vvv_sources_orig.glat,
    vvv_sources_orig.ra,
    vvv_sources_orig."dec",
    COALESCE(vvv_sources_orig.phot_z2_mag, vvv_sources_orig.phot_z1_mag) AS phot_z_mag,
    COALESCE(vvv_sources_orig.phot_z2_mag_error, vvv_sources_orig.phot_z1_mag_error) AS phot_z_mag_error,
    COALESCE(vvv_sources_orig.phot_y2_mag, vvv_sources_orig.phot_y1_mag) AS phot_y_mag,
    COALESCE(vvv_sources_orig.phot_y2_mag_error, vvv_sources_orig.phot_y1_mag_error) AS phot_y_mag_error,
    COALESCE(vvv_sources_orig.phot_j2_mag, vvv_sources_orig.phot_j1_mag) AS phot_j_mag,
    COALESCE(vvv_sources_orig.phot_j2_mag_error, vvv_sources_orig.phot_j1_mag_error) AS phot_j_mag_error,
    COALESCE(vvv_sources_orig.phot_h2_mag, vvv_sources_orig.phot_h1_mag) AS phot_h_mag,
    COALESCE(vvv_sources_orig.phot_h2_mag_error, vvv_sources_orig.phot_h1_mag_error) AS phot_h_mag_error,
    COALESCE(vvv_sources_orig.phot_k2_mag, vvv_sources_orig.phot_k1_mag) AS phot_k_mag,
    COALESCE(vvv_sources_orig.phot_k2_mag_error, vvv_sources_orig.phot_k1_mag_error) AS phot_k_mag_error
   FROM public.vvv_sources_orig;


ALTER TABLE public.vvv_sources OWNER TO admin;

--
-- Name: tmass_vvv_merged_sources; Type: MATERIALIZED VIEW; Schema: public; Owner: admin
--

CREATE MATERIALIZED VIEW public.tmass_vvv_merged_sources AS
 SELECT t.source_id AS tmass_source_id,
    v.source_id AS vvv_source_id,
    COALESCE(v.glon, t.glon) AS glon,
    COALESCE(v.glon, t.glat) AS glat,
    COALESCE(v.ra, t.ra) AS ra,
    COALESCE(v."dec", t."dec") AS "dec",
    public.ifthenelse(v.source_id, 'V'::character varying, '2'::character varying) AS position_source,
    COALESCE(v.phot_j_mag, t.phot_j_mag) AS phot_j_mag,
    COALESCE(v.phot_j_mag_error, t.phot_j_mag_error) AS phot_j_mag_error,
    public.ifthenelse(v.phot_j_mag, 'V'::character varying, '2'::character varying) AS phot_j_mag_source,
    COALESCE(v.phot_h_mag, t.phot_h_mag) AS phot_h_mag,
    COALESCE(v.phot_h_mag_error, t.phot_h_mag_error) AS phot_h_mag_error,
    public.ifthenelse(v.phot_h_mag, 'V'::character varying, '2'::character varying) AS phot_h_mag_source,
    COALESCE(v.phot_k_mag, t.phot_k_mag) AS phot_k_mag,
    COALESCE(v.phot_k_mag_error, t.phot_k_mag_error) AS phot_k_mag_error,
    public.ifthenelse(v.phot_k_mag, 'V'::character varying, '2'::character varying) AS phot_k_mag_source
   FROM (public.tmass_sources t
     LEFT JOIN public.vvv_sources v ON ((public.q3c_join((t.glon)::double precision, (t.glat)::double precision, v.glon, v.glat, (('1'::numeric / '3600'::numeric))::double precision) AND public.jhk_match(t.phot_j_mag, v.phot_j_mag, t.phot_h_mag, v.phot_h_mag, t.phot_k_mag, v.phot_k_mag, (2.0)::real))))
UNION ALL
 SELECT t.source_id AS tmass_source_id,
    v.source_id AS vvv_source_id,
    COALESCE(v.glon, t.glon) AS glon,
    COALESCE(v.glon, t.glat) AS glat,
    COALESCE(v.ra, t.ra) AS ra,
    COALESCE(v."dec", t."dec") AS "dec",
    public.ifthenelse(v.source_id, 'V'::character varying, '2'::character varying) AS position_source,
    COALESCE(v.phot_j_mag, t.phot_j_mag) AS phot_j_mag,
    COALESCE(v.phot_j_mag_error, t.phot_j_mag_error) AS phot_j_mag_error,
    public.ifthenelse(v.phot_j_mag, 'V'::character varying, '2'::character varying) AS phot_j_mag_source,
    COALESCE(v.phot_h_mag, t.phot_h_mag) AS phot_h_mag,
    COALESCE(v.phot_h_mag_error, t.phot_h_mag_error) AS phot_h_mag_error,
    public.ifthenelse(v.phot_h_mag, 'V'::character varying, '2'::character varying) AS phot_h_mag_source,
    COALESCE(v.phot_k_mag, t.phot_k_mag) AS phot_k_mag,
    COALESCE(v.phot_k_mag_error, t.phot_k_mag_error) AS phot_k_mag_error,
    public.ifthenelse(v.phot_k_mag, 'V'::character varying, '2'::character varying) AS phot_k_mag_source
   FROM (public.vvv_sources v
     LEFT JOIN public.tmass_sources t ON ((public.q3c_join((v.glon)::double precision, (v.glat)::double precision, t.glon, t.glat, (('1'::numeric / '3600'::numeric))::double precision) AND public.jhk_match(t.phot_j_mag, v.phot_j_mag, t.phot_h_mag, v.phot_h_mag, t.phot_k_mag, v.phot_k_mag, (2.0)::real))))
  WHERE (t.source_id IS NULL)
  WITH NO DATA;


ALTER TABLE public.tmass_vvv_merged_sources OWNER TO admin;

--
-- Name: sirius_sources_orig source_id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.sirius_sources_orig ALTER COLUMN source_id SET DEFAULT nextval('public.sirius_sources_sirius_id_seq'::regclass);


--
-- Name: tmass_sources source_id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.tmass_sources ALTER COLUMN source_id SET DEFAULT nextval('public.tmass_sources_source_id_seq'::regclass);


--
-- Name: TABLE edr3_sources; Type: ACL; Schema: public; Owner: admin
--

GRANT SELECT ON TABLE public.edr3_sources TO jasmine_user;


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
-- Name: TABLE vvv_sources_orig; Type: ACL; Schema: public; Owner: admin
--

GRANT SELECT ON TABLE public.vvv_sources_orig TO jasmine_user;


--
-- Name: TABLE vvv_sources; Type: ACL; Schema: public; Owner: admin
--

GRANT SELECT ON TABLE public.vvv_sources TO jasmine_user;


--
-- PostgreSQL database dump complete
--

COMMIT;
