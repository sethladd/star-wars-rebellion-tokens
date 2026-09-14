#!/bin/bash
# Export the four target markers as binary STL (whole tokens + glue halves).
# Run from the project root:  target_markers/export.sh
# Each marker is three bodies: token (black), inlay_gold (arrows), inlay_white (word).
# Both faces carry the same mirrored design, so one half file per body: print it twice.
OSCAD="${OSCAD:-/Applications/OpenSCAD-2021.01.app/Contents/MacOS/OpenSCAD}"
SCAD=target_markers/rebellion_target_markers.scad
ex() { # marker part half outfile
  ( "$OSCAD" --render --export-format binstl -o "$4" -D "marker=\"$1\"" -D "part=\"$2\"" -D "half=\"$3\"" "$SCAD" 2>&1 \
      | grep -iE 'error|warning|Total rendering' | grep -v Fontconfig | sed "s|^|[$4] |" ) &
}
for m in raid cell plans nofear; do
  for p in token inlay_gold inlay_white; do
    ex $m $p none   target_markers/stl/rebellion_target_${m}_${p}.stl
    ex $m $p bottom target_markers/stl/rebellion_target_${m}_half_${p}.stl
  done
  wait
done
echo "target marker exports done"; ls -la target_markers/stl
