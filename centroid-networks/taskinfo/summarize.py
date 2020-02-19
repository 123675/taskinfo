#!/usr/bin/env python
import gnuplotlib as gp
import numpy as np
from scipy.ndimage.filters import convolve
import json
import sys
import argparse


def smooth(y, box_pts):
    box = np.ones(box_pts)/box_pts
    #y_smooth = np.convolve(y, box, mode='same')
    y_smooth = convolve(y, box, mode='reflect')
    return y_smooth


def int_or_none(x):
    return int(x) if x else None

parser = argparse.ArgumentParser()
parser.add_argument('fname', type=str)
parser.add_argument('-t', type=str, default='', help='variable to plot')
parser.add_argument('-x', type=str, default='', help='x limits, e.g. -2,2')
parser.add_argument('-y', type=str, default='', help='y limits, e.g. -2,2')
parser.add_argument('-s', '--smooth', type=int, default=-1, help='how much to smooth')
args = parser.parse_args()

print('Reading {}'.format(args.fname))
f = open(args.fname)
d = json.load(f)

if args.t == '':
    for key in sorted(d):
        print(key)
    sys.exit(-1)

xlim = [int_or_none(i) for i in args.x.split(',')] if args.x else None
ylim = [int_or_none(i) for i in args.y.split(',')] if args.y else None

key = args.t

data = sorted([(int(x), y) for x, y in d[key].items()])
x, y = zip(*data)
x = np.asarray(x)
y = np.asarray(y)
#smoothed = scipy.signal.medfilt(y, smooth)
if args.smooth < 0:
    args.smooth = len(x) // 20
sigma = (args.smooth // 2) *2 + 1
print('Plotting {} ({} samples, smooth {})...'.format(key, len(x), sigma))
smoothed = smooth(y, sigma)

gp.plot(x, smoothed, _with='lines', terminal='dumb 80, 40', unset='grid', title=key, _xrange=xlim, _yrange=ylim)
