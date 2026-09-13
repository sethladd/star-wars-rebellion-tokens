// ============================================================================
// Star Wars: Rebellion — Rebel hex token, 3D printable
// 23.5mm flat-to-flat hexagon (corners at 3 and 9 o'clock), 3.0mm thick.
// Light grey body; on BOTH faces a black disc carrying the red Rebel
// starbird. The faces are otherwise flat (the faint circle visible around
// the disc on the original is a printing effect, not a physical feature).
// The bottom face is mirrored so it reads correctly when flipped.
//
// part = "token"        -> printable body (grey): disc recessed 0.6mm both faces
//        "inlay_black"  -> exact-complement inlay: disc minus starbird
//        "inlay_red"    -> exact-complement inlay: the starbird
//        "face"         -> 2D layout check
//        "audit_black" / "audit_red" -> bare 2D colour masks for the audit
//        "preview"      -> coloured OpenCSG preview (top face)
// half = "top" | "bottom" -> that half only (cut at 1.5mm), laid art-face down for
//        printing on the bed; glue the flat faces. Works with every 3D part above.
// Art: starbird path from the public-domain Wikimedia
// "Flag of the Rebel Alliance.svg", extracted to rebel_starbird.svg.
// ============================================================================

/* [Selection] */
part = "token";

/* [Token] */
flat_to_flat = 23.5; // across flats
thickness = 3.0;
chamfer = 0.4;       // edge chamfer top and bottom, also fights elephant-foot
engrave = 0.6;       // inlay depth per face (3 layers @ 0.2mm)
art_min_feature = 0.25; // drop starbird slivers thinner than this

/* [Split for gluing] */
half = "none";       // "none" = whole token. "top" / "bottom" = only that half, cut at
                     // mid-thickness and laid art-face DOWN so the inlays print on the
                     // bed; glue the two flat faces together afterwards.

/* [Art] (measured from the photo of the original) */
disc_R = 8.9;        // black disc radius
star_R = 7.8;        // radius of the starbird's circle (the SVG's circle is 300 units)
star_svg = "../art/rebel_starbird.svg";
star_svg_units = 300;      // circle radius in SVG units
star_svg_cy = -5.98;       // circle centre below the bbox centre (SVG units, y up)

$fa = 3; $fs = 0.25;
eps = 0.01;

hex_R = flat_to_flat / 2 / cos(30);  // corner radius (13.568)
T = thickness;

// ---------------------------------------------------------------- blank
module hex2d(r) { circle(r = r, $fn = 6); }   // corners at 0/60/...: flats top+bottom

module blank() {
    hull() {
        translate([0, 0, chamfer]) linear_extrude(T - 2 * chamfer) hex2d(hex_R);
        linear_extrude(T) offset(delta = -chamfer / cos(30)) hex2d(hex_R);
    }
}

module opening(m) { offset(delta = m / 2) offset(delta = -m / 2) children(); }

// ---------------------------------------------------------------- art
star_s = star_R / star_svg_units;
module starbird2d() {
    opening(art_min_feature)
        scale(star_s) translate([0, -star_svg_cy])
            import(star_svg, center = true, dpi = 25.4);
}
module red2d()   { starbird2d(); }
module black2d() { difference() { circle(r = disc_R); starbird2d(); } }
module recess2d() { circle(r = disc_R); }              // the inlay pocket

// ---------------------------------------------------------------- 3D
// cutters for both faces; bottom mirrored left-right
module both_faces(h = engrave) {
    translate([0, 0, T - h]) linear_extrude(h + eps) children();
    translate([0, 0, -eps]) linear_extrude(h + eps) mirror([1, 0]) children();
}
module cut_recess() { both_faces() recess2d(); }
module cut_black()  { both_faces() black2d(); }
module cut_red()    { both_faces() red2d(); }


// ---------------------------------------------------------------- halves
// Cut at T/2. "bottom" keeps z in [0, T/2] as is (its art is already at z=0).
// "top" keeps z in [T/2, T] and turns it over (a rotation, not a mirror, so it is
// the same physical piece) to put the top-face art on the bed.
module halve() {
    if (half == "bottom")
        difference() { children(); translate([0, 0, T / 2]) linear_extrude(T) square(200, center = true); }
    else if (half == "top")
        translate([0, 0, T]) rotate([180, 0, 0])
            difference() { children(); translate([0, 0, -T / 2]) linear_extrude(T) square(200, center = true); }
    else children();
}

module token() { difference() { blank(); cut_recess(); } }

module below() { translate([0, 0, -1 - eps]) linear_extrude(1) hex2d(hex_R + 5); }
module above() { translate([0, 0, T + eps]) linear_extrude(1) hex2d(hex_R + 5); }

if (part == "token") halve() token();
else if (part == "inlay_black") halve() intersection() { blank(); cut_black(); }
else if (part == "inlay_red")   halve() intersection() { blank(); cut_red(); }
else if (part == "face") {
    difference() { hex2d(hex_R); offset(delta = -0.15) hex2d(hex_R); }
    black2d(); red2d();
}
else if (part == "audit_black") black2d();
else if (part == "audit_red")   red2d();
else if (part == "preview") halve() {   // difference-only so OpenCSG shows it; the red is
    color([0.78, 0.78, 0.8]) token();   // drawn 0.03mm proud to avoid z-fighting
    color([0.08, 0.08, 0.09]) difference() { cut_black(); above(); below(); }
    color([0.8, 0.12, 0.12]) both_faces(engrave + 0.03) red2d();
}
