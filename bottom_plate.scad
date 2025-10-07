use <utils.scad>
include <params.scad>

/*
 * The origin of the vehicle is in the middle of the back wheel axis and the
 * front of the vehicle is in the +Y direction from it.
 */

module base_plate_2d() {
    module _right_half() {
        // from the bottom up
        polygon([
            [0-e, -back_plate_length/2],
            [back_wheel_pos.x, -back_plate_length/2],
            [back_wheel_pos.x, back_plate_length/2],

            // middle plate for the accessories
            [middle_plate_width, back_plate_length/2 + 10],
            [middle_plate_width, front_wheel_pos.y-30-15-15],

            // cut-out for the front wheels to steer
            [steering_cutout_width, front_wheel_pos.y-30-15],
            [steering_cutout_width, front_wheel_pos.y-30],
            // front wheel mounting point
            [front_wheel_pos.x+m3_d+5, front_wheel_pos.y],

            [bumper_socket_width, front_wheel_pos.y+30],
            [bumper_socket_width, front_wheel_pos.y+30 + bumper_socket_length],
            [0-e, front_wheel_pos.y+30 + bumper_socket_length],
        ]);
    }

    // rounded corners
    offset(r = corner_r) offset(r = -corner_r) {
        mirror_copy() _right_half();
    }
}

module _hole(pos) {
    translate([pos.x, pos.y, 0-e]) conic_hole_m3(plate_thickness + 2*e);
}

module accessory_holes() {
    module _grid() {
        hole_count = [
            ceil(middle_plate_width * 2 / accessory_hole_spacing),
            ceil(front_wheel_pos.y / accessory_hole_spacing)
        ];
        min_x = floor(-middle_plate_width / accessory_hole_spacing) * accessory_hole_spacing - accessory_hole_spacing/2;
        // position min_y such that the middle of the y axis is in between two rows of holes
        min_y = (front_wheel_pos.y / 2) % accessory_hole_spacing - accessory_hole_spacing/2;

        for (
            x = [min_x : accessory_hole_spacing : middle_plate_width],
            y = [min_y : accessory_hole_spacing : front_wheel_pos.y]
        ) {
            _hole([x, y]);
        }
    }

    intersection() {
        _grid();
        // the polygon where we want the holes
        translate([0,0,-e]) mirror_copy() linear_extrude(plate_thickness + 2*e)
            polygon([
                // from the bottom right
                [0-e, back_plate_length/2 - 10],
                [back_wheel_pos.x - 10, back_plate_length/2 - 10],
                [back_wheel_pos.x - 10, back_plate_length/2 + 10],

                [middle_plate_width - 10, back_plate_length/2 + 10],
                [middle_plate_width - 10, front_wheel_pos.y-30-15-15],

                [steering_cutout_width, front_wheel_pos.y-70],
                [steering_cutout_width, front_wheel_pos.y-30-15],
                [0-e, front_wheel_pos.y-30-15]
                // [0-e, front_wheel_pos.y-30],
            ]);
    }
}

module kingpin_holes() {
    pocket_height = 2;
    screw_head_d = 7;
    screw_d = 4 + 0.1;  // diameter 4 mm + tolerance

    module _kingpin_hole() {
        cylinder(h = plate_thickness + e, d = screw_d);
        translate([0, 0, 0-e]) cylinder(h = pocket_height+e, d = screw_head_d + 0.2);
    }

    mirror_copy()
        translate([front_wheel_pos.x, front_wheel_pos.y, 0])
            _kingpin_hole();
}

module motor_holder() {
    // the side should be cca 0.8-1.2 mm wide for printing
    translate([-motor_len, 0, 0])
        difference() {
            translate([0, -(motor_d-1)/2, 0]) cube([motor_len, motor_d-1, motor_d*0.25]);
            translate([0-e, 0, motor_d/2]) rotate([0, 90, 0]) cylinder(r = motor_d/2, h=motor_len+2*e);
        }
}
module motor_holder_holes() {
    // screw holes for the bracket
    mirror_copy([0,1,0])
        _hole([
            -motor_bracket_len/2,
            motor_d/2 + motor_bracket_screw_hole_margin,
        ]);

    // girder for the cable tie
    // variant 1: the hole peeks through the bottom
    // translate([-motor_len + 10, 0, motor_d/2 ])
    //     rotate(90, [0,1,0])
    //         difference() {
    //             cylinder(h = motor_cable_tie_width, r = motor_d/2 + motor_cable_tie_thickness, center=true);
    //             cylinder(h = motor_cable_tie_width, r = motor_d/2, center=true);
    //         }
    
    // variant 2: the hole is fully hidden, larger D
    translate([-motor_len + 10, 0, motor_d/2 + 13])
        rotate(90, [0,1,0])
            difference() {
                cylinder(h = motor_cable_tie_width, r = motor_d/2 + 10 + motor_cable_tie_thickness, center=true);
                cylinder(h = motor_cable_tie_width, r = motor_d/2 + 10, center=true);
            }
}

module servo_plate_support() {
    // assume the origin is on the front wheel axis

    // width/thickness of the rectangles; must be enough to accomodate holes for the nuts
    w = 7;

    module _2d() {
        // T-shaped part
        mirror_copy()
            translate([13.5, 15.5])
                polygon([
                    // horizontal part
                    [0, 0], [0, w], [25, w], [25, 0],
                    // vertical part
                    [(25-w)/2, 0], [(25-w)/2, -20], [(25+w)/2, -20], [(25+w)/2, 0],
                ]);

        // horizontal rectangle
        translate([0, -28 - w/2]) square([50, w], center=true);
    }

    difference() {
        linear_extrude(height = servo_plate_support_height) _2d(); 

        // nut holes
        translate([0, 0, servo_plate_support_height]) {
            for (pos = servo_plate_holes) {
                translate(pos) m3_square_nut_hole();
            }
        }
    }
}

module bumper_holes() {
    translate([0, front_wheel_pos.y+30 + bumper_socket_length - bumper_hole_margin, 0])
        union() {
            _hole([-bumper_hole_x, 0]);
            _hole([0, 0]);
            _hole([bumper_hole_x, 0]);
        }
}

difference() {
    union() {
        // base plate
        linear_extrude(height = plate_thickness) base_plate_2d();
        // motor holders
        mirror_copy()
            translate([back_wheel_pos.x, back_wheel_pos.y, plate_thickness])
                motor_holder();

        translate([0, front_wheel_pos.y, plate_thickness]) servo_plate_support();
    }

    // holes
    mirror_copy()
        translate(back_wheel_pos) motor_holder_holes();
    kingpin_holes();
    accessory_holes();
    bumper_holes();
}
