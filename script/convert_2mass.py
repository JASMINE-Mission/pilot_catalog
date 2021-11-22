#!/usr/bin/env python
# -*- coding: utf-8 -*-
from argparse import ArgumentParser as ap
from astropy.coordinates import SkyCoord
import pandas as pd
import sys,os

columns = (
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
            raise OSError(f'Error: file "{args.csv}" already exists.')

    df = pd.read_csv(args.src)

    df['j_h'] = pd.to_numeric(df.j_h,errors='coerce')
    df['h_k'] = pd.to_numeric(df.h_k,errors='coerce')
    df['j_k'] = pd.to_numeric(df.j_k,errors='coerce')

    df['rd_flg'] = df.rd_flg.apply(lambda x: f'{x:03d}')

    galactic = SkyCoord(df.ra,df.dec,frame='fk5',unit='degree').galactic
    df['glon'] = galactic.l
    df['glat'] = galactic.b

    if os.path.exists(args.csv):
        print(f'Warning: file "{args.csv}" already exists.')
    df.to_csv(args.csv, index=False)
