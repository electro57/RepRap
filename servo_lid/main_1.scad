use <../lib/rounded_cube.scad>
use <../lib/bearings.scad>

SERVO_L = 41.0;
SERVO_W = 19.5;

CHAMFER_W = 1;
CHAMFER_H = 2.5;

BOTTOM_T = 2.0;

SCREWS_X = 36.0;
SCREWS_Y = 15.0;
SCREWS_HEAD_D = 3.5;

SHAFT_POS_X = 19.0 / 2;

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


module lid()
{
    difference() {
        union() {
            
            // bottom
            translate([0, 0, -BOTTOM_T/2]) {
                rcube([SERVO_L, SERVO_W, BOTTOM_T], [0, 0, 1], center=true);
            }

            // chanfrein
            intersection() {
                translate([0, 0, CHAMFER_H/2]) {
                    rcube([SERVO_L, SERVO_W, CHAMFER_H], [0, 0, 1], center=true);
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
        
        // screws holes
        for (x=[-SCREWS_X/2, SCREWS_X/2]) {
            for (y=[-SCREWS_Y/2, SCREWS_Y/2]) {
                translate([x, y, -BOTTOM_T-0.05]) {
                    cylinder(d=SCREWS_HEAD_D, h=BOTTOM_T+CHAMFER_H+0.1, center=false);
                }
            }
        }
        
        // screw bearing hole
        translate([SERVO_L/2-SHAFT_POS_X, 0, -BOTTOM_T-0.05]) {
            difference() {
                *cylinder(d1=3, d2=6, h=BOTTOM_T+0.1, center=false);
            }
        }
        
        // internal rivet hole
        translate([SERVO_L/2-SHAFT_POS_X, 0, -BOTTOM_T-0.05]) {
            difference() {
//                cylinder(d=6, h=BOTTOM_T+0.1, center=false);
                cylinder(d=5, h=BOTTOM_T+0.1, center=false);
            }
            translate([0, 0, BOTTOM_T-1]) {
//                cylinder(d=9.5, h=1+0.1, center=false);
                cylinder(d=7.5, h=1+0.1, center=false);
            }
        }
    }
}


module vitamins()
{
    translate([SERVO_L/2-SHAFT_POS_X, 0, 0]) {
        mirror([0, 0, 1]) 
            difference() {
                union() {
//                    cylinder(d=9, h=1, center=false);
//                    cylinder(d=6, h=11, center=false);
                    cylinder(d=7, h=1, center=false);
                    cylinder(d=4.8, h=9, center=false);
                }
//                cylinder(d=5, h=4, center=false);
//                cylinder(d=4, h=11, center=false);
                cylinder(d=4, h=3, center=false);
                cylinder(d=3, h=7, center=false);
            }
        }
    }
}


lid();
%vitamins();
