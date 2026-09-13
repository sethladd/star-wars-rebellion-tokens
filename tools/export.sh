#!/bin/bash
# Export all bodies as binary STL. Run from the project root:
#   tools/export.sh
OSCAD="${OSCAD:-/Applications/OpenSCAD-2021.01.app/Contents/MacOS/OpenSCAD}"
for p in token art_crest art_trooper band; do
  out="imperial/stl/rebellion_imperial_${p}.stl"; [ "$p" = token ] && out="imperial/stl/rebellion_imperial_token.stl"
  ( "$OSCAD" --render --export-format binstl -o "$out" -D "part=\"$p\"" imperial/rebellion_imperial.scad 2>&1 \
      | grep -iE 'error|warning|Total rendering' | sed "s|^|[$p] |" ) &
done
wait; echo "exports done"; ls -la imperial/stl

# Sabotage marker (two bodies)
for p in token inlay_red; do
  ( "$OSCAD" --render --export-format binstl -o "sabotage/stl/rebellion_sabotage_${p}.stl" -D "part=\"$p\"" sabotage/rebellion_sabotage.scad 2>&1 \
      | grep -iE 'error|warning|Total rendering' | sed "s|^|[sabotage $p] |" ) &
done
wait; ls -la sabotage/stl/rebellion_sabotage_*

# Rebels tracker and round tracker discs
for p in token inlay_red; do
  ( "$OSCAD" --render --export-format binstl -o "trackers/stl/rebellion_rebels_tracker_${p}.stl" -D "part=\"$p\"" trackers/rebellion_rebels_tracker.scad 2>&1 \
      | grep -iE 'error|warning|Total rendering' | sed "s|^|[rebels_tracker $p] |" ) &
done
for p in token inlay_white inlay_red inlay_yellow inlay_cream; do
  ( "$OSCAD" --render --export-format binstl -o "trackers/stl/rebellion_round_tracker_${p}.stl" -D "part=\"$p\"" trackers/rebellion_round_tracker.scad 2>&1 \
      | grep -iE 'error|warning|Total rendering' | sed "s|^|[round_tracker $p] |" ) &
done
wait; ls -la trackers/stl/rebellion_*_tracker_*
