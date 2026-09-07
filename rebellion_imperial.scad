// ============================================================================
// Star Wars: Rebellion — Imperial hex token, 3D printable
// 23.5mm flat-to-flat hexagon (corners at 3 and 9 o'clock), 3.0mm thick.
// Top face:    Galactic Empire crest (from the Wikimedia emblem SVG)
// Bottom face: stormtrooper helmet inside a ring, horizontal band to edges
//              (engraved mirrored so it reads correctly when flipped over)
//
// part = "token"        -> printable body, both faces engraved 0.6mm
//        "art_crest"    -> exact-complement inlay for the top face (crest)
//        "art_trooper"  -> exact-complement inlay: ring + helmet (bottom)
//        "band"         -> exact-complement inlay: the band (bottom)
//        "face_top"     -> 2D layout check of the crest face
//        "face_bot"     -> 2D layout check of the trooper face (as read)
//        "preview"      -> colored OpenCSG preview, top face
//        "preview_bot"  -> colored OpenCSG preview, bottom face (as printed)
// All art is built from the same 2D modules as the cutters, so the inlay
// bodies fit the token voids exactly (load them together in the slicer).
// ============================================================================

/* [Selection] */
part = "token";

/* [Token] */
flat_to_flat = 23.5; // across flats
thickness = 3.0;
chamfer = 0.4;       // edge chamfer top and bottom, also fights elephant-foot
engrave = 0.6;       // engraving depth per face (3 layers @ 0.2mm)
art_min_feature = 0.25; // drop engraved slivers thinner than this

/* [Crest face] */
// The crest is the public-domain Wikimedia SVG "Emblem of the First Galactic
// Empire" used as drawn: the emblem's BLACK shape is what is silver on the
// real token (its white cut-outs -- the ring segments and the cog -- stay
// black). Scaled so the emblem's outer edge (300 units) lands at crest_R,
// which reproduces every radius measured from the photo.
crest_svg = "Emblem_of_the_First_Galactic_Empire.svg";
crest_R = 7.6;          // outer radius of the emblem (measured from the photo)
// Sub-nozzle strokes are grown just enough to print (0.4mm nozzle):
crest_band_grow = 0.35; // outer silver band: 0.63mm in the SVG -> ~0.88mm
crest_ring_grow = 0.10; // black ring segments: thin ends 0.51mm -> 0.71mm
crest_cog_grow = 0.02;  // black spokes: 0.68mm at the hub -> 0.72mm
crest_bridge_w = 0.85;  // silver bridges at the six ring breaks (0.7 in the SVG)

/* [Trooper face] */
ring_R = 9.6;        // outer radius of the ring
ring_w = 1.0;
band_h = 8.0;        // total height of the horizontal band
helm_scale = 1.0;    // helmet silhouette scale (1.0 = 13.3 x 14.1mm, as on the original)
helm_dy = 0.0;       // vertical offset of the helmet inside the ring

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

// ---------------------------------------------------------------- helpers
function mirror_poly(pts) =
    concat(pts, [for (i = [len(pts) - 1 : -1 : 0]) [-pts[i][0], pts[i][1]]]);

module sector2d(a0, a1, r) {    // pie wedge from a0 to a1 (ccw), radius r
    n = max(4, ceil((a1 - a0) / 3));
    polygon(concat([[0, 0]],
        [for (i = [0 : n]) let (a = a0 + (a1 - a0) * i / n) r * [cos(a), sin(a)]]));
}

module opening(m) { offset(delta = m / 2) offset(delta = -m / 2) children(); }
module round_convex(r) { offset(r = r) offset(r = -r) children(); }

// ---------------------------------------------------------------- crest
crest_s = crest_R / 300;        // mm per SVG unit

module emblem_black2d() {       // the SVG as drawn: disc minus the emblem cut-outs
    scale(crest_s) import(crest_svg, center = true, dpi = 25.4);
}
module emblem_white2d() {       // the cut-outs only (ring segments + cog)
    difference() { circle(r = 290 * crest_s); emblem_black2d(); }
}
module crest2d() {              // silver = the emblem's black shape
    union() {
        difference() {
            circle(r = 300 * crest_s + crest_band_grow);
            offset(delta = crest_ring_grow)
                intersection() { emblem_white2d(); difference() { circle(r = 300 * crest_s); circle(r = 230 * crest_s); } }
            offset(delta = crest_cog_grow)
                intersection() { emblem_white2d(); circle(r = 230 * crest_s); }
        }
        for (k = [0 : 5]) rotate(90 + 60 * k)   // silver bridges at the ring breaks
            translate([230 * crest_s, -crest_bridge_w / 2])
                square([70 * crest_s + crest_band_grow, crest_bridge_w]);
    }
}

module face_top2d() { opening(art_min_feature) crest2d(); }

// ---------------------------------------------------------------- trooper
// Helmet outer silhouette: traced from the photo of the original token
// (helmet_outline.svg, 1 unit = 1mm, ring centre drawn at (8,8);
// bbox x +-6.63, y -6.90..7.18). The black features (brow slit, lenses,
// nose, mouth, vents) are rebuilt as geometry sized for a
// 0.4mm nozzle (lands >= 0.7mm) and placed from the traced feature boxes.
module helmet_silhouette2d() {   // the SVG is drawn with its origin at (8,8)
    translate([-8, -8]) import("helmet_outline.svg", center = false, dpi = 25.4);
}

brow_y0 = 2.55; brow_y1 = 3.25;     // slit between dome and faceplate (0.7 land)
frown_top = -0.6;    // apex of the frown chevron
frown_slope = 0.634; // arm drop per mm of run (0.634 = 32 degrees)
frown_thick = 0.8;   // arm thickness measured perpendicular to the arm
frown_apex_r = 1.2;  // centerline radius of the rounded apex (outer edge r + 0.4)
mouth_open = true;   // centre mouth opening runs out through the chin (false = closed arch)
// lenses run up into the brow slit (top edge hidden inside it, so the rounded
// corners do not leave nicks); lens body spans y 1.5..2.55 at the inner end
eye_pts = [[0.6, 2.9], [4.2, 2.9], [4.2, 1.1], [3.7, 0.2], [3.1, 0.4], [0.6, 1.5]];

module helmet_features2d() {                               // black = not engraved
    translate([-6, brow_y0]) square([12, brow_y1 - brow_y0]);   // brow slit
    for (s = [1, -1]) scale([s, 1]) {
        round_convex(0.2) polygon(eye_pts);                // lens
        hull() {                                           // bottom vent (open)
            translate([2.6, -5.6]) scale([0.65, 0.7]) circle(r = 1);
            translate([2.6, -7.5]) scale([0.65, 0.7]) circle(r = 1);
        }
    }
    frown2d();
    hull() {                                               // mouth arch
        translate([0, -4.5]) circle(r = 0.95);
        translate([-0.95, mouth_open ? -7.5 : -5.75]) square([1.9, 0.01]);
    }
}

// frown: a downturned chevron whose apex is a tangent arc. Built as a thin
// centerline polygon (two rays joined by the arc) thickened with offset(),
// so the band is frown_thick wide everywhere; the outer edge tops out at
// frown_top and the arms run past the silhouette on both sides.
module frown2d() {
    th = atan(frown_slope);
    yc = frown_top - frown_thick / 2 + frown_apex_r * (1 / cos(th) - 1);
    cy = yc - frown_apex_r / cos(th);          // arc centre (on the axis)
    n = 12;
    path = concat(
        [[-9, yc - 9 * frown_slope]],
        [for (i = [0 : n]) let (a = 90 + th - 2 * th * i / n)
            [frown_apex_r * cos(a), cy + frown_apex_r * sin(a)]],
        [[9, yc - 9 * frown_slope]]);
    offset(r = frown_thick / 2 - 0.005)
        polygon(concat(path, [for (i = [len(path) - 1 : -1 : 0]) path[i] - [0, 0.01]]));
}

module helmet2d() {
    translate([0, helm_dy]) scale(helm_scale)
        difference() { helmet_silhouette2d(); helmet_features2d(); }
}

module ring2d() { difference() { circle(r = ring_R); circle(r = ring_R - ring_w); } }

module band2d() {                 // from the ring outward to (past) the hex edge
    difference() {
        translate([-hex_R - 2, -band_h / 2]) square([2 * hex_R + 4, band_h]);
        circle(r = ring_R - eps);
    }
}

// the trooper face as it reads (not mirrored)
module face_bot2d() { opening(art_min_feature) { ring2d(); helmet2d(); } }

// ---------------------------------------------------------------- 3D
module cut_top()  { translate([0, 0, T - engrave]) linear_extrude(engrave + eps) face_top2d(); }
module cut_bot()  { translate([0, 0, -eps]) linear_extrude(engrave + eps) mirror([1, 0]) face_bot2d(); }
module cut_band() { translate([0, 0, -eps]) linear_extrude(engrave + eps) mirror([1, 0]) band2d(); }

module token() { difference() { blank(); cut_top(); cut_bot(); cut_band(); } }

if (part == "token") token();
else if (part == "art_crest")   intersection() { blank(); cut_top(); }
else if (part == "art_trooper") intersection() { blank(); cut_bot(); }
else if (part == "band")        intersection() { blank(); cut_band(); }
else if (part == "audit_top") face_top2d();          // bare masks for the audit
else if (part == "audit_bot") { face_bot2d(); band2d(); }
else if (part == "face_top") {
    difference() { hex2d(hex_R); offset(delta = -0.15) hex2d(hex_R); }
    face_top2d();
}
else if (part == "face_bot") {
    difference() { hex2d(hex_R); offset(delta = -0.15) hex2d(hex_R); }
    face_bot2d(); band2d();
}
else if (part == "preview") {
    color([0.2, 0.2, 0.22]) token();
    color([0.85, 0.85, 0.88]) difference() { cut_top(); translate([0,0,T+eps]) linear_extrude(1) hex2d(hex_R+1); }
}
else if (part == "preview_bot") {   // difference-only so OpenCSG shows it
    color([0.2, 0.2, 0.22]) token();
    color([0.85, 0.85, 0.88]) difference() { cut_bot(); below(); }
    color([0.55, 0.55, 0.58]) difference() { cut_band(); below(); outside_hex(); }
}

module below() { translate([0, 0, -1 - eps]) linear_extrude(1) hex2d(hex_R + 5); }
module outside_hex() {
    translate([0, 0, -1]) linear_extrude(T + 2)
        difference() { square(4 * hex_R, center = true); hex2d(hex_R - chamfer / cos(30)); }
}
