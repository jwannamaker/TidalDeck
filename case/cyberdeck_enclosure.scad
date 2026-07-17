// ============================================================
//  CYBERDECK ENCLOSURE — Parametric OpenSCAD
//  Footprint inspired by Xbox Elite S2 (170×115mm) &
//  TI Voyage 200 (208×119mm) — split the difference at
//  ~190×120mm, ~30mm deep body.
//
//  COMPONENTS (measured / sourced):
//    Keyboard  : Rii 518BT          109×58×10mm
//    OLED      : Waveshare 2.42"    61.5×39.5mm PCB, 5mm thick
//    SHARP LCD : Adafruit 4694      ~75×55mm PCB (estimated from
//                                   58.8×35.3mm viewable + PCB margin)
//    Scroll wheels: Radiomaster TX16S roller assembly ~18mm dia,
//                   15mm wide — two on back panel
//
//  PRINT NOTES:
//    • Two-part split at mid-height: bottom shell + lid
//    • Print with 3+ perimeters, 20–30% infill
//    • Chamfer replaces fillets (easier to print without support)
//    • All cutouts have 0.3mm tolerance baked in
//    • Lid mounts with M3 screws at four corners
// ============================================================

// ─── GLOBAL QUALITY ──────────────────────────────────────────
$fn = 60;  // increase to 120 before final render (slower)

// ─── MAIN BODY PARAMETERS ────────────────────────────────────
body_w    = 190;   // overall width  (X)  — adjust freely
body_d    = 120;   // overall depth  (Y)
body_h    = 30;    // overall height (Z)
wall      = 3.0;   // shell wall thickness
chamfer   = 2.5;   // edge chamfer size — increase for chunkier look
tol       = 0.3;   // clearance tolerance on all cutouts
split_z   = 14;    // Z height of lid split line (from bottom)

// ─── LID / SHELL SPLIT ───────────────────────────────────────
lid_h     = body_h - split_z;   // lid height
shell_h   = split_z;            // bottom shell height

// ─── SCREW POST PARAMETERS ───────────────────────────────────
post_r    = 4;      // outer radius of corner posts
post_hole = 1.6;    // M3 tap drill radius (M3 = 2.5mm drill → 1.25r; 1.6 gives snug fit)
post_inset = 6;     // distance from corner to post centre

// ─── COMPONENT CUTOUT PARAMETERS ─────────────────────────────
// — Rii 518BT keyboard (109×58mm body, 10mm thick)
kb_w      = 109 + tol*2;
kb_d      = 58  + tol*2;
kb_h      = 10  + tol;          // pocket depth in lid
kb_x      = (body_w - kb_w)/2; // centred left-right
kb_y      = body_d - wall - kb_d - 4; // near rear of lid face

// — Waveshare 2.42" OLED (PCB 61.5×39.5mm, display area 55×27.5mm)
oled_pcb_w = 61.5 + tol*2;
oled_pcb_d = 39.5 + tol*2;
oled_win_w = 55.0 + tol;       // viewable window cutout
oled_win_d = 27.5 + tol;
oled_x     = wall + 6;         // left side of lid
oled_y     = wall + 6;

// — Adafruit 4694 SHARP 2.7" display
//   PCB ~75×55mm estimated (viewable 58.8×35.3mm + ~8mm PCB border each side)
sharp_pcb_w = 75 + tol*2;
sharp_pcb_d = 55 + tol*2;
sharp_win_w = 58.8 + tol;
sharp_win_d = 35.3 + tol;
sharp_x     = body_w - wall - 6 - sharp_pcb_w; // right side of lid
sharp_y     = wall + 6;

// — Radiomaster TX16S scroll wheels (18mm dia, 15mm wide, on back panel)
wheel_r     = 9 + tol;   // radius of wheel cutout
wheel_w     = 15 + tol;  // slot width (axle slot)
wheel_1_x   = body_w/2 - 22;  // left wheel centre X
wheel_2_x   = body_w/2 + 22;  // right wheel centre X
wheel_y     = body_h/2;        // centred on rear wall height

// ─── HELPER: chamfered box ────────────────────────────────────
// A box with all 12 edges chamfered by `c`.
// Works by intersecting 3 scaled cubes at each axis.
module chamfer_box(w, d, h, c) {
    intersection() {
        cube([w, d, h]);
        translate([c, 0, c])
            cube([w - 2*c, d, h - 2*c]);
        translate([0, c, c])
            cube([w, d - 2*c, h - 2*c]);
        translate([c, c, 0])
            cube([w - 2*c, d - 2*c, h]);
    }
}

// ─── HELPER: screw post ───────────────────────────────────────
module screw_post(h) {
    difference() {
        cylinder(r = post_r, h = h);
        cylinder(r = post_hole, h = h + 1);
    }
}

// ─── HELPER: display pocket + window cutout ───────────────────
// pocket_d  = depth of recess from lid top surface
// win_*     = inner window through-hole size
// pcb_*     = pcb recess size
module display_pocket(pcb_w, pcb_d, pocket_depth, win_w, win_d) {
    // PCB recess (2mm deep)
    cube([pcb_w, pcb_d, 2]);
    // Window cutout through remaining lid wall
    translate([(pcb_w - win_w)/2, (pcb_d - win_d)/2, -lid_h])
        cube([win_w, win_d, lid_h + 3]);
}

// ─── BOTTOM SHELL ────────────────────────────────────────────
module bottom_shell() {
    difference() {
        // Outer chamfered shell
        chamfer_box(body_w, body_d, shell_h, chamfer);

        // Hollow interior
        translate([wall, wall, wall])
            cube([body_w - wall*2, body_d - wall*2, shell_h]);

        // Back wall wheel slots — two scroll wheel cutouts
        // Slot = vertical oval: wheel_r radius, centred on rear face
        for (wx = [wheel_1_x, wheel_2_x]) {
            translate([wx - wheel_r, body_d - wall - 0.1, wall])
                cube([wheel_r*2, wall + 0.2, wheel_r*2 + wall]);
            // Round the top of the slot
            translate([wx, body_d - wall - 0.1, wall + wheel_r*2])
                rotate([-90, 0, 0])
                    cylinder(r = wheel_r, h = wall + 0.2);
        }

        // USB-C / port cutout on front face — placeholder 14×6mm slot
        // Move/resize to match your actual port
        translate([(body_w - 14)/2, -0.1, wall + 4])
            cube([14, wall + 0.2, 6]);

        // Alignment lip recess on top rim — 1×1mm rebate for lid to seat into
        translate([wall + 1, wall + 1, shell_h - 1])
            cube([body_w - wall*2 - 2, body_d - wall*2 - 2, 1.5]);
    }

    // Corner screw posts inside shell
    for (x = [post_inset, body_w - post_inset],
         y = [post_inset, body_d - post_inset]) {
        translate([x, y, wall])
            screw_post(shell_h - wall - 0.5);
    }
}

// ─── LID ─────────────────────────────────────────────────────
module lid() {
    difference() {
        // Outer chamfered lid
        chamfer_box(body_w, body_d, lid_h, chamfer);

        // Hollow underside (leave top surface solid for cutouts)
        translate([wall, wall, -0.1])
            cube([body_w - wall*2, body_d - wall*2, lid_h - wall + 0.1]);

        // Alignment lip that drops into shell rim
        translate([wall + 1, wall + 1, -0.1])
            cube([body_w - wall*2 - 2, body_d - wall*2 - 2, 1.5]);

        // ── Keyboard pocket ─────────────────────────────────
        translate([kb_x, kb_y, lid_h - kb_h])
            cube([kb_w, kb_d, kb_h + 1]);

        // ── OLED display pocket + window ─────────────────────
        translate([oled_x, oled_y, lid_h - 2])
            display_pocket(oled_pcb_w, oled_pcb_d, 2, oled_win_w, oled_win_d);

        // ── SHARP display pocket + window ────────────────────
        translate([sharp_x, sharp_y, lid_h - 2])
            display_pocket(sharp_pcb_w, sharp_pcb_d, 2, sharp_win_w, sharp_win_d);

        // ── Corner screw holes through lid ───────────────────
        for (x = [post_inset, body_w - post_inset],
             y = [post_inset, body_d - post_inset]) {
            translate([x, y, -0.1])
                cylinder(r = 1.8, h = lid_h + 0.2); // M3 clearance
        }
    }
}

// ─── RENDER ──────────────────────────────────────────────────
// Comment/uncomment to render each part separately for printing.
// For assembly preview, render both together offset by body_h + 5.

// ── Bottom shell (print as-is, open side up)
color("#2A2A37")
    bottom_shell();

// ── Lid (shown exploded above for preview; flip upside-down to print)
color("#363646")
    translate([0, 0, body_h + 8])
        lid();


// ─── NOTES FOR PRINTING ──────────────────────────────────────
// 1. To export STL for bottom: comment out lid(), File → Export → Export as STL
// 2. To export STL for lid:    comment out bottom_shell(), do the same
// 3. Print lid UPSIDE DOWN (display face down) — no supports needed
// 4. Slicer settings: 0.2mm layer, 3 walls, 25% infill (gyroid or grid)
// 5. Chamfer edges are self-supporting at all angles
// 6. Scroll wheel cutouts may need light cleanup with a file
// 7. Verify your actual PCB sizes with calipers and adjust variables
//    at top of file — everything propagates automatically
