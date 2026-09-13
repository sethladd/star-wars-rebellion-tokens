"""Raster printability audit for a round token.
usage: audit_disc.py RADIUS CHAMFER MIN_FEATURE MIN_LAND MASK.png [MASK.png ...]
Masks are 100 px/mm renders (imgsize 2000x2000 at camera distance 50) of the 2D colour
regions. Each mask is checked for coloured features thinner than MIN_FEATURE; the union
of all masks is checked for body lands thinner than MIN_LAND inside the chamfer edge."""
import sys, numpy as np
from PIL import Image
from scipy import ndimage as ndi
R, ch, fmin, lmin = map(float, sys.argv[1:5]); files = sys.argv[5:]
ppm = 100.0
def disk(dmm):
    r = int(round(dmm * ppm / 2)); y, x = np.ogrid[-r:r + 1, -r:r + 1]; return (x * x + y * y) <= r * r
def load(f):
    im = np.asarray(Image.open(f).convert("RGB")).astype(int); bg = im[20, 20]
    return np.abs(im - bg).sum(axis=2) > 60
def report(mask, minw, label, X, Y):
    thin = mask & ~ndi.binary_opening(mask, structure=disk(minw))
    thin = ndi.binary_opening(thin, structure=disk(0.08))
    lab, n = ndi.label(thin); found = 0
    for i, sl in enumerate(ndi.find_objects(lab)):
        a = (lab == i + 1).sum() / ppm ** 2
        if a < 0.05: continue
        found += 1; ys, xs = np.where(lab == i + 1)
        print(f"  {label} {minw}mm: area {a:.2f}mm2 at x[{X[0, xs.min()]:.2f},{X[0, xs.max()]:.2f}] y[{Y[ys.max(), 0]:.2f},{Y[ys.min(), 0]:.2f}]")
    if not found: print(f"  {label} {minw}mm: none (>0.05mm2)")
union = None
for f in files:
    m = load(f); h, w = m.shape; yy, xx = np.mgrid[0:h, 0:w]; cx = cy = (w - 1) / 2
    X = (xx - cx) / ppm; Y = (cy - yy) / ppm; inside = np.hypot(X, Y) < R - ch
    m &= inside
    print(f"== {f}: area {m.sum() / ppm**2:.2f}mm2, r max {np.hypot(X, Y)[m].max() if m.any() else 0:.2f}")
    report(m, fmin, "COLOUR thinner than", X, Y)
    union = m if union is None else (union | m)
land = (~union) & inside
print("== body lands (all masks combined)")
report(land, lmin, "LAND thinner than", X, Y)
