use <utils.scad>
include <params.scad>

/*
 * The origin is on the front wheel axis.
 */

module base_shape_2d() {
    offset(r = corner_r) offset(r = -corner_r) // rounded corners
        mirror_copy()
            polygon([
                [0-e, -36],
                [steering_cutout_width, -36],
                [steering_cutout_width, -wheel_mount_length],

                [front_wheel_pos.x+m3_d+5, 0],

                [steering_cutout_width, wheel_mount_length],
                [steering_cutout_width, 30],
                [0-e, 30],
            ]);
}

module screw_holes() {
    module _hole(pos) {
        translate([pos.x, pos.y, plate_thickness+e])
            rotate([180, 0, 0])
                conic_hole_m3(plate_thickness + 2*e);
    }

    for (pos = servo_plate_holes) {
        _hole(pos);
    }
}

module servo_mount() {
    // origin is the rotor's axis
    // dimensions accoding to https://futaba.uk/products/fut05102732-3

    // servo hole
    translate([-10, -29.9, 0]) // translate the rotor axis to [0,0]
        cube([20, 40, plate_thickness + 2*e]);

    // screw holes
    module _screw_hole() {
        cylinder(d=2.1, h=plate_thickness + 2*e);
    }

    mirror_copy() {
        translate([-5, 14.85]) _screw_hole();
        translate([-5, -34.65]) _screw_hole();
    }
}

module kingpin_holes() {
    screw_d = 4 + 0.1;  // 4 mm + tolerance
    pocket_height = 2;

    module _kingpin_hole() {
        translate([0,0,-e]) cylinder(d=screw_d, h=plate_thickness + 2*e);
        translate([0,0, plate_thickness - pocket_height + e])
            linear_extrude(height = pocket_height)
                m3_nut_hexagon();
    }

    mirror_copy()
        translate([front_wheel_pos.x, 0]) _kingpin_hole();
}

difference() {
    linear_extrude(height = plate_thickness) base_shape_2d();

    screw_holes();
    // y=10.2894 is a value calculated in FreeCAD
    translate([0, 10.2894, 0-e]) servo_mount();
    kingpin_holes();
}