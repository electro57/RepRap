// TowerPro MG-995/995R/996/996R servo mockup

use <../../rounded_cube.scad>

SERVO_L = 40.5;
SERVO_W = 19.5;
SERVO_H1 = 35.6;
SERVO_H2 = 2.;
SERVO_H3 = 2.1;

CHAMFER_W = 1;
CHAMFER_H = 2.5;

SERVO_BRACKET_L = 6.9;
SERVO_BRACKET_W = SERVO_W;
SERVO_BRACKET_H = 2.5;
SERVO_BRACKET_Z_POS = 27;

$fs=0.5;
$fa=2.5;


module chamfer(w=1, h=1, l=10, center=true)
{
    rotate([90, 0, 0]) {
        linear_extrude(height=l, center=center) {
            polygon(points=[[0, 0], [w, 0], [0, h]]);
        }
    }
}


module MG995_bracket()
{
    difference() {
        union() {
            rcube([SERVO_BRACKET_L, SERVO_W, SERVO_BRACKET_H], [0, 0, 1], center=true);
            rotate([0, 10, 0]) {
                translate([-5.5, 0, 0]) {
                    cube([8, 1, 2]);
                }
            }
        }

        // screw holes
        union() {
            translate([0, -10.5/2, 0]) {
                cylinder(d=4.5, h=SERVO_BRACKET_H+1, center=true);
            }
            translate([0, 10.5/2, 0]) {
                cylinder(d=4.5, h=SERVO_BRACKET_H+1, center=true);
            }
            translate([SERVO_BRACKET_L/2, -10.5/2, 0]) {
                cube([4, 2.5, SERVO_BRACKET_H+1], center=true);
            }
            translate([SERVO_BRACKET_L/2, 10.5/2, 0]) {
                cube([4, 2.5, SERVO_BRACKET_H+1], center=true);
            }
        }
    }
}


module MG995_torque_mount()
{
    difference() {
        union() {
            translate([0, 0, 2.7]) cylinder(h=2, d=20);
            cylinder(h=4.7, d=9);
        }
        translate([0, 0, -1])cylinder(h=8, d=4.5);
        translate([7, 0, 2]) cylinder(h=4, d=3);
        rotate([0, 0, 90]) translate([7, 0, 2]) cylinder(h=4, d=3);
        rotate([0, 0, 180]) translate([7, 0, 2]) cylinder(h=4, d=3);
        rotate([0, 0, 270]) translate([7, 0, 2]) cylinder(h=4, d=3);
    }
}


module MG995_wire_terminal()
{
    translate([0, -7/2, 0]) {
        cube([5, 7, 4]);
    }
    translate([0, -5/2, (4-1)/2]) {
        cube([7, 5, 1]);
    }
}


module MG995()
{
    translate([0, 0, 0]) {
        
        // main part
        translate([20/2, 0, SERVO_H1/2-SERVO_BRACKET_Z_POS]) {
            difference() {
                cube([SERVO_L, SERVO_W, SERVO_H1], center=true);

                // chanfrein
                translate([0, 0, -SERVO_H1/2-0.01])
                scale(1.001)
                intersection() {
                    translate([0, 0, CHAMFER_H/2]) {
                        cube([SERVO_L, SERVO_W, CHAMFER_H], center=true);
                    }
                    union() {
                        translate([-SERVO_L/2, 0, 0]) {
                            chamfer(w=CHAMFER_W, h=CHAMFER_H, l=SERVO_W, center=true);
                        }
                        translate([SERVO_L/2, 0, 0]) {
                            mirror([1, 0, 0]) {
                                chamfer(w=CHAMFER_W, h=CHAMFER_H, l=SERVO_W, center=true);
                            }
                        }
                        translate([0, -SERVO_W/2, 0]) {
                            rotate([0, 0, 90]) {
                                chamfer(w=CHAMFER_W, h=CHAMFER_H, l=SERVO_L, center=true);
                            }
                        }
                        translate([0, SERVO_W/2, 0]) {
                            rotate([0, 0, -90]) {
                                chamfer(w=CHAMFER_W, h=CHAMFER_H, l=SERVO_L, center=true);
                            }
                        }
                    }
                }
            }
        }
        translate([0, 0, SERVO_H1-SERVO_BRACKET_Z_POS]) {
            cylinder(d=19, h=SERVO_H2, center=false);
            translate([-21/2+13, -17/2, 0]) {
                cube([21, 17, SERVO_H2], center=false);
            }
            translate([0, 0, SERVO_H2]) {
                cylinder(d=13, h=2*SERVO_H3/3, center=false);
                translate([0, 0, 2*SERVO_H3/3]) {
                    cylinder(d=11, h=SERVO_H3/3, center=false);
                    translate([0, 0, SERVO_H3/3]) {
                        cylinder(d=5, h=3.9);
                    }
                }
            }
        }
       
        translate([20/2+SERVO_L/2+SERVO_BRACKET_L/2, 0, SERVO_BRACKET_H/2]) {
            MG995_bracket();
        }
        translate([-20/2-SERVO_BRACKET_L/2, 0, SERVO_BRACKET_H/2]) {
            rotate([0, 0, 180]) {
                MG995_bracket();
            }
        }

        *translate([0, 0, 14]) {
            MG995_torque_mount();
        }

        rotate([0, 0, 180]) {
            translate([10, 0, -SERVO_BRACKET_Z_POS+4]) {
                MG995_wire_terminal();
            }
        }
    }
}


color("gray") MG995();
