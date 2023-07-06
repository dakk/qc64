#!/usr/bin/env python3
# requires Python >= 3.10
# based on https://github.com/dakk/qc64

import os
from math import sqrt
from random import random
from itertools import chain

class QC:
    # naively provide a place to store stuff
    COUNT = 4
    real = [1, 0, 0, 0]
    imaginary = [0, 0, 0, 0]
    z = [0, 0, 0, 0]
    p = [0, 0, 0, 0]
    a = [0, 0]
    b = [0, 0]
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

def simulate_OLD(gate):
    # a dispatch would be more concise
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

def simulate(gate):
    # use a dispatch table to select function to run
    gates = (x0, x1, y0, y1, z0, z1, h0, h1, cx, sw)
    funcs = {g.__name__: g for g in gates}
    funcs[gate]()

def x0():
    qc.a[0] = qc.real[0]; qc.real[0] = qc.real[1]; qc.real[1] = qc.a[0]
    qc.a[0] = qc.imaginary[0]; qc.imaginary[0] = qc.imaginary[1]; qc.imaginary[1] = qc.a[0]
    qc.a[0] = qc.real[2]; qc.real[2] = qc.real[3]; qc.real[3] = qc.a[0]
    qc.a[0] = qc.imaginary[2]; qc.imaginary[2] = qc.imaginary[3]; qc.imaginary[3] = qc.a[0]
    return

def y0():
    for n in range(qc.COUNT):
        qc.a[0] = qc.imaginary[n]; qc.imaginary[n] = -qc.real[n]; qc.real[n] = qc.a[0]
    return

def x1():
    qc.a[0] = qc.real[1]; qc.real[1] = qc.real[3]; qc.real[3] = qc.a[0]
    qc.a[0] = qc.imaginary[1]; qc.imaginary[1] = qc.imaginary[3]; qc.imaginary[3] = qc.a[0]
    qc.a[0] = qc.real[0]; qc.real[0] = qc.real[2]; qc.real[2] = qc.a[0]
    qc.a[0] = qc.imaginary[0]; qc.imaginary[0] = qc.imaginary[2]; qc.imaginary[2] = qc.a[0]
    y0() # "fall through"? https://github.com/dakk/qc64/issues/5
    return

def y1():
    qc.a[0] = qc.imaginary[1]; qc.imaginary[1] = -qc.real[1]; qc.real[1] = qc.a[0]
    qc.a[0] = qc.imaginary[3]; qc.imaginary[3] = -qc.real[3]; qc.real[3] = qc.a[0]
    return

def z0():
    qc.imaginary[2] = -qc.imaginary[2]; qc.imaginary[3] = -qc.imaginary[3]
    return

def z1():
    qc.imaginary[1] = -qc.imaginary[1]; qc.imaginary[3] = -qc.imaginary[3]
    return

def h0():
    qc.a[0] = (qc.real[0] + qc.real[1]) / sqrt(2); qc.a[1] = (qc.imaginary[0] + qc.imaginary[1]) / sqrt(2)
    qc.b[0] = (qc.real[0] - qc.real[1]) / sqrt(2); qc.b[1] = (qc.imaginary[0] - qc.imaginary[1]) / sqrt(2)
    qc.real[0] = qc.a[0]; qc.imaginary[0] = qc.a[1]; qc.real[1] = qc.b[0]; qc.imaginary[1] = qc.b[1]
    qc.a[0] = (qc.real[2] + qc.real[3]) / sqrt(2); qc.a[1] = (qc.imaginary[2] + qc.imaginary[3]) / sqrt(2)
    qc.b[0] = (qc.real[2] - qc.real[3]) / sqrt(2); qc.b[1] = (qc.imaginary[2] - qc.imaginary[3]) / sqrt(2)
    qc.real[2] = qc.a[0]; qc.imaginary[2] = qc.a[1]; qc.real[3] = qc.b[0]; qc.imaginary[3] = qc.b[1]
    return

def h1():
    qc.a[0] = (qc.real[0] + qc.real[2]) / sqrt(2); qc.a[1] = (qc.imaginary[0] + qc.imaginary[2]) / sqrt(2)
    qc.b[0] = (qc.real[0] - qc.real[2]) / sqrt(2); qc.b[1] = (qc.imaginary[0] - qc.imaginary[2]) / sqrt(2)
    qc.real[0] = qc.a[0]; qc.imaginary[0] = qc.a[1]; qc.real[2] = qc.b[0]; qc.imaginary[2] = qc.b[1]
    qc.a[0] = (qc.real[1] + qc.real[3]) / sqrt(2); qc.a[1] = (qc.imaginary[1] + qc.imaginary[3]) / sqrt(2)
    qc.b[0] = (qc.real[1] - qc.real[3]) / sqrt(2); qc.b[1] = (qc.imaginary[1] - qc.imaginary[3]) / sqrt(2)
    qc.real[1] = qc.a[0]; qc.imaginary[1] = qc.a[1]; qc.real[3] = qc.b[0]; qc.imaginary[3] = qc.b[1]
    return

def cx():
    qc.a[0] = qc.real[1]; qc.real[1] = qc.real[3]; qc.real[3] = qc.a[0]
    qc.a[0] = qc.imaginary[1]; qc.imaginary[1] = qc.imaginary[3]; qc.imaginary[3] = qc.a[0]
    return 

def sw():
    qc.a[0] = qc.real[1]; qc.real[1] = qc.real[2]; qc.real[2] = qc.a[0]
    qc.a[0] = qc.imaginary[1]; qc.imaginary[1] = qc.imaginary[2]; qc.imaginary[2] = qc.a[0]
    return

def statevcector_normalization():
    nf = sqrt(1 / qc.sq)
    for n in range(qc.COUNT):
        qc.real[n] *= nf
        qc.imaginary[n] *= nf
    return

def results():
    print("results:")
    b = 0
    # evens then odds
    for n in chain(range(0, qc.COUNT, 2), range(1, qc.COUNT, 2)):
        print(f'{b:02b}: [{qc.z[n]}] {qc.z[n] * "Q"}')
        b += 1

def main():
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

    qc.sq = sum([x ** 2 for x in qc.real] +
                [x ** 2 for x in qc.imaginary])

    if abs(qc.sq - 1) > 0.00001: statevcector_normalization()

    print(f"running {shots} iterations...")
    prev = 0
    for n in range(qc.COUNT):
        qc.p[n] = qc.real[n] ** 2 + qc.imaginary[n] ** 2 + prev
        prev = qc.p[n]

    for i in range(shots):
        r = random()
        if r < qc.p[0]: qc.z[0] += 1
        elif r >= qc.p[0] and r < qc.p[1]: qc.z[1] += 1
        elif r >= qc.p[1] and r < qc.p[2]: qc.z[2] += 1
        elif r >= qc.p[2] and r < qc.p[3]: qc.z[3] += 1

if __name__ == '__main__':
    main()
    results()
