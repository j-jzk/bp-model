#!/bin/sh
openscad -o servo_plate.png --autocenter --imgsize 4800,3000 --projection ortho --render x servo_plate.scad
openscad -o bottom_plate.png --autocenter --imgsize 4800,3000 --projection ortho --render x bottom_plate.scad
