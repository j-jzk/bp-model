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
motor_holder_len = 15;
motor_bracket_screw_hole_margin = 2.75;

accessory_hole_spacing = 20;

servo_plate_support_height = 20;
