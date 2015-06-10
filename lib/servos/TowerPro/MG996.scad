// TowerPro MG996/996R servo mockup

use <../../rounded_cube.scad>
use <../../bearing.scad>

MG996_L = 40.5;
MG996_W = 19.5;
MG996_H1 = 35.6;
MG996_H2 = 2.;
MG996_H3 = 2.1;

MG996_BRACKET_L = 6.9;
MG996_BRACKET_W = MG996_W;
MG996_BRACKET_H = 2.5;
MG996_BRACKET_Z_POS = 27;

MG996_CHAMFER_W = 1;
MG996_CHAMFER_H = 2.5;

MG996_SHAFT_POS_X = 10.75;

MG996_SCREWS_X = 36.0;
MG996_SCREWS_Y = 15.0;
MG996_SCREWS_HEAD_D = 3.5;

MG996_LID_BOTTOM_T = 2.0;

$fs=0.5;
$fa=2.5;


module MG996_chamfer(w=1, h=1, l=10, center=true)
{
    rotate([90, 0, 0]) {
        linear_extrude(height=l, center=center) {
            polygon(points=[[0, 0], [w, 0], [0, h]]);
        }
    }
}


module MG996_bracket()
{
    difference() {
        union() {
            rcube([MG996_BRACKET_L, MG996_W, MG996_BRACKET_H], [0, 0, 1], center=true);
            rotate([0, 10, 0]) {
                translate([-5.5, 0, 0]) {
                    cube([8, 1, 2]);
                }
            }
        }

        // screw holes
        union() {
            translate([0, -10.5/2, 0]) {
                cylinder(d=4.5, h=MG996_BRACKET_H+1, center=true);
            }
            translate([0, 10.5/2, 0]) {
                cylinder(d=4.5, h=MG996_BRACKET_H+1, center=true);
            }
            translate([MG996_BRACKET_L/2, -10.5/2, 0]) {
                cube([4, 2.5, MG996_BRACKET_H+1], center=true);
            }
            translate([MG996_BRACKET_L/2, 10.5/2, 0]) {
                cube([4, 2.5, MG996_BRACKET_H+1], center=true);
            }
        }
    }
}


module MG996()
{
    difference() {
        translate([-MG996_SHAFT_POS_X, -MG996_W/2, -MG996_BRACKET_Z_POS]) {
            rcube([MG996_L, MG996_W, MG996_H1], [0, 0, 1], center=false);
        }

        // Bottom chamfers
        translate([MG996_L/2-MG996_SHAFT_POS_X, 0, -MG996_BRACKET_Z_POS-0.01]) {
            scale(1.001) {
                intersection() {
                    translate([0, 0, MG996_CHAMFER_H/2]) {
                        cube([MG996_L, MG996_W, MG996_CHAMFER_H], center=true);
                    }
                    union() {
                        translate([-MG996_L/2, 0, 0]) {
                            MG996_chamfer(w=MG996_CHAMFER_W, h=MG996_CHAMFER_H, l=MG996_W, center=true);
                        }
                        translate([MG996_L/2, 0, 0]) {
                            mirror([1, 0, 0]) {
                                MG996_chamfer(w=MG996_CHAMFER_W, h=MG996_CHAMFER_H, l=MG996_W, center=true);
                            }
                        }
                        translate([0, -MG996_W/2, 0]) {
                            rotate([0, 0, 90]) {
                                MG996_chamfer(w=MG996_CHAMFER_W, h=MG996_CHAMFER_H, l=MG996_L, center=true);
                            }
                        }
                        translate([0, MG996_W/2, 0]) {
                            rotate([0, 0, -90]) {
                                MG996_chamfer(w=MG996_CHAMFER_W, h=MG996_CHAMFER_H, l=MG996_L, center=true);
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Top stuffs
    translate([0, 0, MG996_H1-MG996_BRACKET_Z_POS]) {
        cylinder(d=19, h=MG996_H2, center=false);
        translate([-21/2+13, -17/2, 0]) {
            cube([21, 17, MG996_H2], center=false);
        }
        translate([0, 0, MG996_H2]) {
            cylinder(d=13, h=2*MG996_H3/3, center=false);
            translate([0, 0, 2*MG996_H3/3]) {
                cylinder(d=11, h=MG996_H3/3, center=false);
                
                // Output shaft
                translate([0, 0, MG996_H3/3]) {
                    cylinder(d=6, h=3.5);
                }
            }
        }
    }

    // Brackets
    translate([MG996_L-MG996_SHAFT_POS_X+MG996_BRACKET_L/2, 0, MG996_BRACKET_H/2]) {
        MG996_bracket();
    }
    translate([-MG996_SHAFT_POS_X-MG996_BRACKET_L/2, 0, MG996_BRACKET_H/2]) {
        rotate([0, 0, 180]) {
            MG996_bracket();
        }
    }

    // Wire terminal
    rotate([0, 0, 180]) {
        translate([10, 0, -MG996_BRACKET_Z_POS+3]) {
            translate([0, -7/2, 0]) {
                cube([5, 7, 4]);
            }
            translate([0, -5/2, (4-1)/2]) {
                cube([7, 5, 1]);
            }
        }
    }
}


module MG996_shaft_footprint()
{
    translate([MG996_SHAFT_POS_X, 0, -MG996_BRACKET_Z_POS]) {
        difference() {
            union() {
                
                // bottom
                translate([0, 0, -MG996_LID_BOTTOM_T/2]) {
                    rcube([MG996_L, MG996_W, MG996_LID_BOTTOM_T], [0, 0, 1], center=true);
                }

                // MG996_CHAMFER
                intersection() {
                    translate([0, 0, MG996_CHAMFER_H/2]) {
                        rcube([MG996_L, MG996_W, MG996_CHAMFER_H], [0, 0, 1], center=true);
                    }
                    union() {
                        translate([-MG996_L/2, 0, 0]) {
                            MG996_chamfer(w=MG996_CHAMFER_W, h=MG996_CHAMFER_H, l=MG996_W, center=true);
                        }
                        translate([MG996_L/2, 0, 0]) {
                            mirror([1, 0, 0]) {
                                MG996_chamfer(w=MG996_CHAMFER_W, h=MG996_CHAMFER_H, l=MG996_W, center=true);
                            }
                        }
                        translate([0, -MG996_W/2, 0]) {
                            rotate([0, 0, 90]) {
                                MG996_chamfer(w=MG996_CHAMFER_W, h=MG996_CHAMFER_H, l=MG996_L, center=true);
                            }
                        }
                        translate([0, MG996_W/2, 0]) {
                            rotate([0, 0, -90]) {
                                MG996_chamfer(w=MG996_CHAMFER_W, h=MG996_CHAMFER_H, l=MG996_L, center=true);
                            }
                        }
                    }
                }
            }
            
            // MG996_SCREWS holes
            for (x=[-MG996_SCREWS_X/2, MG996_SCREWS_X/2]) {
                for (y=[-MG996_SCREWS_Y/2, MG996_SCREWS_Y/2]) {
                    translate([x, y, -MG996_LID_BOTTOM_T-0.05]) {
                        cylinder(d=MG996_SCREWS_HEAD_D, h=MG996_LID_BOTTOM_T+MG996_CHAMFER_H+0.1, center=false);
                    }
                }
            }
            
            // shaft footprint hole
            translate([-MG996_L/2+MG996_SHAFT_POS_X, 0, -MG996_LID_BOTTOM_T-0.05]) {
                cylinder(d=2, h=MG996_LID_BOTTOM_T+0.1, center=false);
            }
        }
    }
}


module MG996_bearing()
{
    translate([0, 0, -MG996_BRACKET_Z_POS-bearing_w(623)-0.75]) {
        bearing(623);
    }
}


//color("gray") MG996();
//%MG996_bearing();
//MG996_shaft_footprint();
