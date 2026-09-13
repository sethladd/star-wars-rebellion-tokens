"""Raster printability audit of the sabotage marker's red mask (100 px/mm render in
preview/audit/sab_red.png). Run from anywhere: python3 sabotage/audit_sabotage.py"""
import numpy as np
from pathlib import Path
from PIL import Image
from scipy import ndimage as ndi
HERE=Path(__file__).resolve().parent
ppm=100.0; W,H,R,CH=33.0,17.9,1.6,0.4
def disk(dmm):
    r=int(round(dmm*ppm/2)); y,x=np.ogrid[-r:r+1,-r:r+1]; return (x*x+y*y)<=r*r
def audit(name="sab_red", land_min=0.5, red_min=0.5):
    im=np.asarray(Image.open(HERE/f"preview/audit/{name}.png").convert("RGB")).astype(int)
    bg=im[40,40]; red=(np.abs(im-bg).sum(axis=2)>60)
    h,w=red.shape; yy,xx=np.mgrid[0:h,0:w]; cx=cy=None; cx=(w-1)/2; cy=(h-1)/2
    X=(xx-cx)/ppm; Y=(cy-yy)/ppm
    hw,hh,r=W/2-CH,H/2-CH,R-CH   # face inside the chamfer
    inside=(np.abs(X)<=hw)&(np.abs(Y)<=hh)&~((np.abs(X)>hw-r)&(np.abs(Y)>hh-r)&(np.hypot(np.abs(X)-(hw-r),np.abs(Y)-(hh-r))>r))
    red&=inside; land=(~red)&inside
    print(f"== {name}: red extent x[{X[red].min():.2f},{X[red].max():.2f}] y[{Y[red].min():.2f},{Y[red].max():.2f}], red area {red.sum()/ppm**2:.1f}mm2")
    for mask,minw,label in ((red,red_min,"RED thinner than"),(land,land_min,"LAND thinner than")):
        thin=mask&~ndi.binary_opening(mask, structure=disk(minw))
        thin=ndi.binary_opening(thin, structure=disk(0.08))
        lab,n=ndi.label(thin); found=0
        for i,sl in enumerate(ndi.find_objects(lab)):
            a=(lab==i+1).sum()/ppm**2
            if a<0.05: continue
            found+=1; ys,xs=np.where(lab==i+1)
            print(f"  {label} {minw}mm: area {a:.2f}mm2 at x[{X[0,xs.min()]:.2f},{X[0,xs.max()]:.2f}] y[{Y[ys.max(),0]:.2f},{Y[ys.min(),0]:.2f}]")
        if not found: print(f"  {label} {minw}mm: none (>0.05mm2)")
import sys
lm=float(sys.argv[1]) if len(sys.argv)>1 else 0.5
rm=float(sys.argv[2]) if len(sys.argv)>2 else 0.5
audit(land_min=lm, red_min=rm)
