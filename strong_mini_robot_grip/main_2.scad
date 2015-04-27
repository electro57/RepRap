// Strong Mini Robot Grip
//
// Draft version
//
// 1 servo version

use <../lib/gear_spur.scad>
use <../lib/servos/Goteck/GS_9025MG.scad>


EPSILON = 0.01;

DXF_FILE = "./main_2.dxf";

SERVO_H = 12.5;  // add some place (~0.3mm)
SERVO_STREAKS_SCALE = 1.;

Z = 10;
m = 1;
D = m * Z;
GAP = -0.25;

CENTER_H = 12.5;
PLATE_H = 2;
FINGER_MIDDLE_H = CENTER_H - 2 * 2.25 * m;

BODY_REAR_D = 30;
BODY_REAR_H = 4;

$fs=0.5;
$fa=2.5;


module lever()
{
    linear_extrude(height=PLATE_H, center=false) {
        import(file=DXF_FILE, layer="lever");
    }
}


module lever_bottom()
{
    translate([0, 0, -CENTER_H/2-PLATE_H*2]) {
        lever();
    }
}


module lever_top()
{
    translate([0, 0, CENTER_H/2+PLATE_H]) {
        lever();
    }
}


module finger_bottom()
{
    translate([0, 0, -CENTER_H/2-PLATE_H]) {
        linear_extrude(height=PLATE_H-GAP) {
            import(file=DXF_FILE, layer="finger_1");
        }
    }
    translate([0, 0, -CENTER_H/2-GAP]) {
        linear_extrude(height=2.25*m+GAP) {
            import(file=DXF_FILE, layer="finger_2");
        }
    }
    
    // Flat gear
    translate([2.5*PI*m, 0, -D/2-GAP]) {
        rotate([90, 0, 0]) {
            flat_gear_spur(m, Z=7, h=5, e=0, center=false);
        }
    }
}


module finger_middle()
{
    linear_extrude(height=FINGER_MIDDLE_H, center=true) {
        import(file=DXF_FILE, layer="finger_3");
    }
}


module finger_top()
{
    translate([0, 0, FINGER_MIDDLE_H/2]) {
        linear_extrude(height=PLATE_H+2.25*m) {
            import(file=DXF_FILE, layer="finger_4");
        }
    }
}


module finger()
{
    finger_bottom();
    finger_middle();
    finger_top();
}


module body()
{
    // Bottom
    translate([0, 0, -CENTER_H/2-PLATE_H]) {
        linear_extrude(height=PLATE_H) {
            import(file=DXF_FILE, layer="body_1");
        }
    }
    
    // Middle
    linear_extrude(height=CENTER_H, center=true) {
        import(file=DXF_FILE, layer="body_2");
    }
    
    // Top
    translate([0, 0, CENTER_H/2]) {
        linear_extrude(height=PLATE_H) {
            import(file=DXF_FILE, layer="body_1");
        }
    }

    // Rear
    translate([0, -35+BODY_REAR_H/2, 0]) {
        rotate([-90, 0, 0]) {
            difference() {
                cylinder(d=BODY_REAR_D, h=BODY_REAR_H, center=true);
                cube([BODY_REAR_D+2*EPSILON, SERVO_H+2*EPSILON, BODY_REAR_H+2*EPSILON], center=true);
                for (angle=[-135, -45, 45, 135]) {
                    rotate([0, 0, angle]) {
                        translate([BODY_REAR_D/2-2, 0, 0]) {
                            cylinder(d=1.5, h=BODY_REAR_H+2*EPSILON, center=true);
                        }
                    }
                }
            }
        }
    }
}


module gear()
{
    translate([0, -5.25, 0]) {
        rotate([-90, 360/(Z/1), 0]) {
            difference() {
                external_gear_spur(m, Z, h=5, center=false);
                cylinder(d=2, h=5, center=false);
                *cylinder(d=4.35, h=3.25, center=false);
                *cylinder(d=4.9, h=0.1, center=false);
                scale(SERVO_STREAKS_SCALE) {
                    linear_extrude(height=3.25, convexity=3) {
                        import(file=DXF_FILE, layer="gear_2", center=false);
                    }
                }
            }
        }
    }
}


module vitamins(alpha)
{
    translate([0, -15, 0]) color("gray", alpha) rotate([-90, 0, 0]) GS_9025MG();
}


module display()
{
    color("lightblue")   lever_top();
    color("lightblue")   lever_bottom();
    color("lightgreen")  finger();

    assign(alpha=1)
    *rotate([0, 180, 0]) {
        color("blue", alpha)   lever_top();
        color("blue", alpha)   lever_bottom();
        color("green", alpha)  finger();
    }
    
    color("orange")         body();
    color("yellow")         gear();
    
    vitamins();
}


display();

//lever();
//finger_bottom();
//finger_middle();
//finger_top();
//gear();
//body();
