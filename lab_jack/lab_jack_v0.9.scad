// Lab Jack v0.9

use <../lib/gear_spur.scad>
use <../lib/rounded_cube.scad>


EPSILON = 0.05;

D = 12;
Z = 12;
m = D / Z;

SCREW_D = 4;
SCREW_HEAD_D = 7;

ARM_T = 4;
ARM_L = 30;
ARM_W = 8;

JOINT_W = 2 * D / 3;
JOINT_T = 15;

PLATE_T = 1.5;
PLATE_L = 2 * (ARM_L + D + PLATE_T) + 3 * m; // 80, 112
PLATE_W = 60;
PLATE_H = 3 * m + (D - ARM_W) / 2;

LINK_T = 2;

$fs=0.5;
$fa=2.5;


module arm()
{
    difference() {
        union() {
            cube([ARM_L, ARM_W, ARM_T], center=true);
            translate([-ARM_L/2, 0, 0]) {
                external_gear_spur(m, Z, ARM_T);
            }
            translate([ARM_L/2, 0, 0]) {
                rotate([0, 0, 360/Z/2]) {
                    external_gear_spur(m, Z, ARM_T);
                }
            }
        }
        for (x=[-ARM_L/2, ARM_L/2]) {
            translate([x, 0, 0]) {
                cylinder(d=SCREW_D, h=ARM_T+2*EPSILON, center=true);
            }
        }
    }
}


module arms(angle=0)
{
    rotate([90, 0, 0]) {
        translate([-D/2, 0, 0]) rotate([0, 0, -angle]) translate([-ARM_L/2, 0, 0]) arm();
        translate([+D/2, 0, 0]) rotate([0, 0,  angle]) translate([+ARM_L/2, 0, 0]) arm();
    }
}


module side(angle)
{
    translate([0, 0, 0]) arms(angle);
    translate([0, 0, D+2*ARM_L*sin(angle)]) mirror([0, 0, 1])  mirror([1, 0, 0]) arms(angle);
}


module joint(nut=false)
{
    difference() {
        hull() {
            for (z=[-D/2, D/2]) {
                translate([0, 0, z]) {
                    rotate([90, 0, 0]) {
                        difference() {
                            cylinder(d=JOINT_W, h=JOINT_T, center=true);
                        }
                    }
                }
            }
        }
        
        for (z=[-D/2, D/2]) {
            translate([0, 0, z]) {
                rotate([90, 0, 0]) {
                    difference() {
                        cylinder(d=SCREW_D, h=JOINT_T+2*EPSILON, center=true);
                    }
                }
            }
        }
        
        rotate([0, 90, 0]) {
            cylinder(d=5, h=JOINT_W+2*EPSILON, center=true);
        }
        
        if (nut) {
            for (x=[0, 1]) {
                mirror([x, 0, 0]) {
                    translate([JOINT_W/2+EPSILON, 0, 0]) {
                        rotate([0, -90, 0]) {
                            cylinder(d=SCREW_HEAD_D*2/sqrt(3), h=3, center=false, $fn=6);
                        }
                    }
                }
            }
        }
    }
}


module link()
{
    difference() {
        hull() {
            for (z=[-D/2, D/2]) {
                translate([0, 0, z]) {
                    rotate([90, 0, 0]) {
                        difference() {
                            cylinder(d=JOINT_W, h=LINK_T, center=true);
                        }
                    }
                }
            }
        }
        
        for (z=[-D/2, D/2]) {
            translate([0, 0, z]) {
                rotate([90, 0, 0]) {
                    difference() {
                        cylinder(d=SCREW_D, h=LINK_T+2*EPSILON, center=true);
                    }
                }
            }
        }
    }
}


module plate()
{
    translate([0, 0, PLATE_H/2]) {
        difference() {
            rcube([PLATE_L, PLATE_W, PLATE_H], radius=[0, 0, 2], center=true);
            translate([0, 0, PLATE_T/2]) {
                rcube([PLATE_L-2*PLATE_T+2*EPSILON, PLATE_W-2*PLATE_T+2*EPSILON, PLATE_H-PLATE_T+EPSILON], radius=[0, 0, 2], center=true);
            }
            
            // Plate holes
            for (x=[0:15:PLATE_L/2-5]) {
                for (y=[0:15:PLATE_W/2-5]) {
                    translate([x, y, -PLATE_H/2-EPSILON]) {
                        cylinder(d=2.75, h=PLATE_T+2*EPSILON, center=false);
                    }
                }
            }
        }
    }
    
    translate([0, 0, D/2]) {
        difference() {
            for (y=[-PLATE_W/2+PLATE_T+ARM_T+10/2, PLATE_W/2-PLATE_T-ARM_T-10/2]) {
                translate([0, y, 0]) {
                    rcube([2*D, 10, D], radius=[0, 2, 0], center=true);
                }
            }
            
            for (x=[-D/2, D/2]) {
                translate([x, 0, PLATE_H/2]) {
                    rotate([90, 0, 0]) {
                        cylinder(d=SCREW_D, h=PLATE_W+2*EPSILON, center=true);
                    }
                }
            }
        }
    }
}


module all(angle)
{
    translate([0, -PLATE_W/2+ARM_T/2+PLATE_T, 0]) side(angle);
    translate([0, +PLATE_W/2-ARM_T/2-PLATE_T, 0]) side(angle);
    
    translate([-ARM_L*cos(angle)-D/2, 0, ARM_L*sin(angle)+D/2]) color("lightblue") joint(nut=false);
    translate([+ARM_L*cos(angle)+D/2, 0, ARM_L*sin(angle)+D/2]) color("lightblue") joint(nut=true);
    
    translate([-ARM_L*cos(angle)-D/2, -PLATE_W/2+PLATE_T+ARM_T+LINK_T/2, ARM_L*sin(angle)+D/2]) color("orange") link();
    translate([-ARM_L*cos(angle)-D/2, +PLATE_W/2-PLATE_T-ARM_T-LINK_T/2, ARM_L*sin(angle)+D/2]) color("orange") link();
    translate([+ARM_L*cos(angle)+D/2, +PLATE_W/2-PLATE_T-ARM_T-LINK_T/2, ARM_L*sin(angle)+D/2]) color("orange") link();
    translate([+ARM_L*cos(angle)+D/2, -PLATE_W/2+PLATE_T+ARM_T+LINK_T/2, ARM_L*sin(angle)+D/2]) color("orange") link();
    
    translate([0, 0, -D/2-3*m])                                       color("lightgreen") plate();
    translate([0, 0, 2*ARM_L*sin(angle)+D+D/2+3*m]) mirror([0, 0, 1]) color("lightgreen") plate();
}


// Display
//arms(45);
//side(20);
all(30);

// Print
//arm();
//plate();
//joint();
//joint(true);
//link();