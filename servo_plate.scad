use <utils.scad>
include <params.scad>

/*
 * The origin is on the front wheel axis.
 */

module base_shape_2d() {
    offset(r = corner_r) offset(r = -corner_r) // rounded corners
        mirror_copy()
            polygon([
                [0-e, -30],
                [steering_cutout_width, -30],
                [steering_cutout_width, -wheel_mount_length],

                [front_wheel_pos.x+m3_d+5, 0],

                [bumper_socket_width, wheel_mount_length],
                [bumper_socket_width, 30],
                [0-e, 30],
            ]);
}

module servo_mount() {
    // origin is the rotor's axis
    // dimensions accoding to https://futaba.uk/products/fut05102732-3

    // servo hole
    translate([-10 - 1.0/2, -29.9 - 1.0/2, 0]) // translate the rotor axis to [0,0]
        cube([20 + 1, 40 + 1, plate_thickness + 2*e]);

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

module supports() {
    // width/thickness of the rectangles; must be enough to accomodate holes for the nuts
    w = 7;

    module _2d() {
        // T-shaped part
        mirror_copy()
            translate([13.5, 15.5])
                polygon([
                    // horizontal part
                    [0, 0], [0, w], [20, w], [20, 0],
                    // vertical part
                    [(25-w)/2, 0], [(25-w)/2, -20], [(25+w)/2, -20], [(25+w)/2, 0],
                ]);

        // horizontal rectangle
        // translate([0, -28 - w/2]) square([50, w], center=true);
    }

    mirror([0,0,1])
        difference() {
            linear_extrude(height = servo_plate_support_height) _2d(); 

            // nut holes
            translate([0, 0, servo_plate_support_height]) {
                for (pos = servo_plate_hole_poss) {
                    translate(pos) m3_square_nut_hole();
                }
            }
        }
}

difference() {
    union() {
        linear_extrude(height = plate_thickness) base_shape_2d();
        supports();
    }

    // y=10.2894 is a value calculated in FreeCAD
    translate([0, 10.2894, 0-e]) servo_mount();
    kingpin_holes();
}