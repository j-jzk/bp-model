include <params.scad>

module mirror_copy(v = [1,0,0]) {
    children();
    mirror(v) {
        children();
    }
}

module rounded_rect(size, r, center=false) {
    module _shape() {
        hull() {
            translate([r, r]) circle(r);
            translate([size.x - r, r]) circle(r);
            translate([r, size.y - r]) circle(r);
            translate([size.x - r, size.y - r]) circle(r);
        }
    }
    if (!center)
        _shape();
    else 
        translate([-size.x/2, -size.y/2]) _shape();
}

module conic_hole_m3(height) {
    // dimensions according to DIN 7991 + 0.2 mm for tolerance
    cone_d = 6 + 0.2;
    cone_h = 1.7 + 0.2;

    union() {
        // hole
        cylinder(height, d = m3_d);
        // cone
        cylinder(cone_h, d1 = cone_d, d2 = 0);
    }
}

module m3_square_nut_hole() {
    hole_length = 19 - plate_thickness;  // enough for an M3x16 DIN7991 screw
    translate([0,0, -hole_length+e]) cylinder(d=m3_d, h=hole_length+e);
    translate([0,0, -6]) cube([6, 6, 2], center=true);
}