e = 0.01;  // epsilon
m3_d = 3.2;  // hole diameter for an M3 screw
corner_r = 3; // corner radius

plate_thickness = 5;
// positions of the wheel/motor mountings (not the wheels themselves)
back_wheel_pos = [53, 0];
front_wheel_pos = [53, 180];

// Widths on the plate are measured from the main axis => they are halved!

// the back plate on which the motors and back wheels are mounted;
// needs to be long enough for the wheels to fit
back_plate_length = 36*2;
// the plate on which the battery is mounted
middle_plate_width = 75;
// width of the cutout behind and in front of the front wheels for them to
// steer freely
steering_cutout_width = 35;

motor_d = 25;
motor_len = 47.8;
motor_bracket_len = 15;
motor_bracket_screw_hole_margin = 2.75;
motor_cable_tie_thickness = 1 + 0.5; // with tolerance
motor_cable_tie_width = 3.5 + 0.5; // with tolerance

accessory_hole_spacing = 20;

servo_plate_support_height = 20;
// hole positions for attaching the servo plate to the bottom plate;
// when edited, you should probably adjust the hard-coded parameters of the supports in bottom_plate.scad
servo_plate_holes = [
    // T-shaped support, left side
    [-13.5 - 25 + 6, 15.5 + 3 - e],
    [-13.5 - (25-7)/2 - 3 + e, 0],
    // T-shaped support, right side
    [13.5 + 25 - 6, 15.5 + 3 - e],
    [13.5 + (25-7)/2 + 3 - e, 0],
    // horizontal support
    [0, -28-3+e]
];
