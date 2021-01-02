# -*- coding: utf-8 -*-
"""
Created on Wed Dec 23 02:14:37 2020

@author: 45242
"""

from PIL import Image

def palette(rgba):
    res= ''
    for i in range(3):
        cur = ''
        if rgba[i] < 42:
            cur = '00'
        elif rgba[i] < 127:
            cur = '01'
        elif rgba[i] < 213:
            cur = '10'
        else:
            cur = '11'
        res += cur
    if rgba[3] < 200:
        res = '0' + res
    else:
        res = '1' + res
    return res
        
def txt2rgb(txt):
    res = []
    for i in range(3):
        cur = txt[2 * i + 1: 2 * i + 3]
        val = int(cur, 2) * 85
        res.append(val)
    return tuple(res)


files_ninja = ["ninja_run1", "ninja_run2", "ninja_run3", "ninja_run4", "ninja_stand1", "ninja_stand2",\
               "ninja_spin1", "ninja_spin2", "ninja_air", "ninja_kneel","ninja_dead", \
               "ninja_spin3", "ninja_spin4", "ninja_throw", "ninja_squat", 24, 32]
for i in range(len(files_ninja) - 2):
    files_ninja[i] = "ninja/" + files_ninja[i]

files_bosses =["boss1", "boss2", "boss3", "boss4", "boss5", "boss6", "boss0", 270, 240]
for i in range(len(files_bosses) - 2):
    files_bosses[i] = "boss/" + files_bosses[i]

files_dart = ["dart1", "dart2", 6, 6]
for i in range(len(files_dart) - 2):
    files_dart[i] = "bullets/" + files_dart[i]
    
files_fireball = ["fireball1", "fireball2", 24, 24]
for i in range(len(files_fireball) - 2):
    files_fireball[i] = "bullets/" + files_fireball[i]
files_fireball111 = ["fireball3", "fireball4", 35, 20]
for i in range(len(files_fireball111) - 2):
    files_fireball111[i] = "bullets/" + files_fireball111[i]
    
files_bg1 = ["backgrounds/background_front", 473, 240]
files_bg2 = ["backgrounds/background_back", 358, 240]
head = ["others/head", 30, 30]
iceball = ["bullets/iceball", 30, 30]
icearrow = ["bullets/icearrow", 56, 14]
bluehead = ["enemies/bluehead1", "enemies/bluehead2", 24, 20]
lady = ["enemies/lady1", "enemies/lady2", 25, 34]
skullhead = ["enemies/skullhead1", "enemies/skullhead2", 28, 24]
swampt = ["enemies/swampt1", "enemies/swampt2", "enemies/swampt3", 20, 30]
zombie = ["enemies/zombie1", "enemies/zombie2", "enemies/zombie3", 24, 34]
campfire = ["others/campfire1", "others/campfire2", "others/campfire3", "others/campfire4", "others/campfire5", "others/campfire6", 19, 30]
campwood = ["others/campwood1", "others/campwood2", 40, 21]
boom = ["others/boom1", "others/boom2", 10, 10]
medicine = ["others/medicine", 8, 8]
die = ["others/die", 110, 120]
kill = ["others/kill", 68, 160]
files = boom
new_w, new_h = files[-2], files[-1]
for i in range(len(files) - 2):
    filename = files[i]
    im = Image.open(filename + ".png") #Can be many different formats.
    im = im.convert("RGBA")
    im = im.resize((new_w, new_h),Image.NEAREST) # regular resize
    
    #layer = Image.new('RGBA',(new_w, new_h), (0,0,0,0))
    #layer.paste(im, (0, 0))
    #im = layer
    
    pix = im.load()
    outImg = Image.new('RGB', im.size, color='white')
    outFile = open("./outtxt/" + filename + '.txt', 'w')
    for y in range(im.size[1]):
        for x in range(im.size[0]):
            pixel = im.getpixel((x,y))
#            a = 0
#            for i in range(3):
#                if pixel[i] < 255:
#                        a = 1
#            if a:
#                txt ='1100101'
#            else:
#                txt ='0000000'
            txt = palette(pixel)
#            if txt == '1110011':
#                txt = '0000000'
#            if txt == '1000000':
#                txt = '0000000'
            outImg.putpixel((x,y), txt2rgb(txt))
            outFile.write(txt + '\n')
            
    outFile.close()
    outImg.save("./outpic/" + filename + ".png" )
#    
#for i in range(len(files) - 2):
#    filename = files[i]
#    
#    im = Image.open(filename + ".png") #Can be many different formats.
#    im = im.convert("RGBA")
#    im = im.resize((new_w, new_h),Image.NEAREST) # regular resize
#    
#    #layer = Image.new('RGBA',(new_w, new_h), (0,0,0,0))
#    #layer.paste(im, (0, 0))
#    #im = layer
#    
#    pix = im.load()
#    outImg = Image.new('RGB', im.size, color='white')
#    outFile = open("./outtxt/" + filename + '.txt', 'w')
#    for y in range(im.size[1]):
#        for x in range(im.size[0]):
#            pixel = im.getpixel((x,y))
#            txt = palette(pixel)
#            if txt[1] == '0' or (txt[1] == '1' and txt[5] == '1' and txt[6] == '1'):
#                txt = '1000000'
#            outImg.putpixel((x,y), txt2rgb(txt))
#            outFile.write(txt + '\n')
#            
#    outFile.close()
#    outImg.save("./outpic/" + filename + ".png" )

#for filename in files_dart:
#    new_w, new_h = 6,6
#    
#    im = Image.open(filename + ".png") #Can be many different formats.
#    im = im.convert("RGBA")
#    im = im.resize((new_w, new_h),Image.NEAREST) # regular resize
#    
#    #layer = Image.new('RGBA',(new_w, new_h), (0,0,0,0))
#    #layer.paste(im, (0, 0))
#    #im = layer
#    
#    pix = im.load()
#    outImg = Image.new('RGB', im.size, color='white')
#    outFile = open("./outtxt/" + filename + '.txt', 'w')
#    for y in range(im.size[1]):
#        for x in range(im.size[0]):
#            pixel = im.getpixel((x,y))
#            txt = palette(pixel)
#            if txt == '1110100':
#                txt = '1000101'
#            outImg.putpixel((x,y), txt2rgb(txt))
#            outFile.write(txt + '\n')
#            
#    outFile.close()
#    outImg.save("./outpic/" + filename + ".png" )







