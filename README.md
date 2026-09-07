# Star Wars: Rebellion — Imperial and Rebel hex tokens (3D printable)

23.5 mm flat-to-flat hexagon (27.1 mm corner to corner), 3.0 mm thick, 0.4 mm edge
chamfers, 0.6 mm engraving on both faces.

- Top face: Galactic Empire crest, the public-domain Wikimedia Commons SVG used as drawn
  (see [License & attribution](#license--attribution)): the emblem's black shape is the
  silver, so the ring segments, hub and spokes read black on a silver ground (a few
  sub-nozzle strokes are grown by 0.02 to 0.35 mm).
- Bottom face: stormtrooper helmet inside a ring with the horizontal band running to the
  edges. Engraved mirrored so it reads correctly when the token is flipped.

## Rebel token

Same hexagon and thickness. Light grey body with, on both faces, a black disc (r 8.9 mm)
carrying the red Rebel starbird (circle r 7.8 mm) and a fine embossed circle outside the
disc, modelled as a 0.8 mm wide, 0.2 mm deep groove. Art is the starbird path extracted
from the Wikimedia Commons "Flag of the Rebel Alliance.svg" (`rebel_starbird.svg`) —
CC BY-SA 4.0, see [License & attribution](#license--attribution).

Print it as three parts loaded together: `stl/rebellion_rebel_token.stl` (grey),
`stl/rebellion_rebel_inlay_black.stl` (black), `stl/rebellion_rebel_inlay_red.stl` (red).
The wing tips of the starbird taper below 0.85 mm and the black gaps beside the centre
spike are about 0.5 mm; both print, with slightly softened tips.

## Files

| File | What it is |
|---|---|
| `rebellion_imperial.scad` | Parametric OpenSCAD model of the Imperial token (all dimensions in the header block) |
| `rebellion_rebel.scad` | Parametric OpenSCAD model of the Rebel token |
| `Flag_of_the_Rebel_Alliance.svg` | Source file downloaded as-is from Wikimedia Commons (CC BY-SA 4.0) |
| `rebel_starbird.svg` | Starbird path extracted from `Flag_of_the_Rebel_Alliance.svg` (CC BY-SA 4.0, derivative) |
| `Emblem_of_the_First_Galactic_Empire.svg` | Public-domain crest from Wikimedia Commons (the top-face art) |
| `helmet_outline.svg` | Helmet silhouette traced from the photo of the original token (1 unit = 1 mm); original content |
| `stl/rebellion_imperial_token.stl` | Token body with both faces engraved |
| `stl/rebellion_imperial_art_crest.stl` | Inlay body: crest + arc (fills the top-face voids exactly) |
| `stl/rebellion_imperial_art_trooper.stl` | Inlay body: ring + helmet (bottom face) |
| `stl/rebellion_imperial_band.stl` | Inlay body: the band (bottom face, separate so it can be grey) |
| `preview/rebellion_imperial_preview.png`, `preview/rebellion_rebel_preview.png` | Render sheets |
| `export.sh`, `audit.py` | Re-export STLs / re-run the raster printability audit |

## Printing

Multi-color (recommended): drag all four STLs into Bambu Studio / OrcaSlicer together and
accept "load as a single object with multiple parts". Assign black to the token, white or
silver to the two art bodies, grey to the band. The parts share one coordinate frame so
they align automatically, and the bottom-face inlays make the first layer fully solid.

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

**Original code** — `rebellion_imperial.scad`, `rebellion_rebel.scad`, `export.sh`,
`audit.py`: [BSD 3-Clause](LICENSE-CODE.md).

**Original content** — `helmet_outline.svg` (traced from a photo of the physical token),
the STL files in `stl/`, the preview renders in `preview/`, and this README:
[CC BY-SA 4.0](LICENSE-CONTENT.md).

**Third-party art** (kept under its original license, not this project's):

| File | Source | License |
|---|---|---|
| `Emblem_of_the_First_Galactic_Empire.svg` | [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Emblem_of_the_First_Galactic_Empire.svg) | Public domain (`PD-textlogo` — simple geometric/text shape, below the threshold of originality); trademark still applies |
| `Flag_of_the_Rebel_Alliance.svg` | [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Flag_of_the_Rebel_Alliance.svg), uploaded by Mannivu, itself incorporating the emblem from [File:Emblem of the Rebel Alliance.svg](https://commons.wikimedia.org/wiki/File:Emblem_of_the_Rebel_Alliance.svg) by Mariano Agustin Serrano | CC BY-SA 4.0 |
| `rebel_starbird.svg` | Starbird path extracted from `Flag_of_the_Rebel_Alliance.svg` above | CC BY-SA 4.0 (derivative — same attribution and share-alike terms apply) |

Because the Rebel starbird source is CC BY-SA 4.0, the Rebel token's art and any STL/model
files derived from it are also CC BY-SA 4.0 (see [LICENSE-CONTENT.md](LICENSE-CONTENT.md)),
with attribution to Mannivu and Mariano Agustin Serrano via the Commons file pages above.
