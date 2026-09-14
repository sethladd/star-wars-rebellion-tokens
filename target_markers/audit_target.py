"""Raster printability audit for the target markers.
usage: audit_target.py MIN_FEATURE MIN_LAND BODY.png GOLD.png WHITE.png
Masks are 100 px/mm renders (imgsize 3400x3400 at camera distance 85, ortho) of the 2D
parts audit_body / audit_gold / audit_white. Each colour mask is checked for features
thinner than MIN_FEATURE; the body (inside the chamfer line) minus both colours is checked
for lands thinner than MIN_LAND; and the clearances gold-white, gold-edge, white-edge are
printed."""
import sys, numpy as np
from PIL import Image
from scipy import ndimage as ndi
fmin, lmin = map(float, sys.argv[1:3]); body_f, gold_f, white_f = sys.argv[3:6]
ppm = 100.0
def disk(dmm):
    r = int(round(dmm * ppm / 2)); y, x = np.ogrid[-r:r + 1, -r:r + 1]; return (x * x + y * y) <= r * r
def load(f):
    im = np.asarray(Image.open(f).convert("RGB")).astype(int); bg = im[20, 20]
    return np.abs(im - bg).sum(axis=2) > 60
body, gold, white = load(body_f), load(gold_f), load(white_f)
h, w = body.shape; yy, xx = np.mgrid[0:h, 0:w]; cx = cy = (w - 1) / 2
X = (xx - cx) / ppm; Y = (cy - yy) / ppm
def report(mask, minw, label):
    thin = mask & ~ndi.binary_opening(mask, structure=disk(minw))
    thin = ndi.binary_opening(thin, structure=disk(0.08))
    lab, n = ndi.label(thin); found = 0
    for i, sl in enumerate(ndi.find_objects(lab)):
        a = (lab == i + 1).sum() / ppm ** 2
        if a < 0.05: continue
        found += 1; ys, xs = np.where(lab == i + 1)
        print(f"  {label} {minw}mm: area {a:.2f}mm2 at x[{X[0, xs.min()]:.2f},{X[0, xs.max()]:.2f}] y[{Y[ys.max(), 0]:.2f},{Y[ys.min(), 0]:.2f}]")
    if not found: print(f"  {label} {minw}mm: none (>0.05mm2)")
def clearance(a, b):
    d = ndi.distance_transform_edt(~a) / ppm
    return d[b].min() if b.any() else float("nan")
for name, m in (("gold", gold), ("white", white)):
    print(f"== {name}: area {m.sum() / ppm**2:.2f}mm2, x[{X[m].min():.2f},{X[m].max():.2f}] y[{Y[m].min():.2f},{Y[m].max():.2f}]")
    report(m, fmin, "COLOUR thinner than")
    if (m & ~body).any(): print(f"  !! {name} crosses the chamfer line")
land = body & ~gold & ~white
print("== body lands (inside the chamfer line, both colours removed)")
report(land, lmin, "LAND thinner than")
edge = body & ~ndi.binary_erosion(body, structure=disk(0.06))
print(f"== clearances: gold-white {clearance(gold, white):.2f}  gold-edge {clearance(edge, gold):.2f}  white-edge {clearance(edge, white):.2f}")
