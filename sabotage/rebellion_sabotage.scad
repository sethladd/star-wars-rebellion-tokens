// ============================================================================
// Star Wars: Rebellion — Sabotage marker, 3D printable
// 33.0 x 17.9mm rounded rectangle, 3.0mm thick. Black body with the red
// art inlaid 0.6mm deep on both faces (bottom mirrored so it reads correctly
// when flipped). Every dimension was measured from a photo of the original
// (34.6 px/mm); features thinner than a 0.4mm nozzle can print were grown to
// the minimums noted beside them.
//
// part = "token"      -> printable body (black): art recessed 0.6mm both faces
//        "inlay_red"  -> exact-complement inlay body: the red art
//        "face"       -> 2D layout check (token outline + art)
//        "audit_red"  -> bare 2D red mask for the raster audit
//        "preview"    -> coloured OpenCSG preview
// half = "top" | "bottom" -> that half only (cut at 1.5mm), laid art-face down for
//        printing on the bed; glue the flat faces. Works with every 3D part above.
// Text: "SABOTAGE" in Aurebesh, glyph paths from the public-domain Wikimedia
// Commons chart Star-Wars-aurek-besh-alphabet-chart.svg (sabotage_aurebesh.svg).
// ============================================================================

/* [Selection] */
part = "token";

/* [Token] */
width = 33.0;
height = 17.9;
corner_r = 1.6;        // token corner radius (measured)
thickness = 3.0;
chamfer = 0.4;         // edge chamfer top and bottom, also fights elephant-foot
engrave = 0.6;         // inlay depth per face (3 layers @ 0.2mm)
two_sided = true;      // art on both faces (bottom mirrored)

/* [Split for gluing] */
half = "none";       // "none" = whole token. "top" / "bottom" = only that half, cut at
                     // mid-thickness and laid art-face DOWN so the inlays print on the
                     // bed; glue the two flat faces together afterwards.

/* [Stadium outline] */
st_w = 30.2;           // centreline width  (measured 30.2)
st_h = 14.1;           // centreline height (measured 14.1)
st_r = 4.9;            // centreline corner radius (fitted 4.9)
st_stroke = 0.7;       // measured 0.65

/* [Corner triangles] (solid; original is a 0.4mm outline with a 0.5mm hole) */
tri_leg = 1.55;        // right-angle legs along the token edges
tri_cx = 14.9;         // outer corner of each triangle
tri_cy = 7.85;

/* [Centre ring and X] */
ring_R = 4.6;          // outer radius (measured 4.6)
ring_w = 0.95;         // measured 0.95
x_arm_w = 1.0;         // measured ~1.0
x_half_len = 2.45;     // centre to arm end; tip corners ~1.1mm inside the ring
x_round = 0.3;         // corner rounding of the X

/* [Bar groups either side of the ring] */
bar_w = 0.7;           // measured 0.5, grown
bar_gap = 0.55;        // measured 0.35, grown (black land between red bars)
bar_h = 3.4;           // measured 3.4
split_gap = 0.6;       // the innermost bar is broken at mid-height (measured 0.4)
tri2_w = 1.2;          // solid chevron (original is a 0.3mm outline)
tri2_h = 2.4;
tri2_tip_gap = 0.7;    // from chevron tip to ring outer edge

/* [Side grilles] (original: 5 lines 0.25mm wide; printed as 3) */
gr_n = 3;
gr_w = 0.5;
gr_pitch = 1.1;        // 0.6mm black between lines
gr_len_mid = 11.0;     // the middle line ends here (|x|), the outer ones 0.9 further out
gr_len_step = 0.9;

/* [Text] */
text_on = true;
text_cap = 1.7;        // cap height (original 1.5mm, too small to print)
text_stroke = 0.55;    // strokes grown to this (glyph strokes are 0.2 * cap)
text_y = -6.95;        // vertical centre, 0.1 above the stadium's bottom line (keeps 0.6mm to the chamfer)
text_close = 0.4;      // black gaps inside the letters narrower than this are closed
text_margin = 0.8;     // stadium line cleared this far beyond the word
text_svg = "../art/sabotage_aurebesh.svg";
text_svg_w = 14.7480;  // viewBox width of that file (word spans 0.5 .. W-0.5)

$fa = 2; $fs = 0.2;
eps = 0.01;
T = thickness;

// ---------------------------------------------------------------- 2D helpers
module rrect(w, h, r) { offset(r = r) square([w - 2 * r, h - 2 * r], center = true); }
module ring2d(w, h, r, s) { difference() { rrect(w + s, h + s, r + s / 2); rrect(w - s, h - s, r - s / 2); } }
module opening(m) { offset(delta = m / 2) offset(delta = -m / 2) children(); }
module closing(m) { offset(delta = -m / 2) offset(delta = m / 2) children(); }
module mirror4() { for (sx = [1, -1], sy = [1, -1]) scale([sx, sy]) children(); }
module mirror2x() { for (sx = [1, -1]) scale([sx, 1]) children(); }

// ---------------------------------------------------------------- token
module outline2d() { rrect(width, height, corner_r); }

module blank() {
    hull() {
        translate([0, 0, chamfer]) linear_extrude(T - 2 * chamfer) outline2d();
        linear_extrude(T) offset(delta = -chamfer) outline2d();
    }
}

// ---------------------------------------------------------------- art
module text2d() {
    s = text_cap;
    closing(text_close) offset(delta = (text_stroke - 0.2 * text_cap) / 2)
        translate([0, text_y]) scale(s) translate([-text_svg_w / 2, -1.0])
            import(text_svg, center = false, dpi = 25.4);
}
text_w = text_svg_w * text_cap - text_cap;   // word width (file pads 0.5 units each side)

module stadium2d() {
    difference() {
        ring2d(st_w, st_h, st_r, st_stroke);
        if (text_on) translate([0, -st_h / 2]) square([text_w + 2 * text_margin, 3 * st_stroke], center = true);
    }
}

module corner_tris2d() {
    mirror4() translate([tri_cx, tri_cy]) polygon([[0, 0], [-tri_leg, 0], [0, -tri_leg]]);
}

module ring_x2d() {
    difference() { circle(r = ring_R); circle(r = ring_R - ring_w); }
    offset(r = x_round) offset(delta = -x_round)
        for (a = [45, -45]) rotate(a) square([2 * x_half_len, x_arm_w], center = true);
}

module bars2d() {
    x_tip = ring_R + tri2_tip_gap;          // chevron tip
    x_base = x_tip + tri2_w;                // chevron base
    x1 = x_base + bar_gap;                  // bars start here
    mirror2x() {
        polygon([[-x_tip, 0], [-x_base, tri2_h / 2], [-x_base, -tri2_h / 2]]);
        for (i = [0 : 2]) {
            x0 = x1 + i * (bar_w + bar_gap);
            if (i == 0) for (sy = [1, -1])
                translate([-x0 - bar_w / 2, sy * (split_gap / 2 + (bar_h - split_gap) / 4)])
                    square([bar_w, (bar_h - split_gap) / 2], center = true);
            else translate([-x0 - bar_w / 2, 0]) square([bar_w, bar_h], center = true);
        }
    }
}

module grille2d() {
    mirror2x() for (i = [0 : gr_n - 1]) {
        y = (i - (gr_n - 1) / 2) * gr_pitch;
        len = (i == (gr_n - 1) / 2) ? gr_len_mid : gr_len_mid + gr_len_step;
        x_out = width / 2 + 1;              // start past the edge; the blank clips it
        translate([-(x_out + len) / 2, y]) square([x_out - len, gr_w], center = true);
    }
}

module red2d() {
    stadium2d(); corner_tris2d(); ring_x2d(); bars2d(); grille2d();
    if (text_on) text2d();
}

// ---------------------------------------------------------------- 3D
module both_faces(h = engrave) {
    translate([0, 0, T - h]) linear_extrude(h + eps) children();
    if (two_sided) translate([0, 0, -eps]) linear_extrude(h + eps) mirror([1, 0]) children();
}
module cut_red() { both_faces() red2d(); }
module below() { translate([0, 0, -1 - eps]) linear_extrude(1) offset(delta = 5) outline2d(); }
module above() { translate([0, 0, T + eps]) linear_extrude(1) offset(delta = 5) outline2d(); }


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

module token() { difference() { blank(); cut_red(); } }

if (part == "token") halve() token();
else if (part == "inlay_red") halve() intersection() { blank(); cut_red(); }
else if (part == "face") {
    difference() { outline2d(); offset(delta = -0.15) outline2d(); }
    difference() { offset(delta = -chamfer) outline2d(); offset(delta = -chamfer - 0.08) outline2d(); }
    red2d();
}
else if (part == "audit_red") red2d();
else if (part == "preview") halve() {
    color([0.1, 0.1, 0.11]) token();
    color([0.85, 0.15, 0.15]) difference() {   // clipped in 2D so OpenCSG can draw it
        both_faces() intersection() { red2d(); offset(delta = -0.05) outline2d(); }
        above(); below();
    }
}
