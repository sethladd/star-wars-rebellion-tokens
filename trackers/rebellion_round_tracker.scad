// ============================================================================
// Star Wars: Rebellion — Round tracker disc (Death Star dial), 3D printable
// 18.75mm diameter, 3.0mm thick. Dark body with, on both faces (bottom
// mirrored): a broken white ring, a red core with four small yellow marks,
// and three cream panels between core and ring. Radii and angles were
// measured from a photo of the original (46.3 px/mm). The original's fine
// radial panel lines and tick marks are below what a 0.4mm nozzle prints
// and are left out.
//
// part = "token"        -> printable body: every colour region recessed 0.6mm
//        "inlay_white"  -> ring segments      (exact complements of the pockets)
//        "inlay_red"    -> core minus the marks
//        "inlay_yellow" -> the four marks
//        "inlay_cream"  -> the three panels (optional 5th colour: print in white
//                          or grey if the AMS has only 4 slots, or skip)
//        "face"         -> 2D layout check
//        "audit_white" / "audit_red" / "audit_yellow" / "audit_cream" -> 2D masks
//        "preview"      -> coloured OpenCSG preview
// half = "top" | "bottom" -> that half only (cut at 1.5mm), laid art-face down for
//        printing on the bed; glue the flat faces. Both halves are the same piece.
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
two_sided = true;

/* [Ring] (measured r 7.0 .. 7.9) */
ring_r0 = 7.0;
ring_r1 = 7.9;
// segment [start, end] in degrees, ccw from 3 o'clock; gaps >= 6 deg = 0.78mm of body
ring_segments = [[-22, 14], [20, 54], [60, 72], [78, 86], [92, 116], [122, 136], [142, 164],
                 [172, 190], [198, 212], [218, 232], [238, 248], [254, 264], [270, 294], [300, 332]];

/* [Core] */
core_R = 3.25;       // red disc (measured 3.25)
// yellow marks: four rounded triangles equally spaced on a circle, tips pointing at
// the centre (the original's marks sit at irregular radii/angles; regularised at the
// user's request)
mark_n = 4;
mark_a0 = 45;        // angle of the first mark, degrees ccw from 3 o'clock
mark_r = 1.9;        // circle the marks' centres sit on; keeps >= 0.6mm red to the core edge
mark_size = 1.2;     // original ~0.7mm, grown to print
mark_round = 0.2;

/* [Cream panels] ([angle start, angle end]; radial extent below) */
panels = [[-5, 18], [140, 160], [212, 232]];
panel_r0 = 3.85;     // 0.6mm of body outside the core
panel_r1 = 6.4;      // 0.6mm of body inside the ring

$fa = 2; $fs = 0.2;
eps = 0.01;
R = diameter / 2;
T = thickness;

// ---------------------------------------------------------------- helpers
module blank() {
    hull() {
        translate([0, 0, chamfer]) cylinder(r = R, h = T - 2 * chamfer);
        cylinder(r = R - chamfer, h = T);
    }
}
module sector2d(a0, a1, r) {           // pie wedge a0..a1 (ccw), radius r
    n = max(2, ceil((a1 - a0) / 2));
    polygon(concat([[0, 0]], [for (i = [0 : n]) let (a = a0 + (a1 - a0) * i / n) [r * cos(a), r * sin(a)]]));
}
module annulus_sector2d(a0, a1, r0, r1) {
    intersection() { sector2d(a0, a1, r1 + 1); difference() { circle(r = r1); circle(r = r0); } }
}

// ---------------------------------------------------------------- art
module white2d() { for (s = ring_segments) annulus_sector2d(s[0], s[1], ring_r0, ring_r1); }
module mark2d() {
    s = mark_size;
    offset(r = mark_round) offset(delta = -mark_round)
        polygon([[0.6 * s, 0], [-0.4 * s, 0.5 * s], [-0.4 * s, -0.5 * s]]);
}
module yellow2d() {   // mark2d points +x (outward); turn it to point at the centre
    for (i = [0 : mark_n - 1]) rotate(mark_a0 + i * 360 / mark_n) translate([mark_r, 0]) rotate(180) mark2d();
}
module red2d()    { difference() { circle(r = core_R); yellow2d(); } }
module cream2d()  { for (p = panels) annulus_sector2d(p[0], p[1], panel_r0, panel_r1); }
module core2d()   { circle(r = core_R); }          // the pocket for red + yellow
module all2d()    { white2d(); core2d(); cream2d(); } // everything recessed in the body

// ---------------------------------------------------------------- 3D
module both_faces(h = engrave) {
    translate([0, 0, T - h]) linear_extrude(h + eps) children();
    if (two_sided) translate([0, 0, -eps]) linear_extrude(h + eps) mirror([1, 0]) children();
}
module token() { difference() { blank(); both_faces() all2d(); } }
module inlay() { intersection() { blank(); both_faces() children(); } }
module below() { translate([0, 0, -1 - eps]) cylinder(r = R + 5, h = 1); }
module above() { translate([0, 0, T + eps]) cylinder(r = R + 5, h = 1); }
module clipped() { difference() { both_faces(engrave + 0.03) children(); above(); below(); } }  // preview only, 0.03 proud against z-fighting

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
else if (part == "inlay_white")  halve() inlay() white2d();
else if (part == "inlay_red")    halve() inlay() red2d();
else if (part == "inlay_yellow") halve() inlay() yellow2d();
else if (part == "inlay_cream")  halve() inlay() cream2d();
else if (part == "face") {
    difference() { circle(r = R); circle(r = R - 0.15); }
    difference() { circle(r = R - chamfer); circle(r = R - chamfer - 0.08); }
    white2d(); red2d(); cream2d();
}
else if (part == "audit_white")  white2d();
else if (part == "audit_red")    red2d();
else if (part == "audit_yellow") yellow2d();
else if (part == "audit_cream")  cream2d();
else if (part == "audit_all")    all2d();
else if (part == "preview") halve() {
    color([0.17, 0.11, 0.09]) token();
    color([0.95, 0.95, 0.93]) clipped() white2d();
    color([0.55, 0.07, 0.09]) clipped() red2d();
    color([0.95, 0.85, 0.35]) clipped() yellow2d();
    color([0.82, 0.72, 0.52]) clipped() cream2d();
}
