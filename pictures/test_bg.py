# -*- coding: utf-8 -*-
"""
Created on Fri Dec 25 22:14:34 2020

@author: 45242
"""

from PIL import Image
sizex = 320
sizey = 240
x = 320 // 4
filename = 'test_background.txt'
with open(filename, 'w') as f:
    for i in range(240):
        for j in range(x):
            f.write("11000000\n")
        for j in range(x, 2* x):
            f.write("11110000\n")
        for j in range(2 * x, 3 * x):
            f.write("11001100\n")
        for j in range(3 * x, 4 * x):
            f.write("11000011\n")