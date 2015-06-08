include <../lib/servos/TowerPro/MG996.scad>
use <../lib/bearing.scad>

EPSILON = 0.01;

FILE = "main_long.dxf";

COXA_L = 34;

FEMUR_SIDES_DIST = 38.75;

TIBIA_ORIGIN_X = -20.6;
TIBIA_ORIGIN_Z = 64.6;

ANGLE_1 = 20;
ANGLE_2 = -25;

$fs=0.5;
$fa=2.5;


module coxa_side_1()
{
    translate([0, 0, MG996_L-MG996_SHAFT_POS_X+0.5]) {
        difference() {
            translate([0, 0, MG996_BRACKET_L/2]) {
                cylinder(d=21, h=MG996_BRACKET_L, center=true);
                translate([-(COXA_L+MG996_W/2)/2, 0, 0]) {
                    cube([COXA_L+MG996_W/2, 21, MG996_BRACKET_L], center=true);
                }
            }
            
            translate([-COXA_L-MG996_W/2, 21/2-1.5, 0]) {
                cube([MG996_W, 2, MG996_BRACKET_L], center=false);
            }

            cylinder(d=8.25, h=MG996_BRACKET_L);
            *cylinder(d=13.5, h=1.5);
            translate([0, 0, MG996_BRACKET_L-3.4]) {
                cylinder(d=21.5, h=3.4+EPSILON, center=false);
                translate([0, 0, -0.5]) {
                    cylinder(d1=8.25, d2=9.5, h=0.5, center=false);
                }
            }
            
            translate([-COXA_L-10.5/2, 21/2-2, MG996_BRACKET_L/2]) {
                rotate([90, 0, 0]) {
                    cylinder(d=2, h=21/2+2, center=true);
                }
            }
            translate([-COXA_L+10.5/2, 21/2-2, MG996_BRACKET_L/2]) {
                rotate([90, 0, 0]) {
                    cylinder(d=2, h=21/2+2, center=true);
                }
            }
        }
    }
}


module coxa_side_2()
{
    translate([0, 0, -MG996_SHAFT_POS_X-MG996_BRACKET_L/2+0.5]) {
        difference() {
            union() {
                cylinder(d=21, h=MG996_BRACKET_L, center=true);
                translate([-(COXA_L+MG996_W/2)/2, 0, 0]) {
                    cube([COXA_L+MG996_W/2, 21, MG996_BRACKET_L], center=true);
                }
            }
            
            translate([-COXA_L-MG996_W/2, 21/2-1.5, -MG996_BRACKET_L/2]) {
                cube([MG996_W, 2, MG996_BRACKET_L], center=false);
            }
            
            translate([0, 0, -MG996_BRACKET_L/2]) {
                cylinder(d=7.5, h=MG996_BRACKET_L);
                translate([0, 0, MG996_BRACKET_L-4]) {
                    cylinder(d=10.5, h=4+EPSILON);
                }
            }
            
            translate([-COXA_L-10.5/2, 0, 0]) {
                rotate([-90, 0, 0]) {
                    cylinder(d=2, h=21/2, center=false);
                }
            }
            translate([-COXA_L+10.5/2, 0, 0]) {
                rotate([-90, 0, 0]) {
                    cylinder(d=2, h=21/2, center=false);
                }
            }
        }
    }
}


module coxa()
{
    coxa_side_1();
    coxa_side_2();
}


module coxa_vitamins()
{
    translate([0, 0, 17.5]) {
        MG996();
        translate([0, 0, -MG996_BRACKET_Z_POS-bearing_w(623)-0.75]) {
            bearing(623);
        }
    }
}


module femur_side_1()
{
    difference() {
        linear_extrude(height=5, convexity=3) {
            import(file=FILE, layer="0");
        }
        translate([0, 0, 0]) {
            cylinder(d=8.25, h=5);
            cylinder(d=13.5, h=1.5);
            translate([0, 0, 5-0.5]) {
                cylinder(d1=8.25, d2=9.5, h=0.5, center=false);
            }
            for (a=[0, 90, 180, 270]) {
                rotate([0, 0, a+45]) {
                    translate([16.5/2, 0, 0]) {
                        cylinder(d=1.75, h=5, center=false);
                    }
                }
            }
        }
        translate([TIBIA_ORIGIN_X, TIBIA_ORIGIN_Z, 0]) {
            cylinder(d=8.25, h=5);
            cylinder(d=13.5, h=1.5);
            translate([0, 0, 5-0.5]) {
                cylinder(d1=8.25, d2=9.5, h=0.5, center=false);
            }
            for (a=[0, 90, 180, 270]) {
                rotate([0, 0, a]) {
                    translate([16.5/2, 0, 0]) {
                        cylinder(d=1.75, h=5, center=false);
                    }
                }
            }
        }
    }
}


module femur_side_2()
{
    difference() {
        linear_extrude(height=5, convexity=3) {
            import(file=FILE, layer="0");
        }
        translate([0, 0, 0]) {
            cylinder(d=10.5, h=4);
            translate([0, 0, 4]) {
                cylinder(d=7.5, h=5);
            }
        }
        translate([TIBIA_ORIGIN_X, TIBIA_ORIGIN_Z, 0]) {
            cylinder(d=10.5, h=4);
            translate([0, 0, 4]) {
                cylinder(d=7.5, h=5);
            }
        }
    }
}


module femur_link()
{
    linear_extrude(height=FEMUR_SIDES_DIST, convexity=3, center=true) {
        import(file=FILE, layer=1);
    }
}


module femur()
{
    rotate([90, 0, 0]) {
        mirror([0, 0, 1]) {
            translate([0, 0, FEMUR_SIDES_DIST/2]) {
                femur_side_1();
            }
        }
        femur_link();
        translate([0, 0, FEMUR_SIDES_DIST/2]) {
            femur_side_2();
        }
    }
}


module femur_vitamins()
{
    translate([0, 8.5, 0]) {
        rotate([-90, -90, 0]) {
            MG996();
            translate([0, 0, -MG996_BRACKET_Z_POS-bearing_w(623)-0.75]) {
                bearing(623);
            }
        }
    }
}


module tibia()
{
}


module tibia_vitamins()
{
    translate([0, 8.5, 0]) {
        rotate([-90, 90, 0]) {
            MG996();
            translate([0, 0, -MG996_BRACKET_Z_POS-bearing_w(623)-0.75]) {
                bearing(623);
            }
        }
    }
}


module leg(gamma=0, alpha=0, beta=0)
{
    %coxa_vitamins();
    rotate([0, 0, gamma]) {
        color("orange") coxa();
        translate([-COXA_L, 0, 0]) {
            %femur_vitamins();
            rotate([0, alpha, 0]) {
                color("lightblue") femur();
        
                translate([TIBIA_ORIGIN_X, 0, TIBIA_ORIGIN_Z]) {
                    rotate([0, beta, 0]) {
                        color("lightgreen") tibia();
                        %tibia_vitamins();
                    }
                }
            }
        }
    }
}


leg(gamma=15, alpha=-15, beta=20);

//coxa_side_1();
//coxa_side_2();

//mirror([0, 0, 1]) femur_side_1();
//rotate([0, 180, 0]) femur_side_2();
//rotate([90, 0, 0]) rotate([0, 0, -22.5]) femur_link();
