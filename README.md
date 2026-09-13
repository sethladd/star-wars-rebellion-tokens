# Star Wars: Rebellion — Imperial and Rebel hex tokens, Sabotage marker and tracker discs (3D printable)

Each token family lives in its own directory with the same layout: a `.scad` model, a
`stl/` output folder, and a `preview/` folder (with a `preview/audit/` subfolder holding
raw printability-audit renders). Shared SVG art is in [`art/`](art/) and shared export /
audit tooling is in [`tools/`](tools/).

```
art/        SVG source art shared across tokens
tools/      export.sh, export_halves.sh, audit.py (shared hex-token audit)
imperial/   Imperial token
rebel/      Rebel token
sabotage/   Sabotage marker
trackers/   Rebels tracker + round tracker discs
preview/    cross-token renders (currently just the glued-halves preview sheet)
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

## Tracker discs ([`trackers/`](trackers/))

Both are 18.75 mm discs, 3.0 mm thick, 0.4 mm chamfers, art inlaid 0.6 mm deep on both
faces (bottom mirrored), delivered whole and as glue-together halves (one half file per
body, print it twice).

**Rebels tracker**: black body, red Rebel starbird (circle r 6.9 mm, measured from the
photo) — the same `art/rebel_starbird.svg` art as the hex token (CC BY-SA 4.0). Model:
[`trackers/rebellion_rebels_tracker.scad`](trackers/rebellion_rebels_tracker.scad). Files:
`trackers/stl/rebellion_rebels_tracker_token.stl` (black) + `..._inlay_red.stl`; halves
`trackers/stl/rebellion_rebels_tracker_half_token.stl` + `..._half_inlay_red.stl`. The
black gaps beside the centre spike are about 0.45 mm and the wing tips taper, as on the
hex token.

**Round tracker** (the Death Star dial): dark brown body with a broken white ring
(r 7.0 to 7.9, 14 segments), a red core (r 3.25) carrying four small yellow marks, and three
cream panels between core and ring. Ring, core and panel radii and angles are measured; the
marks are regularised into an even cross of four 1.2 mm triangles pointing at the centre
(the original's are about 0.7 mm at irregular positions), and the original's hair-fine radial panel lines and tick
marks are left out. Model:
[`trackers/rebellion_round_tracker.scad`](trackers/rebellion_round_tracker.scad). Five
bodies: `trackers/stl/rebellion_round_tracker_token.stl` (dark brown or black),
`..._inlay_white.stl`, `..._inlay_red.stl`, `..._inlay_yellow.stl`, `..._inlay_cream.stl`
(with a 4-slot AMS print the cream panels in white or grey, or skip that body and they
become body colour). Halves: the same five names with `_half_`.

Preview: [`trackers/preview/rebellion_trackers_preview.png`](trackers/preview/rebellion_trackers_preview.png);
[`trackers/audit_disc.py`](trackers/audit_disc.py) is the raster audit.

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
| Rebels tracker | one piece, print it twice | `trackers/stl/rebellion_rebels_tracker_half_token.stl` (black), `..._half_inlay_red.stl` (red) |
| Round tracker | one piece, print it twice | `trackers/stl/rebellion_round_tracker_half_token.stl` (body colour) + the four `_half_inlay_*.stl` colours |

The Rebel and Sabotage tokens carry the same (mirrored) art on both faces, so their top
and bottom halves are the same physical piece. The top half is turned over by a rotation,
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
| `trackers/rebellion_rebels_tracker.scad`, `trackers/rebellion_round_tracker.scad` | Parametric OpenSCAD models of the two 18.75 mm tracker discs |
| `trackers/stl/rebellion_rebels_tracker_*.stl`, `trackers/stl/rebellion_round_tracker_*.stl` | Tracker bodies and inlays, whole and `_half_` |
| `trackers/preview/rebellion_trackers_preview.png` | Render sheet |
| `trackers/audit_disc.py` | Raster printability audit for round tokens (per-colour masks + body lands) |
| `preview/rebellion_halves_preview.png` | Render sheet for the glued-halves versions (Imperial, Rebel, Sabotage) |
| `tools/export.sh`, `tools/export_halves.sh` | Re-export STLs (whole tokens / glued halves); run from the project root |
| `tools/audit.py` | Re-run the raster printability audit for the hex tokens (Imperial and Rebel); run from the project root |

## Printing

Multi-color (recommended): drag all STLs for one token into Bambu Studio / OrcaSlicer
together and accept "load as a single object with multiple parts". Assign black to the
token, white or silver to the two art bodies, grey to the band (Imperial). The parts share
one coordinate frame so they align automatically, and the bottom-face inlays make the
first layer fully solid.

Single color: print only the token STL and paint-fill the recesses. The bottom-face
recesses are then short bridges (max 3.5 mm across the dome) printed directly on the bed;
they print but the bottom face will be rougher than the top.

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
`sabotage/rebellion_sabotage.scad`, `trackers/rebellion_rebels_tracker.scad`,
`trackers/rebellion_round_tracker.scad`, `tools/export.sh`, `tools/export_halves.sh`,
`tools/audit.py`, `sabotage/audit_sabotage.py`, `trackers/audit_disc.py`:
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
