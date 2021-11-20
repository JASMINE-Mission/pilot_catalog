#!/usr/bin/env python
# -*- coding: utf-8 -*-
from argparse import ArgumentParser as ap
from astropy.coordinates import Longitude,Latitude,SkyCoord
from pprint import pprint
import pandas as pd
import os, sys

columns = (
    'glon',
    'glat',
    'ra',
    'dec',
    'position_j_x',
    'position_j_y',
    'phot_j_mag',
    'phot_j_mag_error',
    'position_h_x',
    'position_h_y',
    'phot_h_mag',
    'phot_h_mag_error',
    'position_k_x',
    'position_k_y',
    'phot_k_mag',
    'phot_k_mag_error',
    'plate_name',
)


def float_null(arg):
    v = float(arg)
    return v if abs(v) > 1e-8 else None


if __name__ == '__main__':
    parser = ap(description='Reshape SIRIUS catalog to CSV format')

    parser.add_argument(
        'src', type=str, help='input text catalog')
    parser.add_argument(
        'csv', type=str, help='output CSV catalog file')
    parser.add_argument(
        '-f', '--overwrite', action='store_true',
        help='overwrite if the output file exists.')

    args = parser.parse_args()

    if os.path.exists(args.csv):
        if args.overwrite is False:
            raise OSError(f'Error: file "{args.csv}" already exists.')

    df = []
    with open(args.src,'r') as f:
        for line in f.readlines():
            line = line.rstrip()
            elem = line.split()
            record = dict(
                glon = float(elem.pop(0)),
                glat = float(elem.pop(0)),
                ra   = Longitude(elem.pop(0), unit='hour').deg,
                dec  = Latitude(elem.pop(0), unit='degree').deg,
                position_j_x = float_null(elem.pop(0)),
                position_j_y = float_null(elem.pop(0)),
                phot_j_mag   = float_null(elem.pop(0)),
                phot_j_mag_error = float_null(elem.pop(0)),
                position_h_x = float_null(elem.pop(0)),
                position_h_y = float_null(elem.pop(0)),
                phot_h_mag   = float_null(elem.pop(0)),
                phot_h_mag_error = float_null(elem.pop(0)),
                position_k_x = float_null(elem.pop(0)),
                position_k_y = float_null(elem.pop(0)),
                phot_k_mag   = float_null(elem.pop(0)),
                phot_k_mag_error = float_null(elem.pop(0)),
                plate_name = elem.pop(0)
            )
            df.append(record)
    df = pd.DataFrame(df, columns=columns)

    if os.path.exists(args.csv):
        print(f'Warning: file "{args.csv}" already exists.')
    df.to_csv(args.csv, index=False)
