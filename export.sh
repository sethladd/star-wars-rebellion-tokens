#!/bin/bash
# Export all four bodies as binary STL (run from the project folder).
OSCAD="${OSCAD:-/Applications/OpenSCAD-2021.01.app/Contents/MacOS/OpenSCAD}"
for p in token art_crest art_trooper band; do
  out="stl/rebellion_imperial_${p}.stl"; [ "$p" = token ] && out="stl/rebellion_imperial_token.stl"
  ( "$OSCAD" --render --export-format binstl -o "$out" -D "part=\"$p\"" rebellion_imperial.scad 2>&1 \
      | grep -iE 'error|warning|Total rendering' | sed "s|^|[$p] |" ) &
done
wait; echo "exports done"; ls -la stl
