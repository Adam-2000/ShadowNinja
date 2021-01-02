# -*- coding: utf-8 -*-
"""
Created on Fri Dec 25 23:08:06 2020

@author: 45242
"""


from PIL import Image
sizex = 640
sizey = 160
filename = 'palette.txt'
four = ['00', '01', '10', '11']
colorlist = [None] * 64
for i in range(4):
    for j in range(4):
        for k in range(4):
            cur = '11'
            cur = cur + four[i] + four[j] + four[k]
            colorlist[i * 16 + j * 4 + k] = cur
            
with open(filename, 'w') as f:
    for i in range(sizey):
        for j in range(sizex):
            f.write(colorlist[j // 40 + (i // 40) * 16] + '\n')

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