include <../lib/servos/TowerPro/MG996.scad>

FILE = "main_long.dxf";

COXA_L = 34;

FEMUR_SIDES_DIST = 41+1;

TIBIA_ORIGIN_X = -20.6;
TIBIA_ORIGIN_Z = 68.7;

ANGLE_1 = 20;
ANGLE_2 = -25;

$fs=0.5;
$fa=2.5;


// TODO: refactor as coxa, femur, tibia


//module coxa

module coxa()
{
    translate([0, 0, 18]) {
    }
}


module coxa_lid()
{
    translate([0, 0, 18]) {
        MG996_lid();
    }
}


module coxa_vitamins()
{
    translate([0, 0, 18]) {
        MG996();
        MG996_lid_vitamins();
    }
}


module coxa_femur_bracket_side_1()
{
    translate([0, 0, MG996_L-MG996_SHAFT_POS_X]) {
        difference() {
            translate([0, 0, MG996_BRACKET_L/2]) {
                cylinder(d=20, h=MG996_BRACKET_L, center=true);
                translate([-(COXA_L+MG996_W/2)/2, 0, 0]) {
                    cube([COXA_L+MG996_W/2, 20, MG996_BRACKET_L], center=true);
                }
            }
            
            translate([-COXA_L-MG996_W/2, 20/2-1.5, 0]) {
                cube([MG996_W, 2, MG996_BRACKET_L], center=false);
            }
        }
    }
}


module coxa_femur_bracket_side_2()
{
    translate([0, 0, -MG996_SHAFT_POS_X-MG996_BRACKET_L/2]) {
        difference() {
            union() {
                cylinder(d=20, h=MG996_BRACKET_L, center=true);
                translate([-(COXA_L+MG996_W/2)/2, 0, 0]) {
                    cube([COXA_L+MG996_W/2, 20, MG996_BRACKET_L], center=true);
                }
            }
            translate([0, 0, MG996_BRACKET_L/2-1.5]) {
                cylinder(d=30, h=2, center=false);
            }
            
            translate([-COXA_L-MG996_W/2, 20/2-1.5, -MG996_BRACKET_L/2]) {
                cube([MG996_W, 2, MG996_BRACKET_L], center=false);
            }
        }
    }
}


//module coxa_femur_bracket_link()
//{
//    translate([-COXA_L+MG996_W/2+4/2, 0, MG996_SHAFT_POS_X]) {
//        rcube([4, 14, MG996_L+2*4], [0, 0, 4], center=true);
//    }
//}


module coxa_femur_bracket()
{
    coxa_femur_bracket_side_1();
//    coxa_femur_bracket_link();
    coxa_femur_bracket_side_2();
}


module femur_side_1()
{
    difference() {
        linear_extrude(height=5, convexity=3) {
            import(file=FILE, layer="0");
        }
        translate([0, 0, 0]) {
            cylinder(d=13.5, h=1);
            translate([0, 0, 1]) {
                MG996_spline(h=3);
                translate([0, 0, 3]) {
                    cylinder(d=3, h=1);
                }
            }
        }
        translate([TIBIA_ORIGIN_X, TIBIA_ORIGIN_Z, 0]) {
            cylinder(d=13.5, h=1);
            translate([0, 0, 1]) {
                MG996_spline(h=3);
                translate([0, 0, 3]) {
                    cylinder(d=3, h=1);
                }
            }
        }
        
        linear_extrude(height=1.5, convexity=3) {
            import(file=FILE, layer="1");
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

        linear_extrude(height=1.5, convexity=3) {
            import(file=FILE, layer="1");
        }
    }
}


module femur_link()
{
    linear_extrude(height=FEMUR_SIDES_DIST+2*1.5, convexity=3, center=true) {
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


module femur_lid()
{
    translate([0, 8.5, 0]) {
        rotate([-90, -90, 0]) {
            MG996_lid();
        }
    }
}


module femur_vitamins()
{
    translate([0, 8.5, 0]) {
        rotate([-90, -90, 0]) {
            MG996();
            MG996_lid_vitamins();
        }
    }
}


module tibia()
{
}


module tibia_lid()
{
    translate([0, 8.5, 0]) {
        rotate([-90, 90, 0]) {
            MG996_lid();
        }
    }
}


module tibia_vitamins()
{
    translate([0, 8.5, 0]) {
        rotate([-90, 90, 0]) {
            MG996();
            MG996_lid_vitamins();
        }
    }
}


module leg(gamma=0, alpha=0, beta=0)
{
    %coxa_vitamins();
    coxa_lid();
    rotate([0, 0, gamma]) {
        coxa();
        
        color("orange") coxa_femur_bracket();
        
        translate([-COXA_L, 0, 0]) {
            color("lightblue") femur_lid();
            %femur_vitamins();
            rotate([0, alpha, 0]) {
                color("lightblue") femur();
        
                translate([TIBIA_ORIGIN_X, 0, TIBIA_ORIGIN_Z]) {
                    rotate([0, beta, 0]) {
                        color("lightgreen") tibia();
                        color("lightgreen") tibia_lid();
                        %tibia_vitamins();
                    }
                }
            }
        }
    }
}


leg(gamma=15, alpha=-15, beta=20);

//mirror([0, 0, 1]) femur_side_1();
//rotate([0, 180, 0]) femur_side_2();
//rotate([-90, 0, 0]) femur_link();
