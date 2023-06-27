#!/usr/bin/env python
# -*- coding: utf-8 -*-
from argparse import ArgumentParser as ap
from astropy.coordinates import SkyCoord, Longitude
import pandas as pd
import sys,os

columns_old = (
    'ra',
    'dec',
    'designation',
    'j_m',
    'j_cmsig',
    'j_msigcom',
    'j_snr',
    'h_m',
    'h_cmsig',
    'h_msigcom',
    'h_snr',
    'k_m',
    'k_cmsig',
    'k_msigcom',
    'k_snr',
    'ph_qual',
    'gal_contam',
    'glon',
    'glat',
    'rd_flg',
    'j_h',
    'h_k',
    'j_k',
)

columns_new = (
    'ra',
    'dec',
    'designation',
    'phot_j_mag',
    'phot_j_cmsig',
    'phot_j_mag_error',
    'phot_j_snr',
    'phot_h_mag',
    'phot_h_cmsig',
    'phot_h_mag_error',
    'phot_h_snr',
    'phot_ks_mag',
    'phot_ks_cmsig',
    'phot_ks_mag_error',
    'phot_ks_snr',
    'quality_flag',
    'contaminated',
    'glon',
    'glat',
    'rd_flg',
    'j_h',
    'h_ks',
    'j_ks',
)


if __name__ == '__main__':
    parser = ap(description='Reformat 2MASS catalog')

    parser.add_argument(
        'src', type=str, help='input CSV catalog')
    parser.add_argument(
        'csv', type=str, help='output CSV catalog')
    parser.add_argument(
        '-f', '--overwrite', action='store_true',
        help='overwrite if the output file exists.')

    args = parser.parse_args()

    if os.path.exists(args.csv):
        if args.overwrite is False:
            raise OSError('Error: file {} already exists.'.format(args.csv))

    df = pd.read_csv(args.src)

    df['j_h'] = pd.to_numeric(df.j_h,errors='coerce')
    df['h_k'] = pd.to_numeric(df.h_ks,errors='coerce')
    df['j_k'] = pd.to_numeric(df.j_ks,errors='coerce')

    df['rd_flg'] = df.rd_flg.apply(lambda x: f'{x:03d}')

    galactic = SkyCoord(df.ra,df.dec,frame='fk5',unit='degree').galactic
    df['glon'] = Longitude(galactic.l,wrap_angle='180d').deg
    df['glat'] = galactic.b.deg

    if os.path.exists(args.csv):
        print(f'Warning: file "{args.csv}" already exists.')
    df.to_csv(args.csv, index=False)
