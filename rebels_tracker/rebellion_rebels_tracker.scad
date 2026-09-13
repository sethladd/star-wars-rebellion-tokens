// ============================================================================
// Star Wars: Rebellion — Rebels tracker disc, 3D printable
// 18.75mm diameter, 3.0mm thick. Black body with the red Rebel starbird
// inlaid 0.6mm deep on both faces (bottom mirrored so it reads correctly
// when flipped). Starbird circle radius measured from the photo: 6.85mm.
//
// part = "token"      -> printable body (black): starbird recessed both faces
//        "inlay_red"  -> exact-complement inlay: the starbird
//        "face"       -> 2D layout check
//        "audit_red"  -> bare 2D red mask for the raster audit
//        "preview"    -> coloured OpenCSG preview
// half = "top" | "bottom" -> that half only (cut at 1.5mm), laid art-face down for
//        printing on the bed; glue the flat faces. Both halves are the same piece.
// Art: starbird path from the Wikimedia Commons "Flag of the Rebel Alliance.svg"
// (CC BY-SA 4.0), extracted to rebel_starbird.svg.
// ============================================================================

/* [Selection] */
part = "token";

/* [Split for gluing] */
half = "none";       // "none" = whole token. "top" / "bottom" = only that half, cut at
                     // mid-thickness and laid art-face DOWN so the inlays print on the
                     // bed; glue the two flat faces together afterwards.

/* [Token] */
diameter = 18.75;
thickness = 3.0;
chamfer = 0.4;       // edge chamfer top and bottom, also fights elephant-foot
engrave = 0.6;       // inlay depth per face (3 layers @ 0.2mm)
art_min_feature = 0.25; // drop starbird slivers thinner than this
two_sided = true;

/* [Art] (measured from the photo of the original) */
star_R = 6.9;        // radius of the starbird's circle (measured 6.85)
star_svg = "../art/rebel_starbird.svg";
star_svg_units = 300;      // circle radius in SVG units
star_svg_cy = -5.98;       // circle centre below the bbox centre (SVG units, y up)

$fa = 2; $fs = 0.2;
eps = 0.01;
R = diameter / 2;
T = thickness;

// ---------------------------------------------------------------- blank
module blank() {
    hull() {
        translate([0, 0, chamfer]) cylinder(r = R, h = T - 2 * chamfer);
        cylinder(r = R - chamfer, h = T);
    }
}
module opening(m) { offset(delta = m / 2) offset(delta = -m / 2) children(); }

// ---------------------------------------------------------------- art
star_s = star_R / star_svg_units;
module red2d() {
    opening(art_min_feature)
        scale(star_s) translate([0, -star_svg_cy])
            import(star_svg, center = true, dpi = 25.4);
}

// ---------------------------------------------------------------- 3D
module both_faces(h = engrave) {
    translate([0, 0, T - h]) linear_extrude(h + eps) children();
    if (two_sided) translate([0, 0, -eps]) linear_extrude(h + eps) mirror([1, 0]) children();
}
module cut_red() { both_faces() red2d(); }
module token() { difference() { blank(); cut_red(); } }
module below() { translate([0, 0, -1 - eps]) cylinder(r = R + 5, h = 1); }
module above() { translate([0, 0, T + eps]) cylinder(r = R + 5, h = 1); }

// ---------------------------------------------------------------- halves
module halve() {
    if (half == "bottom")
        difference() { children(); translate([0, 0, T / 2]) linear_extrude(T) square(200, center = true); }
    else if (half == "top")
        translate([0, 0, T]) rotate([180, 0, 0])
            difference() { children(); translate([0, 0, -T / 2]) linear_extrude(T) square(200, center = true); }
    else children();
}

if (part == "token") halve() token();
else if (part == "inlay_red") halve() intersection() { blank(); cut_red(); }
else if (part == "face") {
    difference() { circle(r = R); circle(r = R - 0.15); }
    difference() { circle(r = R - chamfer); circle(r = R - chamfer - 0.08); }
    red2d();
}
else if (part == "audit_red") red2d();
else if (part == "preview") halve() {
    color([0.08, 0.08, 0.09]) token();
    color([0.75, 0.12, 0.15]) difference() { both_faces(engrave + 0.03) red2d(); above(); below(); }
}
