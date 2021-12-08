#!/usr/bin/env python
# -*- coding: utf-8 -*-
from argparse import ArgumentParser as ap
from astropy.coordinates import SkyCoord, Longitude
import astropy.io.fits as fits
import numpy as np
import pandas as pd
import sys, os


if __name__ == '__main__':
    parser = ap(description='convert VIRAC FITS catalog into CSV')

    parser.add_argument(
        'src', type=str, help='input VIRAC FITS catalog')
    parser.add_argument(
        'out', type=str, help='output CSV file')
    parser.add_argument(
        '-f', '--overwrite', action='store_true',
        help='overwrite if the output file exists')

    args = parser.parse_args()

    if os.path.exists(args.out):
        if not args.overwrite:
            raise RuntimeError(f'file {args.out} already exists.')

    hdu = fits.open(args.src)[1]
    df = pd.DataFrame(np.array(hdu.data))

    ra = df.ra
    dec = df.dec
    obj_icrs = SkyCoord(ra=ra, dec=dec, unit='degree')
    obj_gal = obj_icrs.galactic
    df['glon'] = Longitude(obj_gal.l, wrap_angle='180d').deg
    df['glat'] = obj_gal.b.deg

    if os.path.exists(args.out):
        print(f'Warning: overwrite {args.out}', file=sys.stderr)

    df.to_csv(args.out, index=False)
