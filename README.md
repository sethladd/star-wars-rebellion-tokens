# Star Wars: Rebellion — Imperial and Rebel hex tokens, Sabotage marker, tracker discs and target markers (3D printable)

Each token gets its own directory with the same layout: a `.scad` model, a `stl/` output
folder, and a `preview/` folder (with a `preview/audit/` subfolder holding raw
printability-audit renders). Shared SVG art is in [`art/`](art/) and shared export / audit
tooling (used by more than one token) is in [`tools/`](tools/).

```
art/             SVG source art shared across tokens
tools/           export.sh, export_halves.sh, audit.py, audit_disc.py (shared audits)
imperial/        Imperial token
rebel/           Rebel token
sabotage/        Sabotage marker
rebels_tracker/  Rebels tracker disc
round_tracker/   Round tracker disc (the Death Star dial)
target_markers/  The four target markers (Raid / Cell / Plans / No Fear)
preview/         cross-token renders (glued-halves sheet, combined trackers sheet)
```

23.5 mm flat-to-flat hexagon (27.1 mm corner to corner), 3.0 mm thick, 0.4 mm edge
chamfers, 0.6 mm engraving on both faces.

## Imperial token ([`imperial/`](imperial/))

- Top face: Galactic Empire crest, the public-domain Wikimedia Commons SVG used as drawn
  (see [License & attribution](#license--attribution)): the emblem's black shape is the
  silver, so the ring segments, hub and spokes read black on a silver ground (a few
  sub-nozzle strokes are grown by 0.02 to 0.35 mm).
- Bottom face: stormtrooper helmet inside a ring with the horizontal band running to the
  edges. Engraved mirrored so it reads correctly when the token is flipped.

Model: [`imperial/rebellion_imperial.scad`](imperial/rebellion_imperial.scad) (all
dimensions in the header block). Bodies: `imperial/stl/rebellion_imperial_token.stl`
(black), `..._art_crest.stl` (crest + arc inlay, top face), `..._art_trooper.stl` (ring +
helmet inlay, bottom face), `..._band.stl` (bottom-face band, separate so it can be grey).
Preview: [`imperial/preview/rebellion_imperial_preview.png`](imperial/preview/rebellion_imperial_preview.png).

## Rebel token ([`rebel/`](rebel/))

Same hexagon and thickness. Light grey body with, on both faces, a black disc (r 8.9 mm)
carrying the red Rebel starbird (circle r 7.8 mm). The faces are otherwise flat; the
faint circle around the disc on the original is a printing effect, not a physical inset. Art is the starbird path extracted
from the Wikimedia Commons "Flag of the Rebel Alliance.svg" (`art/rebel_starbird.svg`) —
CC BY-SA 4.0, see [License & attribution](#license--attribution).

Model: [`rebel/rebellion_rebel.scad`](rebel/rebellion_rebel.scad). Print it as three parts
loaded together: `rebel/stl/rebellion_rebel_token.stl` (grey),
`rebel/stl/rebellion_rebel_inlay_black.stl` (black), `rebel/stl/rebellion_rebel_inlay_red.stl` (red).
The wing tips of the starbird taper below 0.85 mm and the black gaps beside the centre
spike are about 0.5 mm; both print, with slightly softened tips. Preview:
[`rebel/preview/rebellion_rebel_preview.png`](rebel/preview/rebellion_rebel_preview.png).

## Sabotage marker ([`sabotage/`](sabotage/))

33.0 x 17.9 mm rounded rectangle (1.6 mm corners), 3.0 mm thick, 0.4 mm chamfers. Black
body with the red art inlaid 0.6 mm deep on both faces (bottom mirrored). Everything was
measured from a photo of the original at 34.6 px/mm: the 30.2 x 14.1 mm stadium outline
(4.9 mm corner radius, 0.7 mm stroke), the ring (r 4.6, 0.95 wide) with its X (1.0 mm
arms), the bar-and-chevron groups, the side grilles, the corner triangles, and the
Aurebesh word "SABOTAGE" along the bottom edge. Model:
[`sabotage/rebellion_sabotage.scad`](sabotage/rebellion_sabotage.scad). Print as two parts
loaded together: `sabotage/stl/rebellion_sabotage_token.stl` (black) and
`sabotage/stl/rebellion_sabotage_inlay_red.stl` (red).

Features below what a 0.4 mm nozzle can print were grown, so the art is a deliberate
simplification of the original (each is a parameter in `rebellion_sabotage.scad`):

| Feature | Original | Printed |
|---|---|---|
| Side grilles | 5 lines, 0.25 mm wide | 3 lines, 0.5 mm wide, 0.6 mm apart |
| Bars beside the ring | 0.5 mm bars, 0.35 mm gaps | 0.7 mm bars, 0.55 mm gaps |
| Chevron and corner triangles | 0.3 to 0.4 mm outlines | solid |
| Text | 1.5 mm cap height, 0.3 mm strokes | 1.7 mm cap height, 0.55 mm strokes; black gaps inside letters under 0.4 mm are closed, so besh reads as a solid hexagon |

The text is the weakest part of the print (0.55 mm red strokes are a single extrusion
line); set `text_on = false` to get an unbroken stadium outline instead. The faint
Death Star texture in the background of the original is not reproduced. Preview:
[`sabotage/preview/rebellion_sabotage_preview.png`](sabotage/preview/rebellion_sabotage_preview.png);
[`sabotage/audit_sabotage.py`](sabotage/audit_sabotage.py) is the raster audit of the red mask.

## Tracker discs ([`rebels_tracker/`](rebels_tracker/), [`round_tracker/`](round_tracker/))

Both are 18.75 mm discs, 3.0 mm thick, 0.4 mm chamfers, art inlaid 0.6 mm deep on both
faces (bottom mirrored), delivered whole and as glue-together halves (one half file per
body, print it twice).

**Rebels tracker**: black body, red Rebel starbird (circle r 6.9 mm, measured from the
photo) — the same `art/rebel_starbird.svg` art as the hex token (CC BY-SA 4.0). Model:
[`rebels_tracker/rebellion_rebels_tracker.scad`](rebels_tracker/rebellion_rebels_tracker.scad).
Files: `rebels_tracker/stl/rebellion_rebels_tracker_token.stl` (black) + `..._inlay_red.stl`;
halves `rebels_tracker/stl/rebellion_rebels_tracker_half_token.stl` + `..._half_inlay_red.stl`.
The black gaps beside the centre spike are about 0.45 mm and the wing tips taper, as on the
hex token.

**Round tracker** (the Death Star dial): dark brown body with a broken white ring
(r 7.0 to 7.9, 14 segments), a red core (r 3.25) carrying four small yellow marks, and three
cream panels between core and ring. Ring, core and panel radii and angles are measured; the
marks are regularised into an even cross of four 1.2 mm triangles pointing at the centre
(the original's are about 0.7 mm at irregular positions), and the original's hair-fine radial panel lines and tick
marks are left out. Model:
[`round_tracker/rebellion_round_tracker.scad`](round_tracker/rebellion_round_tracker.scad). Five
bodies: `round_tracker/stl/rebellion_round_tracker_token.stl` (dark brown or black),
`..._inlay_white.stl`, `..._inlay_red.stl`, `..._inlay_yellow.stl`, `..._inlay_cream.stl`
(with a 4-slot AMS print the cream panels in white or grey, or skip that body and they
become body colour). Halves: the same five names with `_half_`.

Combined preview: [`preview/rebellion_trackers_preview.png`](preview/rebellion_trackers_preview.png)
(both discs together, hence living in the top-level `preview/`);
[`tools/audit_disc.py`](tools/audit_disc.py) is the shared raster audit for both.

## Target markers ([`target_markers/`](target_markers/))

The four target markers (Outpost, Rebel Cell, Secure the Plans, Show No Fear) are
physically identical: a 26 x 30 mm equilateral triangle with 3.5 mm flats across the corners
(29 x 33.5 mm before the cuts), carrying the same gold "target" symbol over a different
full-colour photograph. The photo is the only thing that tells them apart and cannot be
printed, so the print replaces it with the mission word in the middle of the marker, in
white, inside the gold target symbol: the broken ring and the three arrows pointing in at
it. The ring is enlarged from the original's 9 mm to wrap the word; the original's
hazard-striped corners are left off. 3.0 mm thick, 0.4 mm chamfers, inlays 0.6 mm deep on
both faces (bottom mirrored).

| Marker | Word | `marker=` |
|---|---|---|
| Outpost | RAID | `raid` |
| Rebel Cell | CELL | `cell` |
| Secure the Plans | PLANS | `plans` |
| Show No Fear | NO / FEAR (two lines) | `nofear` |

Ring: outer radius 8.5 mm (0.78 mm of black to the chamfer line at the edge midpoints),
0.9 mm wide, broken by three 32 degree gaps in line with the arrows. Arrows: three
identical solid arrows (1.3 mm shaft, 2.8 x 2.2 mm head, 5 mm long) at 12, 4 and 8
o'clock, tips 0.9 mm outside the ring. The originals' arrows are hollow with a 0.35 mm
outline, below what the nozzle can draw. Words: Helvetica Neue Condensed Bold (a macOS
system font; the `font` parameter takes any other), strokes grown 0.08 mm and letters
spaced 1.2x. Cap heights are set by what fits inside the ring with at least 0.7 mm of
black: 3.8 mm for RAID and CELL, 3.4 mm for the two-line NO / FEAR, and 3.2 mm for the
wide PLANS. At 3.8 and 3.4 mm the stems are 0.8 to 0.9 mm and the horizontal strokes of
E, F and L 0.7 to 0.8 mm; at 3.2 mm (PLANS) the horizontals and the foot of the L are
0.65 to 0.7 mm. Remaining sub-minimum features, all inherent to letterforms at this
size: the counters of A taper to nothing (their top ~1 mm will fill), the black between
some letter pairs and inside the E, F, R and P is 0.55 to 0.65 mm, and the diagonal of
the N in NO is about 0.65 mm. The first print of the ring-less version (same words,
same sizes for RAID and CELL) came out well.

Model: [`target_markers/rebellion_target_markers.scad`](target_markers/rebellion_target_markers.scad)
(`marker` selects the word; every dimension is in the header block). Per marker, three
bodies loaded together: `target_markers/stl/rebellion_target_<marker>_token.stl` (black),
`..._inlay_gold.stl` (arrows), `..._inlay_white.stl` (word). Preview:
[`target_markers/preview/rebellion_target_markers_preview.png`](target_markers/preview/rebellion_target_markers_preview.png).
[`target_markers/audit_target.py`](target_markers/audit_target.py) is the raster audit
(colour features, body lands, and the gold/white/edge clearances); its masks and reports
are in `target_markers/preview/audit/`. [`target_markers/export.sh`](target_markers/export.sh)
re-exports all 24 files. The source photos are `target_markers/rebellion_target_marker_*.jpg`.

## Split versions for gluing (art printed on the bed)

Every token also comes as two 1.5 mm halves, cut at mid-thickness and laid art-face down,
so the fine inlays print directly on the bed instead of as a top surface. Print each half
as a multi-part object exactly like the whole token, then glue the two flat faces together
(the chamfered edges line up the halves). The `half` parameter in each `.scad` produces
them; `tools/export_halves.sh` re-exports the set.

| Token | Halves | Files (load each group together) |
|---|---|---|
| Sabotage | one piece, print it twice | `sabotage/stl/rebellion_sabotage_half_token.stl` (black), `sabotage/stl/rebellion_sabotage_half_inlay_red.stl` (red) |
| Rebel | one piece, print it twice | `rebel/stl/rebellion_rebel_half_token.stl` (grey), `..._half_inlay_black.stl`, `..._half_inlay_red.stl` |
| Imperial, crest side | top half | `imperial/stl/rebellion_imperial_half_top_token.stl` (black), `imperial/stl/rebellion_imperial_half_top_art_crest.stl` (silver) |
| Imperial, trooper side | bottom half | `imperial/stl/rebellion_imperial_half_bottom_token.stl` (black), `..._half_bottom_art_trooper.stl` (white/silver), `..._half_bottom_band.stl` (grey) |
| Rebels tracker | one piece, print it twice | `rebels_tracker/stl/rebellion_rebels_tracker_half_token.stl` (black), `..._half_inlay_red.stl` (red) |
| Round tracker | one piece, print it twice | `round_tracker/stl/rebellion_round_tracker_half_token.stl` (body colour) + the four `_half_inlay_*.stl` colours |
| Target markers | one piece per marker, print it twice | `target_markers/stl/rebellion_target_<marker>_half_token.stl` (black), `..._half_inlay_gold.stl`, `..._half_inlay_white.stl` |

The Rebel and Sabotage tokens and the target markers carry the same (mirrored) art on both
faces, so their top and bottom halves are the same physical piece (checked for the target
markers: the symmetric difference of the two halves is 0.0001 mm3 of 522). The top half is turned over by a rotation,
not a mirror, so the glued token is identical to the one-piece version. Preview:
[`preview/rebellion_halves_preview.png`](preview/rebellion_halves_preview.png) (covers the
Imperial, Rebel and Sabotage halves). The originals are unchanged.

## Files

| File | What it is |
|---|---|
| `art/Emblem_of_the_First_Galactic_Empire.svg` | Public-domain crest from Wikimedia Commons (the Imperial token's top-face art) |
| `art/Flag_of_the_Rebel_Alliance.svg` | Source file downloaded as-is from Wikimedia Commons (CC BY-SA 4.0) |
| `art/rebel_starbird.svg` | Starbird path extracted from `Flag_of_the_Rebel_Alliance.svg` (CC BY-SA 4.0, derivative); used by the Rebel token and the Rebels tracker |
| `art/helmet_outline.svg` | Helmet silhouette traced from the photo of the original Imperial token (1 unit = 1 mm); original content |
| `art/sabotage_aurebesh.svg` | "SABOTAGE" in Aurebesh, glyphs copied from the public-domain Commons chart below (1 unit = 1 mm, cap height 1 mm) |
| `imperial/rebellion_imperial.scad` | Parametric OpenSCAD model of the Imperial token |
| `imperial/stl/rebellion_imperial_token.stl` | Token body with both faces engraved |
| `imperial/stl/rebellion_imperial_art_crest.stl` | Inlay body: crest + arc (fills the top-face voids exactly) |
| `imperial/stl/rebellion_imperial_art_trooper.stl` | Inlay body: ring + helmet (bottom face) |
| `imperial/stl/rebellion_imperial_band.stl` | Inlay body: the band (bottom face, separate so it can be grey) |
| `imperial/preview/rebellion_imperial_preview.png` | Render sheet |
| `rebel/rebellion_rebel.scad` | Parametric OpenSCAD model of the Rebel token |
| `rebel/stl/rebellion_rebel_*.stl` | Rebel token bodies (grey token + black/red inlays) |
| `rebel/preview/rebellion_rebel_preview.png` | Render sheet |
| `sabotage/rebellion_sabotage.scad` | Parametric OpenSCAD model of the Sabotage marker |
| `sabotage/stl/rebellion_sabotage_token.stl`, `sabotage/stl/rebellion_sabotage_inlay_red.stl` | Sabotage marker body (black) and its exact-complement red inlay |
| `sabotage/preview/rebellion_sabotage_preview.png` | Render sheet |
| `sabotage/audit_sabotage.py` | Raster printability audit of the sabotage red mask |
| `rebels_tracker/rebellion_rebels_tracker.scad` | Parametric OpenSCAD model of the Rebels tracker disc |
| `rebels_tracker/stl/rebellion_rebels_tracker_*.stl` | Rebels tracker bodies and inlays, whole and `_half_` |
| `round_tracker/rebellion_round_tracker.scad` | Parametric OpenSCAD model of the Round tracker disc |
| `round_tracker/stl/rebellion_round_tracker_*.stl` | Round tracker bodies and inlays, whole and `_half_` |
| `preview/rebellion_trackers_preview.png` | Render sheet (both tracker discs together) |
| `target_markers/rebellion_target_markers.scad` | Parametric OpenSCAD model of the four target markers (`marker=` picks the word) |
| `target_markers/stl/rebellion_target_<marker>_*.stl` | Target marker bodies (black token + gold arrows + white word), whole and `_half_` |
| `target_markers/preview/rebellion_target_markers_preview.png` | Render sheet |
| `target_markers/audit_target.py`, `target_markers/export.sh` | Raster printability audit and STL export for the target markers; run from the project root |
| `target_markers/rebellion_target_marker_*.jpg` | Photos of the four originals |
| `preview/rebellion_halves_preview.png` | Render sheet for the glued-halves versions (Imperial, Rebel, Sabotage) |
| `tools/export.sh`, `tools/export_halves.sh` | Re-export STLs (whole tokens / glued halves); run from the project root |
| `tools/audit.py` | Re-run the raster printability audit for the hex tokens (Imperial and Rebel); run from the project root |
| `tools/audit_disc.py` | Raster printability audit for the round tokens (per-colour masks + body lands); takes file paths as arguments |

## Printing

Multi-color (recommended): drag all STLs for one token into Bambu Studio / OrcaSlicer
together and accept "load as a single object with multiple parts". Assign black to the
token, white or silver to the two art bodies, grey to the band (Imperial); for the target
markers black, gold (or yellow) and white. The parts share
one coordinate frame so they align automatically, and the bottom-face inlays make the
first layer fully solid.

Single color: print only the token STL and paint-fill the recesses. The bottom-face
recesses are then short bridges (max 3.5 mm across the dome) printed directly on the bed;
they print but the bottom face will be rougher than the top.

**"Object too small — scale to millimeters?" on import: answer No.** Snapmaker Orca (and
other OrcaSlicer/PrusaSlicer builds) flags any body below a size threshold and offers to
rescale it, guessing the file is in inches or metres. Every STL here is already in
millimetres. The small inlay bodies trip it — the worst is the round tracker's yellow half
inlay, the four marks in the middle of the red core, at 3.4 x 3.4 x 0.6 mm. Answering Yes
multiplies that part by 25.4 and it lands in the plate as a ~86 mm slab while its siblings
stay 18.75 mm. Answer No and the parts keep their true size and stay aligned.

0.10 to 0.12 mm layers, Arachne walls on, no brim or supports.

## Design minimums (0.4 mm nozzle)

Lands (raised black features: brow slit, lenses, frown chevron, mouth, vents) are all
at or above 0.7 mm. Engraved strokes are 1.0 mm except the crest's outer silver band and ring bridges
(about 0.85 to 0.9 mm) and small tapering corners such as the silver toes beside the bottom
vents, which will print with slightly rounded tips.

## License & attribution

This is an unofficial, non-commercial fan project. *Star Wars*, the Galactic Empire crest,
the Rebel Alliance starbird, and related names/marks are trademarks of Lucasfilm Ltd. /
The Walt Disney Company. This project is not affiliated with or endorsed by them, and the
underlying designs may still be protected as trademarks even where the copyright status
below is public domain.

**Original code** — `imperial/rebellion_imperial.scad`, `rebel/rebellion_rebel.scad`,
`sabotage/rebellion_sabotage.scad`, `rebels_tracker/rebellion_rebels_tracker.scad`,
`round_tracker/rebellion_round_tracker.scad`, `tools/export.sh`, `tools/export_halves.sh`,
`tools/audit.py`, `tools/audit_disc.py`, `sabotage/audit_sabotage.py`:
[BSD 3-Clause](LICENSE-CODE.md).

**Original content** — `art/helmet_outline.svg` (traced from a photo of the physical token),
`art/sabotage_aurebesh.svg` (layout of public-domain glyphs), the STL files in each
token's `stl/` folder, the preview renders in each token's `preview/` folder, and this
README: [CC BY-SA 4.0](LICENSE-CONTENT.md).

**Third-party art** (kept under its original license, not this project's):

| File | Source | License |
|---|---|---|
| `art/Emblem_of_the_First_Galactic_Empire.svg` | [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Emblem_of_the_First_Galactic_Empire.svg) | Public domain (`PD-textlogo` — simple geometric/text shape, below the threshold of originality); trademark still applies |
| `art/Flag_of_the_Rebel_Alliance.svg` | [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Flag_of_the_Rebel_Alliance.svg), uploaded by Mannivu, itself incorporating the emblem from [File:Emblem of the Rebel Alliance.svg](https://commons.wikimedia.org/wiki/File:Emblem_of_the_Rebel_Alliance.svg) by Mariano Agustin Serrano | CC BY-SA 4.0 |
| `art/rebel_starbird.svg` | Starbird path extracted from `Flag_of_the_Rebel_Alliance.svg` above | CC BY-SA 4.0 (derivative — same attribution and share-alike terms apply) |
| `art/sabotage_aurebesh.svg` | Glyphs from [File:Star-Wars-aurek-besh-alphabet-chart.svg](https://commons.wikimedia.org/wiki/File:Star-Wars-aurek-besh-alphabet-chart.svg) by AnonMoos (drawn with the newAurabesh font, text converted to paths) | Public domain (released by the author); Aurebesh itself is a Lucasfilm design |

Because the Rebel starbird source is CC BY-SA 4.0, the Rebel token's and Rebels tracker's art and any STL/model
files derived from it are also CC BY-SA 4.0 (see [LICENSE-CONTENT.md](LICENSE-CONTENT.md)),
with attribution to Mannivu and Mariano Agustin Serrano via the Commons file pages above.
