include <params.scad>
use <utils.scad>
use <MCAD/boxes.scad>

thickness = motor_bracket_thickness;
screw_hole_margin = motor_holder_screw_hole_margin;

// a cube with a cylinder on top
module _base_solid_shape() {
    translate([0, 0, motor_d/2]) rotate([0, 90, 0]) cylinder(d = motor_d, h = motor_holder_len);
    translate([0, -motor_d/2, 0]) cube([motor_holder_len, motor_d, motor_d/2]);
}

// obtain a shell by subtracting two scaled copies of _base_solid_shape
// (TODO: would using cylinder_tube from MCAD/regular_shapes be simpler?)
difference() {
    union() {
        resize([motor_holder_len, motor_d+thickness*2, motor_d+thickness]) _base_solid_shape();

        // feet
        translate([motor_holder_len/2, 0, thickness/2])
            roundedBox(
                [motor_holder_len, motor_d + 2*(thickness + m3_d + 2*screw_hole_margin), thickness],
                radius = corner_r,
                sidesonly = true
            );
    }

    _base_solid_shape();
    // screw holes
    mirror_copy([0,1,0])
        translate([
            motor_holder_len/2,
            motor_d/2 + thickness + screw_hole_margin + m3_d/2,
            0-e
        ])
            cylinder(d=m3_d, h=thickness+2*e);
}