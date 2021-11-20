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
-- Name: sirius_sources; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.sirius_sources (
    sirius_id bigint NOT NULL,
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

ALTER SEQUENCE public.sirius_sources_sirius_id_seq OWNED BY public.sirius_sources.sirius_id;


--
-- Name: tmass_sources; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.tmass_sources (
    tmass_id bigint NOT NULL,
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
-- Name: tmass_sources_tmass_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.tmass_sources_tmass_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tmass_sources_tmass_id_seq OWNER TO admin;

--
-- Name: tmass_sources_tmass_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.tmass_sources_tmass_id_seq OWNED BY public.tmass_sources.tmass_id;


--
-- Name: sirius_sources sirius_id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.sirius_sources ALTER COLUMN sirius_id SET DEFAULT nextval('public.sirius_sources_sirius_id_seq'::regclass);


--
-- Name: tmass_sources tmass_id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.tmass_sources ALTER COLUMN tmass_id SET DEFAULT nextval('public.tmass_sources_tmass_id_seq'::regclass);


--
-- PostgreSQL database dump complete
--

COMMIT;
