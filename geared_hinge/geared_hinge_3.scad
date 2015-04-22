use <../lib/gear_spur.scad>


EPSILON = 0.05;

D = 30;
Z = 16;
m = D / Z;
H = 25;
GAP = 0.25;

M4_HOLE = 4.25;

// Gear parameters
PRESSURE_ANGLE = 20;
CLEARANCE = 0.1;
BACKLASH = 0.3;

COLORS = ["lightgreen", "lightblue"];


module gearSpur(a, b, c) {
    external_gear_spur(a, b, c, pressure_angle=PRESSURE_ANGLE, clearance=CLEARANCE, backlash=BACKLASH);
}


module gear(type=0, m=m, z=Z, h=H) {
    rotate([0, 0, type*360/z/2]) {
        difference() {
            union() {
                intersection() {
                    gearSpur(m, z, h);
    
                    // Chamfers
                    cylinder(r1=D/2+h, r2=D/2, h=h, center=true, $fn=32);
                    cylinder(r2=D/2+h, r1=D/2, h=h, center=true, $fn=32);
                }
            }
    
            // Axis hole
            cylinder(r=M4_HOLE/2, h=h, center=true, $fn=16);
        }
    }
}


module link(h=H, e=3*D) {
    difference() {
        union() {
            translate([-e/2, 0, 0]) cylinder(r=(D-2*m)/2, h=h, center=true, $fn=64);
            translate([+e/2, 0, 0]) cylinder(r=(D-2*m)/2, h=h, center=true, $fn=64);
                                    cube([e-M4_HOLE, 0.75*(D-2*m)+0.25*(D-2*m), h], center=true);
        }

        translate([          -e/2, 0, h/4]) cylinder(r=(D-2*m)/2, h=h/2, center=true, $fn=64);
        translate([          -e/2, 0,   0]) cube([(D-2*m)/2, (D-2*m)/2, h/2]);
        translate([          +e/2, 0, h/4]) cylinder(r=(D-2*m)/2, h=h/2, center=true, $fn=64);
        translate([+e/2-(D-2*m)/2, 0,   0]) cube([(D-2*m)/2, D-2*m/2, h/2]);

        // Rotation holes
        translate([-e/2, 0, 0]) cylinder(r=M4_HOLE/2, h=h, center=true, $fn=16);
        translate([+e/2, 0, 0]) cylinder(r=M4_HOLE/2, h=h, center=true, $fn=16);
    }
}


module arm(type=0) {
    difference() {
        union() {
            difference() {
                translate([-D/2, 0, 0]) {
                    cube([D, D-2*m, 3*H+2*GAP], center=true);
                }

                // Gear space
//              translate([0, 0, -H/2]) {
//                  linear_extrude(height=H) {
//                      assign(angle=90-4.5*360/Z/2) assign(a=(D-2*m)/2*sin(angle), b=(D-2*m)/2*cos(angle)) {
//                          polygon(points=[[0, 0], [-a, b], [a/2, b], [a/2, -b], [-a, -b]], paths=[[0, 1, 2, 3, 4]]);
//                      }
//                  }
//              }

                translate([(D-2*m)/2, 0, 0]) {
                    cube([D-2*m, D-2*m, H], center=true);
                }
                cylinder(r=(D-2*m)/2, h=H, center=true, $fn=64);
                gear(type);
            }

//          translate([0, 0, 0]) {
//              gear(type);
//          }

            // Rotations
            translate([0, 0,  H]) cylinder(r=(D-2*m)/2, h=H+GAP, center=true, $fn=64);
            translate([0, 0, -H]) cylinder(r=(D-2*m)/2, h=H+GAP, center=true, $fn=64);
        }

        // Rotations space
        translate([0,                   0,      H+GAP]) cylinder(r=(D-2*m)/2, h=H/2, $fn=64);
        translate([-(D-2*m)/2, -(D-2*m)/2,      H+GAP]) cube([(D-2*m)/2, (D-2*m)/2, H/2]);
        translate([0,                   0, -1.5*H-GAP]) cylinder(r=(D-2*m)/2, h=H/2, $fn=64);
        translate([-(D-2*m)/2, -(D-2*m)/2, -1.5*H-GAP]) cube([(D-2*m)/2, (D-2*m)/2, H/2]);

        // Rotation hole
        cylinder(r=M4_HOLE/2, h=3*H+2*GAP, center=true, $fn=16);
    }
}


module hinge(type=0) {
    color(COLORS[type]) {
        arm(type);    
        gear(type);
    }
}


module display(angle=0) {
    translate([-1.5*D, 0,      0]) rotate([  0, 0,   -angle])  hinge(0);
    translate([     0, 0, +H+GAP]) rotate([180, 0,        0])  link(e=3*D);
    translate([  -D/2, 0,      0]) rotate([  0, 0,    angle])  gear(1);
    translate([  +D/2, 0,      0]) rotate([  0, 0,   -angle])  gear(0);
    translate([     0, 0, -H-GAP]) rotate([  0, 0,      180])  link(e=3*D);
    translate([+1.5*D, 0,      0]) rotate([180, 0, 180+angle]) hinge(1);
}


module display2(angle=0) {
    translate([  -D, 0,      0]) rotate([  0, 0,   -angle])  hinge(0);
    translate([   0, 0, +H+GAP]) rotate([180, 0,        0])  link(e=2*D);
    translate([-D/4, 0,      0]) rotate([  0, 0,    angle])  gear(1, z=8);
    translate([+D/4, 0,      0]) rotate([  0, 0,   -angle])  gear(0, z=8);
    translate([   0, 0, -H-GAP]) rotate([  0, 0,      180])  link(e=2*D);
    translate([  +D, 0,      0]) rotate([180, 0, 180+angle]) hinge(1);
}


//translate([0, +2*D, 0]) display(0);
//translate([0,    0, 0]) display(-45);
//translate([0, -2*D, 0]) display(-90);

//translate([0, +2*D, 0]) display2(0);
//translate([0,    0, 0]) display2(-45);
//translate([0, -2*D, 0]) display2(-90);

//gear();
//arm(0);
//arm(1);
//link();

//hinge(0);
//hinge(1);

// Animation
//display_double_large(90*$t);


display(-90);
translate([-D/2, -100, 0]) rotate([0, 0, 180]) display2(-90);
