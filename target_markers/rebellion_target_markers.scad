// ============================================================================
// Star Wars: Rebellion — Target markers (Raid / Cell / Plans / No Fear), 3D printable
// Equilateral triangle with clipped corners, 26.0mm tall and 30.0mm wide as measured
// on the clipped token (29.0 x 33.5mm before the corner cuts), 3.0mm thick.
// The originals are identical apart from a full-colour photo behind a gold
// "target" symbol, so the print replaces the photo with the mission word in the
// middle: black body, three gold arrows pointing in at a white word, inlaid 0.6mm
// deep on both faces (bottom mirrored so it reads correctly when flipped).
//
// marker = "raid" | "cell" | "plans" | "nofear"  -> which word (see words table)
// part = "token"        -> printable body (black): inlays recessed 0.6mm both faces
//        "inlay_gold"   -> exact-complement inlay body: the three arrows
//        "inlay_white"  -> exact-complement inlay body: the word
//        "face"         -> 2D layout check (outline, chamfer line, arrows, word)
//        "audit_gold" | "audit_white" | "audit_body" -> bare 2D masks for the raster audit
//        "preview"      -> coloured OpenCSG preview
// half = "top" | "bottom" -> that half only (cut at 1.5mm), laid art-face down for
//        printing on the bed; glue the flat faces. Works with every 3D part above.
//        Both faces carry the same (mirrored) design, so the two halves are the
//        same physical piece: export one and print it twice.
// ============================================================================

/* [Selection] */
marker = "raid";
part = "token";

/* [Token] */
height = 26.0;         // base edge to the flat at the clipped apex (measured with a ruler)
clip = 3.5;            // width of the flat cut across each corner (measured ~3.5)
thickness = 3.0;
chamfer = 0.4;         // edge chamfer top and bottom, also fights elephant-foot
engrave = 0.6;         // inlay depth per face (3 layers @ 0.2mm)
two_sided = true;      // art on both faces (bottom mirrored)

/* [Split for gluing] */
half = "none";         // "none" = whole token. "top" / "bottom" = only that half, cut at
                       // mid-thickness and laid art-face DOWN so the inlays print on the
                       // bed; glue the two flat faces together afterwards.

/* [Ring] (broken at the three arrows, like the original; original outer r 4.5, 1.05 wide) */
ring_on = true;
ring_r = 8.5;          // outer radius: leaves 0.78mm of black to the chamfer line at the edge midpoints
ring_w = 0.9;          // radial width
ring_gap = 32;         // opening angle of each gap, centred on the arrows (original ~30)
ring_tip_gap = 0.9;    // black between the ring and each arrow tip (original 0.9)

/* [Arrows] (three identical arrows at 12, 4 and 8 o'clock pointing at the centre) */
arrow_tip = ring_on ? ring_r + ring_tip_gap : 7.2;   // tip distance from the centre
arrow_len = 5.0;       // tip to tail (original ~6; shortened to stay clear of the clipped corners)
arrow_shaft = 1.3;     // original 1.4 hollow with a 0.35mm outline; printed solid
arrow_head_w = 2.8;    // head width (measured 2.6..2.8)
arrow_head_l = 2.2;    // head length

/* [Word] */
font = "Helvetica Neue:style=Condensed Bold";  // macOS system font; a condensed bold keeps
                       // the words inside the triangle at a cap height whose horizontal
                       // strokes (0.165 x cap) and the gaps inside E (0.235 x cap) both
                       // clear 0.7mm. Substitute e.g. "Liberation Sans Narrow:style=Bold".
cap_per_size = 0.996;  // Helvetica Neue Condensed Bold: cap height / text() size (measured)
grow = 0.08;           // strokes grown by this (each side): stems 0.20*cap+0.16, arms 0.165*cap+0.16
spacing = 1.2;         // letter spacing factor (black between letters 0.12*cap+0.2*advance-0.16 >= 0.7mm)
line_gap = 1.0;        // black between the two lines of a two-line word

// mission -> printed word (one or two lines), cap height, shift [x, y].
// Sized so every word keeps >= 0.7mm of black inside the ring (inner r 7.6): RAID and
// CELL 3.8mm, the wide PLANS 3.2mm, the two-line NO / FEAR 3.4mm. PLANS and FEAR are
// nudged right because text() centres the advance box and their ink is wider on the left.
words = [["raid", ["RAID"], 3.8, [0, 0]], ["cell", ["CELL"], 3.8, [0, 0]],
         ["plans", ["PLANS"], 3.2, [0.13, 0]], ["nofear", ["NO", "FEAR"], 3.4, [0.17, 0]]];
lines = words[search([marker], words)[0]][1];
cap = words[search([marker], words)[0]][2];
word_shift = words[search([marker], words)[0]][3];

$fa = 2; $fs = 0.2;
eps = 0.01;
T = thickness;
clip_d = clip / (2 * tan(30));     // depth of the corner cut along the corner axis
R_in = (height + clip_d) / 3;      // inradius (centre to each edge) of the unclipped triangle
R_c = 2 * R_in;                    // circumradius (centre to each unclipped corner)

// ---------------------------------------------------------------- 2D
module outline2d() {
    intersection() {
        rotate(90) circle(r = R_c, $fn = 3);                 // apex up
        rotate(-90) circle(r = 2 * (R_c - clip_d), $fn = 3); // inverted triangle clips the corners
    }
}

module arrow2d() {   // one arrow on the +y axis, pointing down at the centre
    translate([0, arrow_tip]) {
        polygon([[0, 0], [arrow_head_w / 2, arrow_head_l], [-arrow_head_w / 2, arrow_head_l]]);
        translate([-arrow_shaft / 2, arrow_head_l - eps]) square([arrow_shaft, arrow_len - arrow_head_l]);
    }
}
module ring2d() {
    difference() {
        circle(r = ring_r);
        circle(r = ring_r - ring_w);
        for (a = [90, 210, 330]) rotate(a)
            polygon([[0, 0], [20 * cos(ring_gap / 2), 20 * sin(ring_gap / 2)], [20 * cos(-ring_gap / 2), 20 * sin(-ring_gap / 2)]]);
    }
}
module gold2d() { for (a = [0, 120, 240]) rotate(a) arrow2d(); if (ring_on) ring2d(); }

module white2d() {
    n = len(lines);
    c = cap;
    lead = c + line_gap;
    translate(word_shift) for (i = [0 : n - 1])
        translate([0, (n - 1) * lead / 2 - i * lead - c / 2])
            offset(delta = grow)
                text(lines[i], size = c / cap_per_size, font = font, spacing = spacing,
                     halign = "center", valign = "baseline");
}

// ---------------------------------------------------------------- 3D
module blank() {
    hull() {
        translate([0, 0, chamfer]) linear_extrude(T - 2 * chamfer) outline2d();
        linear_extrude(T) offset(delta = -chamfer) outline2d();
    }
}
module both_faces(h = engrave) {
    translate([0, 0, T - h]) linear_extrude(h + eps) children();
    if (two_sided) translate([0, 0, -eps]) linear_extrude(h + eps) mirror([1, 0]) children();
}
module cut_gold()  { both_faces() gold2d(); }
module cut_white() { both_faces() white2d(); }

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

module token() { difference() { blank(); cut_gold(); cut_white(); } }

if (part == "token") halve() token();
else if (part == "inlay_gold")  halve() intersection() { blank(); cut_gold(); }
else if (part == "inlay_white") halve() intersection() { blank(); cut_white(); }
else if (part == "face") {
    difference() { outline2d(); offset(delta = -0.15) outline2d(); }
    difference() { offset(delta = -chamfer) outline2d(); offset(delta = -chamfer - 0.08) outline2d(); }
    gold2d(); white2d();
}
else if (part == "audit_gold")  gold2d();
else if (part == "audit_white") white2d();
else if (part == "audit_body")  offset(delta = -chamfer) outline2d();
else if (part == "preview") halve() {
    color([0.1, 0.1, 0.11]) token();
    color([0.85, 0.65, 0.30]) both_faces() gold2d();
    color([0.95, 0.95, 0.93]) both_faces() white2d();
}
