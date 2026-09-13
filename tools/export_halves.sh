#!/bin/bash
# Export the split-for-gluing halves (art face down) as binary STL. Run from the project root:
#   tools/export_halves.sh
# Rebel and Sabotage: top and bottom halves are the same piece -> one file, print it twice.
OSCAD="${OSCAD:-/Applications/OpenSCAD-2021.01.app/Contents/MacOS/OpenSCAD}"
ex() { # model part half outfile
  ( "$OSCAD" --render --export-format binstl -o "$4" -D "part=\"$2\"" -D "half=\"$3\"" "$1" 2>&1 \
      | grep -iE 'error|warning|Total rendering' | sed "s|^|[$4] |" ) &
}
ex sabotage/rebellion_sabotage.scad token     bottom sabotage/stl/rebellion_sabotage_half_token.stl
ex sabotage/rebellion_sabotage.scad inlay_red bottom sabotage/stl/rebellion_sabotage_half_inlay_red.stl
ex rebel/rebellion_rebel.scad token        bottom rebel/stl/rebellion_rebel_half_token.stl
ex rebel/rebellion_rebel.scad inlay_black  bottom rebel/stl/rebellion_rebel_half_inlay_black.stl
ex rebel/rebellion_rebel.scad inlay_red    bottom rebel/stl/rebellion_rebel_half_inlay_red.stl
ex imperial/rebellion_imperial.scad token       top    imperial/stl/rebellion_imperial_half_top_token.stl
ex imperial/rebellion_imperial.scad art_crest   top    imperial/stl/rebellion_imperial_half_top_art_crest.stl
ex imperial/rebellion_imperial.scad token       bottom imperial/stl/rebellion_imperial_half_bottom_token.stl
ex imperial/rebellion_imperial.scad art_trooper bottom imperial/stl/rebellion_imperial_half_bottom_art_trooper.stl
ex imperial/rebellion_imperial.scad band        bottom imperial/stl/rebellion_imperial_half_bottom_band.stl
ex trackers/rebellion_rebels_tracker.scad token     bottom trackers/stl/rebellion_rebels_tracker_half_token.stl
ex trackers/rebellion_rebels_tracker.scad inlay_red bottom trackers/stl/rebellion_rebels_tracker_half_inlay_red.stl
ex trackers/rebellion_round_tracker.scad token        bottom trackers/stl/rebellion_round_tracker_half_token.stl
ex trackers/rebellion_round_tracker.scad inlay_white  bottom trackers/stl/rebellion_round_tracker_half_inlay_white.stl
ex trackers/rebellion_round_tracker.scad inlay_red    bottom trackers/stl/rebellion_round_tracker_half_inlay_red.stl
ex trackers/rebellion_round_tracker.scad inlay_yellow bottom trackers/stl/rebellion_round_tracker_half_inlay_yellow.stl
ex trackers/rebellion_round_tracker.scad inlay_cream  bottom trackers/stl/rebellion_round_tracker_half_inlay_cream.stl
wait; echo "half exports done"; ls -la imperial/stl/*_half_* rebel/stl/*_half_* sabotage/stl/*_half_* trackers/stl/*_half_*
