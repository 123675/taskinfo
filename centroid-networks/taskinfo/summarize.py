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


parser = argparse.ArgumentParser()
parser.add_argument('mode', type=str, choices=['plot', 'ls'])
parser.add_argument('fname', type=str)
parser.add_argument('-t', type=str, default='', help='variable to plot')
parser.add_argument('-x', type=str, default='', help='x limits, e.g. -2,2')
parser.add_argument('-y', type=str, default='', help='y limits, e.g. -2,2')
parser.add_argument('-s', '--smooth', type=int, default=0, help='how much to smooth')
args = parser.parse_args()

print('Reading {}'.format(args.fname))
f = open(args.fname)
d = json.load(f)

if args.mode == 'ls':
    for key in d:
        print(key)
    sys.exit(-1)

xlim = list(map(int, args.x.split(','))) if args.x else None
ylim = list(map(int, args.y.split(','))) if args.y else None

key = args.t
sigma = (args.smooth // 2) *2 + 1

data = sorted([(int(x), y) for x, y in d[key].items()])
x, y = zip(*data)
x = np.asarray(x)
y = np.asarray(y)
print('Plotting {} ({} samples, smooth {})...'.format(key, len(x), smooth))
#smoothed = scipy.signal.medfilt(y, smooth)
smoothed = smooth(y, sigma)
gp.plot(x, smoothed, _with='lines', terminal='dumb 80, 40', unset='grid', title=key, _xrange=xlim, _yrange=ylim)
