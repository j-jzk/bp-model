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

            // middle plate for the battery
            [middle_plate_width, back_plate_length/2 + 10],
            [middle_plate_width, front_wheel_pos.y-30-15-15],

            // cut-out for the front wheels to steer
            [steering_cutout_width, front_wheel_pos.y-30-15],
            [steering_cutout_width, front_wheel_pos.y-30],
            // front wheel mounting point
            [front_wheel_pos.x+m3_d+5, front_wheel_pos.y],

            [steering_cutout_width, front_wheel_pos.y+30],
            [0-e, front_wheel_pos.y+30],
        ]);
    }

    // rounded corners
    offset(r = corner_r) offset(r = -corner_r) {
        mirror_copy() _right_half();
    }
}

module holes_2d() {
    module _hole(pos, d = m3_d) {
        translate([pos.x, pos.y, 0]) circle(d=m3_d);
    }

    mirror_copy() {
        // screw holes
        _hole([36, -28.35]);
        _hole([63.75, 87.88]);
        _hole([40, 177.36]);
        // hole for the front wheel steering mechanism
        _hole(front_wheel_pos);
    }
    // screw hole
    _hole([0, 144.37]);

    // holes for tying the battery to the plate
    module _bat_hole(pos) {
        translate(pos) rounded_rect([14, 5], r=1.5, center=true);
    }
    middle_plate_center_y = (back_plate_length/2 + 10)/2 + (front_wheel_pos.y-30-15-15)/2;
    mirror_copy() {
        _bat_hole([35, middle_plate_center_y - battery_width/2 - 2]);
        _bat_hole([35, middle_plate_center_y + battery_width/2 + 2]);
    }
}

module motor_holder() {
    // TODO: we want the underframe to be lower, so we need to raise the motor holder
    // but when we do it, we must also raise the front wheels
    module _holder() {
        difference() {
            translate([0, -motor_d/2, 0]) cube([motor_holder_len, motor_d, motor_d*0.4]);
            translate([0-e, 0, motor_d/2]) rotate([0, 90, 0]) cylinder(r = motor_d/2, h=motor_holder_len+2*e);
        }
    }

    translate([-motor_holder_len, 0, 0]) _holder();
    translate([-motor_len, 0, 0]) _holder();
}
module motor_holder_holes_2d() {
    mirror_copy([0,1,0])
        translate([
            -motor_holder_len/2,
            motor_d/2 + motor_bracket_thickness + motor_holder_screw_hole_margin + m3_d/2,
        ])
        circle(d=m3_d);
}

// the plate with holes
linear_extrude(height = plate_thickness)
    difference() {
        base_plate_2d();
        holes_2d();
        mirror_copy() translate(back_wheel_pos) motor_holder_holes_2d();
    }

// motor holders
mirror_copy()
    translate([back_wheel_pos.x, back_wheel_pos.y, plate_thickness])
        motor_holder();
