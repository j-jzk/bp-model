e = 0.01;  // epsilon
m3_d = 3.2;  // hole diameter for an M3 screw
corner_r = 3; // corner radius

plate_thickness = 4;
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
battery_width = 32;

motor_d = 25;
motor_len = 47.8;
motor_holder_len = 15;
motor_holder_screw_hole_margin = (motor_holder_len - m3_d) / 2;
motor_bracket_thickness = 2.5;
