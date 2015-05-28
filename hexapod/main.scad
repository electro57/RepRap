use <../lib/servos/TowerPro/MG995.scad>
use <servo_lid.scad>

FILE = "main_long.dxf";

SERVO_SHAFT_C0ORD_X_1 = 0;
SERVO_SHAFT_C0ORD_Y_1 = 0;
SERVO_SHAFT_C0ORD_X_2 = -20.6;
SERVO_SHAFT_C0ORD_Y_2 = 68.7;

ANGLE_1 = 20;
ANGLE_2 = -25;

$fs=0.5;
$fa=2.5;

    
module servo_shaft(h)
{
    cylinder(d=5.5, h=h);
    for (a=[0:360/24:360]) {
        rotate([0, 0, a]) {
            translate([5.5/2, 0, 0]) {
                cylinder(d=0.65, h=h, $fn=4);
            }
        }
    }
}


module servo_bracket_1_bottom()
{
    difference() {
        linear_extrude(height=5, convexity=3) {
            import(file=FILE, layer="0");
        }
        translate([SERVO_SHAFT_C0ORD_X_1, SERVO_SHAFT_C0ORD_Y_1, 0]) {
            cylinder(d=13.5, h=1);
            translate([0, 0, 1]) {
                servo_shaft(h=3);
                translate([0, 0, 3]) {
                    cylinder(d=3, h=1);
                }
            }
        }
        translate([SERVO_SHAFT_C0ORD_X_2, SERVO_SHAFT_C0ORD_Y_2, 0]) {
            cylinder(d=13.5, h=1);
            translate([0, 0, 1]) {
                servo_shaft(h=3);
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


module servo_bracket_1_top()
{
    difference() {
        linear_extrude(height=5, convexity=3) {
            import(file=FILE, layer="0");
        }
        translate([SERVO_SHAFT_C0ORD_X_1, SERVO_SHAFT_C0ORD_Y_1, 0]) {
            cylinder(d=10.5, h=4);
            translate([0, 0, 4]) {
                cylinder(d=7.5, h=5);
            }
        }
        translate([SERVO_SHAFT_C0ORD_X_2, SERVO_SHAFT_C0ORD_Y_2, 0]) {
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


module servo_bracket_1_link()
{
    translate([0, 0, -1.5]) {
        linear_extrude(height=41+2*1.5, convexity=3) {
            import(file=FILE, layer=1);
        }
    }
}


module servo_shaft_test()
{
    difference() {
        cylinder(d=10, h=4);
    }
}


module vitamins()
{
    translate([0, 0, 11.5]) {
        rotate([0, 0, 90-ANGLE_1]) {
            mirror([0, 0, 1]) {
                MG995();
            }
        }
    }
    translate([SERVO_SHAFT_C0ORD_X_2, SERVO_SHAFT_C0ORD_Y_2, 11.5]) {
        rotate([0, 0, -90+ANGLE_2]) {
            mirror([0, 0, 1]) {
                MG995();
            }
        }
    }

    translate([0, 0, 38.5]) {
        rotate([0, 0, -90+ANGLE_2]) {
            mirror([0, 0, 1]) {
                servo_lid_vitamins();
            }
        }
    }

    translate([SERVO_SHAFT_C0ORD_X_2, SERVO_SHAFT_C0ORD_Y_2, 38.5]) {
        rotate([0, 0, 90-ANGLE_1]) {
            mirror([0, 0, 1]) {
                servo_lid_vitamins();
            }
        }
    }
}


module display()
{
    
    mirror([0, 0, 1]) {
        servo_bracket_1_bottom();
    }
    servo_bracket_1_link();
    translate([0, 0, 41]) {
        servo_bracket_1_top();
    }
    translate([0, 0, 38.5]) {
        rotate([0, 0, -90-ANGLE_1]) {
            mirror([0, 0, 1]) {
                servo_lid();
            }
        }
    }
    translate([SERVO_SHAFT_C0ORD_X_2, SERVO_SHAFT_C0ORD_Y_2, 38.5]) {
        rotate([0, 0, 90+ANGLE_2]) {
            mirror([0, 0, 1]) {
                servo_lid();
            }
        }
    }

    color("gray") vitamins();
}


display();

//mirror([0, 0, 1]) servo_shaft_test();
