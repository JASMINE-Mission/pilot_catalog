#!/usr/bin/env python
# -*- coding: utf-8 -*-
from argparse import ArgumentParser as ap
from astropy.coordinates import SkyCoord, Longitude
import astropy.io.fits as fits
import numpy as np
import pandas as pd
import sys, os

import re


def get_weighted_mag(mag1,error1,mag2,error2):
    return (np.nan_to_num(mag1/error1**2)+\
        np.nan_to_num(mag2/error2**2))/\
         (np.nan_to_num(1/error1**2,posinf=0)+\
        np.nan_to_num(1/error2**2,posinf=0))
    
def get_weighted_error(error1,error2):
    return np.nan_to_num(1/np.sqrt(np.nan_to_num(1/error1**2)+\
        np.nan_to_num(1/error2**2)),posinf=np.nan)
    
def get_combined_flag(flag1,flag2):
    aux1 = np.nan_to_num(flag1).astype(int)
    aux2 = np.nan_to_num(flag2).astype(int)
    bin1 = np.array([int(bin(a)[2:]) for a in aux1])
    bin2 = np.array([int(bin(a)[2:]) for a in aux2])
    byte_str = (bin1+bin2).astype(str)
    perrb = np.array([float(int("0b" + b.replace("2","1"),2)) for b in byte_str])
    perrb[perrb==0] = np.nan
    return perrb


if __name__ == '__main__':
    parser = ap(description='treat VVV DR4.2 CSV catalog')

    parser.add_argument(
        'src', type=str, help='input catalog')
    parser.add_argument(
        'out', type=str, help='output CSV file')
    parser.add_argument(
        '-f', '--overwrite', action='store_true',
        help='overwrite if the output file exists')

    args = parser.parse_args()

    if os.path.exists(args.out):
        if not args.overwrite:
            raise RuntimeError(f'file {args.out} already exists.')

    df = pd.read_csv(args.src)

    ## FIRST OF ALL! CORRECT ERRORS e_J1ap3 = 0
    df.loc[df.e_J1ap3<1e-5] = np.nan

    ## Columns to save
    final_cols = ["source_id","glon","glat","ra","dec","Var","Prim","phot_z_flag","phot_z_mag","phot_z_mag_error",
                "phot_y_flag","phot_y_mag","phot_y_mag_error",
                "phot_j_flag","phot_j_mag","phot_j_mag_error",
                "phot_h_flag","phot_h_mag","phot_h_mag_error",
                "phot_ks_flag","phot_ks_mag","phot_ks_mag_error"]

    ## RENAME SOME COLUMNS
    rename_dic = {}
    for col in df.columns:
        if col == "SrcID":
            rename_dic[col] = "source_id"
        elif col == "RAJ2000":
            rename_dic[col] = "ra"
        elif col == "DEJ2000":
            rename_dic[col] = "dec"
        elif (col == "GLON") | (col == "GLAT"):
            rename_dic[col] = col.lower()
        elif col.endswith("ap3"):
            if col.startswith("e_"):
                if col[2].lower() == "k":
                    rename_dic[col] = "phot_{}_mag_error_{}".format(col[2:4].lower(),re.search(r'[1-2]+', col).group())
                else:
                    rename_dic[col] = "phot_{}_mag_error_{}".format(col[2].lower(),re.search(r'[1-2]+', col).group())
            else:
                if col[0].lower() == "k":
                    rename_dic[col] = "phot_{}_mag_{}".format(col[0:2].lower(),re.search(r'[1-2]+', col).group())
                else:
                    rename_dic[col] = "phot_{}_mag_{}".format(col[0].lower(),re.search(r'[1-2]+', col).group())

    df.rename(columns=rename_dic,inplace=True)

    ## Wrap glon from -180 to 180
    df["glon"] = np.rad2deg(np.arctan2(np.sin(np.deg2rad(df.glon.values)),np.cos(np.deg2rad(df.glon.values))))


    ## Merge photometry into single values
    ### Z
    df["phot_z_mag"] = get_weighted_mag(df.phot_z_mag_1.values,
                                            df.phot_z_mag_error_1.values,
                                            df.phot_z_mag_2.values,
                                            df.phot_z_mag_error_2.values)

    df["phot_z_mag_error"] = get_weighted_error(df.phot_z_mag_error_1.values,
                                                df.phot_z_mag_error_2.values)

    df["phot_z_flag"] = get_combined_flag(df.Z1perrb.values,
                                                df.Z2perrb.values)
    ### Y
    df["phot_y_mag"] = get_weighted_mag(df.phot_y_mag_1.values,
                                            df.phot_y_mag_error_1.values,
                                            df.phot_y_mag_2.values,
                                            df.phot_y_mag_error_2.values)

    df["phot_y_mag_error"] = get_weighted_error(df.phot_y_mag_error_1.values,
                                                df.phot_y_mag_error_2.values)

    df["phot_y_flag"] = get_combined_flag(df.Y1perrb.values,
                                                df.Y2perrb.values)
    
    ### J
    df["phot_j_mag"] = get_weighted_mag(df.phot_j_mag_1.values,
                                            df.phot_j_mag_error_1.values,
                                            df.phot_j_mag_2.values,
                                            df.phot_j_mag_error_2.values)

    df["phot_j_mag_error"] = get_weighted_error(df.phot_j_mag_error_1.values,
                                                df.phot_j_mag_error_2.values)

    df["phot_j_flag"] = get_combined_flag(df.J1perrb.values,
                                                df.J2perrb.values)
    
    ### H
    df["phot_h_mag"] = get_weighted_mag(df.phot_h_mag_1.values,
                                            df.phot_h_mag_error_1.values,
                                            df.phot_h_mag_2.values,
                                            df.phot_h_mag_error_2.values)

    df["phot_h_mag_error"] = get_weighted_error(df.phot_h_mag_error_1.values,
                                                df.phot_h_mag_error_2.values)

    df["phot_h_flag"] = get_combined_flag(df.H1perrb.values,
                                                df.H2perrb.values)
    
    ### Ks
    df["phot_ks_mag"] = get_weighted_mag(df.phot_ks_mag_1.values,
                                            df.phot_ks_mag_error_1.values,
                                            df.phot_ks_mag_2.values,
                                            df.phot_ks_mag_error_2.values)

    df["phot_ks_mag_error"] = get_weighted_error(df.phot_ks_mag_error_1.values,
                                                df.phot_ks_mag_error_2.values)

    df["phot_ks_flag"] = get_combined_flag(df.Ks1perrb.values,
                                                df.Ks2perrb.values)


    if os.path.exists(args.out):
        print(f'Warning: overwrite {args.out}', file=sys.stderr)

    df[final_cols].to_csv(args.out, index=False)
