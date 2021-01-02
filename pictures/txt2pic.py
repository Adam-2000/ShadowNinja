# -*- coding: utf-8 -*-
"""
Created on Thu Dec 24 21:22:38 2020

@author: 45242
"""

from PIL import Image
sizex = 240
sizey = 240
filename = 'background_unit1.txt'
a = [[None] * sizex for _ in range(sizey)]
with open(filename, 'r') as f:
    for i in range(sizey):
        for j in range(sizex):
            a[i][j] = f.readline()
            
            
def txt2rgb(txt):
    res = []
    for i in range(3):
        cur = txt[2 * i + 2: 2 * i + 4]
        val = int(cur, 2) * 85
        res.append(val)
    return tuple(res)

outImg = Image.new('RGB', (sizex, sizey), color='white')
for y in range(sizey):
    for x in range(sizex):
        outImg.putpixel((x,y), txt2rgb(a[y][x]))
        
outImg.save(filename + ".png" )