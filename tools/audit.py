"""Raster printability audit of the engraving masks on the hex tokens (Imperial, Rebel).
Run from the project root, e.g.:
    python3 tools/audit.py imperial/preview/audit/top imperial/preview/audit/bot
    python3 tools/audit.py rebel/preview/audit/rebel_black rebel/preview/audit/rebel_red:0.7
`name` is a path (without .png) to a 100 px/mm render; optionally suffixed `:groove_min`."""
import numpy as np
from PIL import Image
from scipy import ndimage as ndi
ppm=100.0; apothem=11.75-0.4
def disk(dmm):
    r=int(round(dmm*ppm/2)); y,x=np.ogrid[-r:r+1,-r:r+1]; return (x*x+y*y)<=r*r
def audit(name, land_min=0.7, groove_min=1.0):
    im=np.asarray(Image.open(f"{name}.png").convert("RGB")).astype(int)
    bg=im[40,40]; eng=(np.abs(im-bg).sum(axis=2)>60)
    h,w=eng.shape; yy,xx=np.mgrid[0:h,0:w]; cx=cy=(w-1)/2
    X=(xx-cx)/ppm; Y=(cy-yy)/ppm
    inhex=(np.abs(Y)<apothem)&(np.abs(X*np.cos(np.radians(30))+np.abs(Y)*np.sin(np.radians(30)))<apothem)
    eng&=inhex
    print(f"== {name}: engraved extent x[{X[eng].min():.2f},{X[eng].max():.2f}] y[{Y[eng].min():.2f},{Y[eng].max():.2f}]")
    land=(~eng)&inhex
    for mask,minw,label in ((eng,groove_min,"ENGRAVED thinner than"),(land,land_min,"LAND thinner than")):
        thin=mask&~ndi.binary_opening(mask, structure=disk(minw))
        thin=ndi.binary_opening(thin, structure=disk(0.08))   # ignore corner nibbles
        lab,n=ndi.label(thin); found=0
        for i,sl in enumerate(ndi.find_objects(lab)):
            a=(lab==i+1).sum()/ppm**2
            if a<0.1: continue
            found+=1; ys,xs=np.where(lab==i+1); yc,xc=int(ys.mean()),int(xs.mean())
            print(f"  {label} {minw}mm: area {a:.2f}mm2 at ({X[yc,xc]:.2f},{Y[yc,xc]:.2f}) spanning x[{X[0,xs.min()]:.2f},{X[0,xs.max()]:.2f}] y[{Y[ys.max(),0]:.2f},{Y[ys.min(),0]:.2f}]")
        if not found: print(f"  {label} {minw}mm: none (>0.1mm2)")
import sys
if len(sys.argv) > 1:
    for arg in sys.argv[1:]:
        name, _, g = arg.partition(":")
        audit(name, groove_min=float(g) if g else 1.0)
else:
    audit("imperial/preview/audit/top"); audit("imperial/preview/audit/bot")
