include <../lib/gear_spur.scad>
include <../lib/Goteck_GS-9025MG.scad>

CENTER_H = 5;
PLATE_H = 2.5;


Z = 12;
m = 0.9;
D = m * Z;
GAP = 0.25;
e = 2 - GAP;

SERVO_H = 12.2;

$fs=0.5;
$fa=2.5;


module lever_1()
{
    linear_extrude(height=CENTER_H, center=true) {
        import(file="my_grip.dxf", layer="lever_1");
    }
}


module lever_2()
{
    linear_extrude(height=CENTER_H, center=true) {
        import(file="my_grip.dxf", layer="lever_2");
    }
}


module lever_1b()
{
    translate([0, 0, -PLATE_H/2-PLATE_H*2])
    linear_extrude(height=PLATE_H, center=true) {
        import(file="my_grip.dxf", layer="lever_1");
    }
}


module lever_2b()
{
    translate([0, 0, -PLATE_H/2-PLATE_H*2])
    linear_extrude(height=PLATE_H, center=true) {
        import(file="my_grip.dxf", layer="lever_2");
    }
}


module finger_base()
{
    linear_extrude(height=CENTER_H, center=true) {
        import(file="my_grip.dxf", layer="finger_b");
    }
    translate([0, 0, -CENTER_H/2-PLATE_H]) {
        linear_extrude(height=PLATE_H) {
            import(file="my_grip.dxf", layer="finger_a");
        }
    }
}


module finger_cover()
{
    translate([0, 0, CENTER_H/2]) {
        linear_extrude(height=PLATE_H) {
            import(file="my_grip.dxf", layer="finger_a");
        }
        translate([-9.08, 0, 1.25*m+e]) {
            rotate([90, 0, 0]) {
                flat_gear_spur(m, Z=7, h=5.25, e=e, center=false);
            }
        }
    }
}


module body_base()
{
    linear_extrude(height=CENTER_H, center=true) {
        import(file="my_grip.dxf", layer="body_b");
    }
    translate([0, 0, -CENTER_H/2-PLATE_H]) {
        linear_extrude(height=PLATE_H) {
            import(file="my_grip.dxf", layer="body_a");
        }
    }
}


module body_cover()
{
    translate([0, 0, CENTER_H/2]) {
        linear_extrude(height=PLATE_H) {
            import(file="my_grip.dxf", layer="body_a");
        }
    }
    translate([0, 0, CENTER_H/2+PLATE_H]) {
        linear_extrude(height=l/2+3) {
            import(file="my_grip.dxf", layer="body_c");
        }
    }
}


module gear()
{
    assign(shiftX=-9.08-2.5*PI*m)
    translate([shiftX, -5, CENTER_H/2+PLATE_H+l/2]) {
        rotate([-90, 360/(Z/1), 0]) {
            difference() {
                external_gear_spur(m, Z, h=5, center=false);
                cylinder(d=2, h=5, center=false);
                cylinder(d=5, h=3, center=false);
            }
        }
    }
}


module half(alpha=1)
{
    color("lightblue", alpha)   lever_1();
    color("lightblue", alpha)   lever_2();
    color("cyan", alpha)        lever_1b();
    color("cyan", alpha)        lever_2b();
  
    color("lightgreen", alpha)  finger_base();
    color("darkgreen", alpha)   finger_cover();
    
    color("yellow", alpha)      gear();
    
    assign(shiftX=-16)  // -9.08-2.5*PI*m
    translate([shiftX, -14.5, CENTER_H/2+PLATE_H+l/2]) color("gray", alpha) rotate([-90, 0, 0]) GS_9025MG();
}



module display()
{
    half();
    rotate([0, 180, 0])     half(0.25);
    color("orange")         body_base();
    color("darkorange")     body_cover();
}


display();

//lever_1();
//lever_1b();
//finger_base();
//finger_cover();
//body_base();
//body_cover();


// TODO: add option to move both fingers at the same time with only 1 servo (use gears)