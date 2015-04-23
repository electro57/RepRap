// Strong Mini Robot Grip
//
// Draft version
//
// TODO: add option to move both fingers at the same time with only 1 servo (use gears)

use <../lib/gear_spur.scad>
use <../lib/servos/Goteck/GS_9025MG.scad>


EPSILON = 0.01;

SERVO_H = 12.2;  // TODO: get from lib file

Z = 10;
m = 0.95;
D = m * Z;
GAP = 0.25;

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
        import(file="main_2.dxf", layer="lever");
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
        linear_extrude(height=PLATE_H) {
            import(file="main_2.dxf", layer="finger_1");
        }
    }
     translate([0, 0, -CENTER_H/2]) {
        linear_extrude(height=2.25*m) {
            import(file="main_2.dxf", layer="finger_2");
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
        import(file="main_2.dxf", layer="finger_3");
    }
}


module finger_top()
{
    translate([0, 0, FINGER_MIDDLE_H/2]) {
        linear_extrude(height=PLATE_H+2.25*m) {
            import(file="main_2.dxf", layer="finger_4");
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
            import(file="main_2.dxf", layer="body_1");
        }
    }
    
    // Middle
    linear_extrude(height=CENTER_H, center=true) {
        import(file="main_2.dxf", layer="body_2");
    }
    
    // Top
    translate([0, 0, CENTER_H/2]) {
        linear_extrude(height=PLATE_H) {
            import(file="main_2.dxf", layer="body_1");
        }
    }

    // Rear
    translate([0, -35+BODY_REAR_H/2, 0]) {
        rotate([-90, 0, 0]) {
            difference() {
                cylinder(d=BODY_REAR_D, h=BODY_REAR_H, center=true);
                cube([BODY_REAR_D+2*EPSILON, SERVO_H+2*EPSILON, BODY_REAR_H+2*EPSILON], center=true);
            }
        }
    }
}


module gear()
{
    assign(shiftX=0+0*PI*m)
    translate([shiftX, -5.25, 0]) {
        rotate([-90, 360/(Z/1), 0]) {
            difference() {
                external_gear_spur(m, Z, h=5, center=false);
                cylinder(d=2, h=5, center=false);
                cylinder(d=5, h=3.5, center=false);
            }
        }
    }
}


module vitamins(alpha)
{
    translate([0, -15, 0]) color("gray", alpha) rotate([-90, 0, 0]) GS_9025MG();
}


module half(alpha=1)
{
    color("lightblue", alpha)   lever_top();
    color("lightblue", alpha)   lever_bottom();
    color("lightgreen", alpha)  finger();
}



module display()
{
    color("lightblue", alpha)   lever_top();
    color("lightblue", alpha)   lever_bottom();
    color("lightgreen", alpha)  finger();

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
