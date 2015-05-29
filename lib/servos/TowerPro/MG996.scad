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

MG996_SHAFT_POS_X = 20.0 / 2;

MG996_SCREWS_X = 36.0;
MG996_SCREWS_Y = 15.0;
MG996_SCREWS_HEAD_D = 3.5;

MG996_LID_BOTTOM_T = 2.0;

$fs=0.5;
$fa=2.5;

    
module MG996_spline(h)
{
    cylinder(d=5.5, h=h);
    for (a=[0:360/25:360]) {
        rotate([0, 0, a]) {
            translate([5.5/2, 0, 0]) {
                cylinder(d=0.65, h=h, $fn=4);
            }
        }
    }
}


module MG996_spline_test()
{
    difference() {
        cylinder(d=12, h=5);
        MG996_spline(h=4);
    }
}


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


module MG996_torque_mount()
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


module MG996_wire_terminal()
{
    translate([0, -7/2, 0]) {
        cube([5, 7, 4]);
    }
    translate([0, -5/2, (4-1)/2]) {
        cube([7, 5, 1]);
    }
}


module MG996()
{
    translate([0, 0, 0]) {
        
        // main part
        translate([20/2, 0, MG996_H1/2-MG996_BRACKET_Z_POS]) {
            difference() {
                cube([MG996_L, MG996_W, MG996_H1], center=true);

                // chanfrein
                translate([0, 0, -MG996_H1/2-0.01])
                scale(1.001)
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
        translate([0, 0, MG996_H1-MG996_BRACKET_Z_POS]) {
            cylinder(d=19, h=MG996_H2, center=false);
            translate([-21/2+13, -17/2, 0]) {
                cube([21, 17, MG996_H2], center=false);
            }
            translate([0, 0, MG996_H2]) {
                cylinder(d=13, h=2*MG996_H3/3, center=false);
                translate([0, 0, 2*MG996_H3/3]) {
                    cylinder(d=11, h=MG996_H3/3, center=false);
                    translate([0, 0, MG996_H3/3]) {
                        cylinder(d=5, h=3.9);
                    }
                }
            }
        }
       
        translate([20/2+MG996_L/2+MG996_BRACKET_L/2, 0, MG996_BRACKET_H/2]) {
            MG996_bracket();
        }
        translate([-20/2-MG996_BRACKET_L/2, 0, MG996_BRACKET_H/2]) {
            rotate([0, 0, 180]) {
                MG996_bracket();
            }
        }

        *translate([0, 0, 14]) {
            MG996_torque_mount();
        }

        rotate([0, 0, 180]) {
            translate([10, 0, -MG996_BRACKET_Z_POS+4]) {
                MG996_wire_terminal();
            }
        }
    }
}


module MG996_lid()
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
            
            // screw bearing screw hole
            translate([-MG996_L/2+MG996_SHAFT_POS_X, 0, -MG996_LID_BOTTOM_T-0.05]) {
                difference() {
                    cylinder(d1=3, d2=6, h=MG996_LID_BOTTOM_T+0.1, center=false);
                }
            }
        }
    }
}

module MG996_lid_vitamins()
{
    translate([0, 0, -MG996_BRACKET_Z_POS-MG996_LID_BOTTOM_T-bearing_w(623)-0.5]) {
        bearing(623);
    }
}


//color("gray") MG996();
//color("lightgray") MG996_lid();
//%MG996_lid_vitamins();
//mirror([0, 0, 1]) MG996_spline_test();
