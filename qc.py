#!/usr/bin/env python3
# requires Python >= 3.10
# based on https://github.com/dakk/qc64

import os
from math import sqrt
from random import random

class QC:
    real = [1, 0, 0, 0]
    imaginary = [0, 0, 0, 0]
    z = [0, 0, 0, 0]
    p = [0, 0, 0, 0]
    a = [0, 0]
    sq = 0

qc = QC()

# from https://stackoverflow.com/a/11526998
# https://docs.python.org/3/library/os.html#os.name doesn't include ce or dos, so ???
class Clear:
   def __call__(self):
      if os.name in ('ce', 'nt', 'dos'): os.system('cls')
      elif os.name == 'posix': os.system('clear')
      else: print('\n' * os.get_terminal_size().lines, end = '')
   def __neg__(self): self()
   def __repr__(self):
      self(); return ''

clear = Clear()

def simulate(gate):
    match gate:
        case "x0":
            x0()
        case "x1":
            x1()
        case "y0":
            y0()
        case "y1":
            y1()
        case "z0":
            z0()
        case "z1":
            z1()
        case "h0":
            h0()
        case "h1":
            h1()
        case "cx":
            cx()
        case "sw":
            sw()

# 400
def x0():
    qc.a[0] = qc.real[0]; qc.real[0] = qc.real[1]; qc.real[1] = qc.a[0]
    qc.a[0] = qc.imaginary[0]; qc.imaginary[0] = qc.imaginary[1]; qc.imaginary[1] = qc.a[0]
    qc.a[0] = qc.real[2]; qc.real[2] = qc.real[3]; qc.real[3] = qc.a[0]
    qc.a[0] = qc.imaginary[2]; qc.imaginary[2] = qc.imaginary[3]; qc.imaginary[3] = qc.a[0]
    return

# 440
def y0():
    qc.a[0] = qc.imaginary[0]; qc.imaginary[0] = -qc.real[0]; qc.real[0] = qc.a[0]
    qc.a[0] = qc.imaginary[1]; qc.imaginary[1] = -qc.real[1]; qc.real[1] = qc.a[0]
    qc.a[0] = qc.imaginary[2]; qc.imaginary[2] = -qc.real[2]; qc.real[2] = qc.a[0]
    qc.a[0] = qc.imaginary[3]; qc.imaginary[3] = -qc.real[3]; qc.real[3] = qc.a[0]
    return

# 420
def x1():
    qc.a[0] = qc.real[1]; qc.real[1] = qc.real[3]; qc.real[3] = qc.a[0]
    qc.a[0] = qc.imaginary[1]; qc.imaginary[1] = qc.imaginary[3]; qc.imaginary[3] = qc.a[0]
    qc.a[0] = qc.real[0]; qc.real[0] = qc.real[2]; qc.real[2] = qc.a[0]
    qc.a[0] = qc.imaginary[0]; qc.imaginary[0] = qc.imaginary[2]; qc.imaginary[2] = qc.a[0]
    y0() # "fall through"? https://github.com/dakk/qc64/issues/5
    return

# 460
def y1():
    qc.a[0] = qc.imaginary[1]; qc.imaginary[1] = -qc.real[1]; qc.real[1] = qc.a[0]
    qc.a[0] = qc.imaginary[3]; qc.imaginary[3] = -qc.real[3]; qc.real[3] = qc.a[0]
    return

# 480
def z0():
    qc.imaginary[2] = -qc.imaginary[2]; qc.imaginary[3] = -qc.imaginary[3]
    return

# 500
def z1():
    qc.imaginary[1] = -qc.imaginary[1]; qc.imaginary[3] = -qc.imaginary[3]
    return

# 520
def h0():
    qc.a[0] = (qc.real[0] + qc.real[1]) / sqrt(2); qc.a[1] = (qc.imaginary[0] + qc.imaginary[1]) / sqrt(2)
    b0 = (qc.real[0] - qc.real[1]) / sqrt(2); b1 = (qc.imaginary[0] - qc.imaginary[1]) / sqrt(2)
    qc.real[0] = qc.a[0]; qc.imaginary[0] = qc.a[1]; qc.real[1] = b0; qc.imaginary[1] = b1
    qc.a[0] = (qc.real[2] + qc.real[3]) / sqrt(2); qc.a[1] = (qc.imaginary[2] + qc.imaginary[3]) / sqrt(2)
    b0 = (qc.real[2] - qc.real[3]) / sqrt(2); b1 = (qc.imaginary[2] - qc.imaginary[3]) / sqrt(2)
    qc.real[2] = qc.a[0]; qc.imaginary[2] = qc.a[1]; qc.real[3] = b0; qc.imaginary[3] = b1
    return

# 540
def h1():
    qc.a[0] = (qc.real[0] + qc.real[2]) / sqrt(2); qc.a[1] = (qc.imaginary[0] + qc.imaginary[2]) / sqrt(2)
    b0 = (qc.real[0] - qc.real[2]) / sqrt(2); b1 = (qc.imaginary[0] - qc.imaginary[2]) / sqrt(2)
    qc.real[0] = qc.a[0]; qc.imaginary[0] = qc.a[1]; qc.real[2] = b0; qc.imaginary[2] = b1
    qc.a[0] = (qc.real[1] + qc.real[3]) / sqrt(2); qc.a[1] = (qc.imaginary[1] + qc.imaginary[3]) / sqrt(2)
    b0 = (qc.real[1] - qc.real[3]) / sqrt(2); b1 = (qc.imaginary[1] - qc.imaginary[3]) / sqrt(2)
    qc.real[1] = qc.a[0]; qc.imaginary[1] = qc.a[1]; qc.real[3] = b0; qc.imaginary[3] = b1
    return

# 560
def cx():
    qc.a[0] = qc.real[1]; qc.real[1] = qc.real[3]; qc.real[3] = qc.a[0]
    qc.a[0] = qc.imaginary[1]; qc.imaginary[1] = qc.imaginary[3]; qc.imaginary[3] = qc.a[0]
    return 

# 580
def sw():
    qc.a[0] = qc.real[1]; qc.real[1] = qc.real[2]; qc.real[2] = qc.a[0]
    qc.a[0] = qc.imaginary[1]; qc.imaginary[1] = qc.imaginary[2]; qc.imaginary[2] = qc.a[0]
    return

# 600
def statevcector_normalization():
    nf = sqrt(1 / qc.sq)
    qc.real[0] = qc.real[0] * nf
    qc.imaginary[0] = qc.imaginary[0] * nf
    qc.real[1] = qc.real[1] * nf
    qc.imaginary[1] = qc.imaginary[1] * nf
    qc.real[2] = qc.real[2] * nf
    qc.imaginary[2] = qc.imaginary[2] * nf
    qc.real[3] = qc.real[3] * nf
    qc.imaginary[3] = qc.imaginary[3] * nf
    return

def results():
    print("results:")
    print(f'00: [{qc.z[0]}] {qc.z[0] * "Q"}')
    print(f'01: [{qc.z[2]}] {qc.z[2] * "Q"}')
    print(f'10: [{qc.z[1]}] {qc.z[1] * "Q"}')
    print(f'11: [{qc.z[3]}] {qc.z[3] * "Q"}')

def main():
    '''
    qc.real[0] = 1; qc.imaginary[0] = 0; qc.real[1] = 0; qc.imaginary[1] = 0
    qc.real[2] = 0; qc.imaginary[2] = 0; qc.real[3] = 0; qc.imaginary[3] = 0
    qc.a[0] = 0
    '''
    shots = 28
    clear()
    print("quantum simulator")
    print("created by davide gessa (dakk)")
    print("enter gate seq (x0,x1,y0,y1,z0,z1,h0,h1,cx,sw)")
    g = input()
    print("calculating the statevector...", end = '')
    for i in range(0, len(g), 2):
        gate = g[i:i + 2]
        simulate(gate)
        print(".", end = '')
    print()

    qc.sq = qc.real[0]*qc.real[0] + qc.imaginary[0]*qc.imaginary[0] + qc.real[1]*qc.real[1] + qc.imaginary[1]*qc.imaginary[1] + qc.real[2]*qc.real[2] + qc.imaginary[2]*qc.imaginary[2] + qc.real[3]*qc.real[3] + qc.imaginary[3]*qc.imaginary[3]
    if abs(qc.sq - 1) > 0.00001: statevcector_normalization()

    print(f"running {shots} iterations...")
    # qc.z[0] = 0; qc.z[1] = 0; qc.z[2] = 0; qc.z[3] = 0
    qc.p[0] = (qc.real[0] * qc.real[0] + qc.imaginary[0] * qc.imaginary[0])
    qc.p[1] = (qc.real[1] * qc.real[1] + qc.imaginary[1] * qc.imaginary[1]) + qc.p[0]
    qc.p[2] = (qc.real[2] * qc.real[2] + qc.imaginary[2] * qc.imaginary[2]) + qc.p[1]
    qc.p[3] = (qc.real[3] * qc.real[3] + qc.imaginary[3] * qc.imaginary[3]) + qc.p[2]

    for i in range(shots):
        r = random()
        if r < qc.p[0]: qc.z[0] = qc.z[0] + 1
        if r >= qc.p[0] and r < qc.p[1]: qc.z[1] = qc.z[1] + 1
        if r >= qc.p[1] and r < qc.p[2]: qc.z[2] = qc.z[2] + 1
        if r >= qc.p[2] and r < qc.p[3]: qc.z[3] = qc.z[3] + 1

if __name__ == '__main__':
    main()
    results()
