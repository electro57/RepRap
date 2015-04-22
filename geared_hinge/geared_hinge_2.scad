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


module gear(type=0, h=H) {
    rotate([0, 0, type*360/Z/2]) {
        difference() {
            union() {
                intersection() {
                    gearSpur(m, Z, h);
    
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


module link_cyl_cyl(h=H) {
    difference() {
        union() {
            for (x=[-D/2, D/2]) {
                translate([x, 0, 0]) {
                    cylinder(r=(D-2*m)/2, h=h, center=true, $fn=64);
                }
            }

            // Link
            cube([D, (D-2*m)*cos(26.7), h], center=true);
        }

        // Curved link
        for (y=[-D, D]) {
            translate([0, y, 0]) {
                cylinder(r=D/cos(26.7)-D/2+m, h=h, center=true, $fn=64);
            }
        }

        for (x=[-D/2, D/2]) {
            translate([x, 0, 0]) {
                cylinder(r=M4_HOLE/2, h=h, center=true, $fn=16);
            }
        }
    }
}


module link_gear_cyl(type=0, h=H) {
    difference() {
        union() {
                                    gear(type);
            translate([  -D, 0, 0]) cylinder(r=(D-2*m)/2, h=h, center=true, $fn=64);
            translate([-D/2, 0, 0]) cube([D-M4_HOLE, 3*D/4, h], center=true);
        }

        // Rotation holes
        translate([-D, 0, 0]) cylinder(r=M4_HOLE/2, h=h, center=true, $fn=16);
    }
}


module link_gear_gear(h=H, e=D) {
    difference() {
        union() {
            translate([+e/2, 0, 0]) gear(0);
            translate([-e/2, 0, 0]) gear(1);
                                    cube([e-M4_HOLE, 3*D/4, h], center=true);
        }
    }
}


module arm(type=0) {
    difference() {
        translate([-D/2, 0, 0]) {
            cube([D/2, 0.75*D, 3*H+2*GAP], center=true);
        }

        // Chamfert
        translate([0, 0, -1.5*H-GAP]) {
            linear_extrude(height=3*H+2*GAP) {
                assign(angle=90-4.5*360/Z/2) assign(a=(D+2*m)/2*sin(angle), b=(D+2*m)/2*cos(angle)) {
                    polygon(points=[[0, 0], [-a, b], [a/2, b], [a/2, -b], [-a, -b]], paths=[[0, 1, 2, 3, 4]]);
                }
            }
        }

        // Upper gear space
        translate([0, 0, H+GAP]) {
            gear(type);
        }

        // Link space
        translate([D/2, 0, 0]) {
            scale([1.01, 1.01, 1]) {
                link_cyl_cyl(H+2*GAP);
            }
        }
//      cube([.75*D, D, H+2*GAP], center=true);  // Activate for simple gear hinge

        // Lower gear space
        translate([0, 0, -(H+GAP)]) {
            gear(type);
        }
    }
}


module hinge(type=0) {
    color(COLORS[type]) {
        translate([0, 0, H+GAP]) {
            gear(type);
        }
    
        arm(type);
    
        translate([0, 0, -(H+GAP)]) {
            gear(type);
        }
    }
}


module display_simple(angle=0) {
    translate([-D/2, 0,   0]) rotate([0, 0,    -angle]) hinge(0);
                                                        link_cyl_cyl();
    translate([+D/2, 0,   0]) rotate([0, 0, 180+angle]) hinge(1);
}


module display_double(angle=0) {
    translate([-1.5*D+D*(1-cos(angle/2)), D*sin(angle/2),     0]) rotate([0, 0,      -angle]) hinge(0);
    translate([                        0,             0, +H+GAP])                             link_gear_gear();
    translate([                     -D/2,             0,      0]) rotate([0, 0,    -angle/2]) link_gear_cyl(0);
    translate([                     +D/2,             0,      0]) rotate([0, 0, 180+angle/2]) link_gear_cyl(1);
    translate([                        0,             0, -H-GAP])                             link_gear_gear();
    translate([+1.5*D-D*(1-cos(angle/2)), D*sin(angle/2),     0]) rotate([0, 0,   180+angle]) hinge(1);
}


module display_double_large(angle=0) {
    translate([-2.5*D+D*(1-cos(angle/2)), D*sin(angle/2),     0]) rotate([0, 0,      -angle]) hinge(0);
    translate([                        0,             0, +H+GAP])                             link_gear_gear(e=3*D);
    translate([                   -1.5*D,             0,      0]) rotate([0, 0,    -angle/2]) link_gear_cyl(0);

    translate([                     -D/2,             0,      0]) rotate([0, 0,     angle/2]) gear(1);
    translate([                     +D/2,             0,      0]) rotate([0, 0,    -angle/2]) gear(0);

    translate([                   +1.5*D,             0,      0]) rotate([0, 0, 180+angle/2]) link_gear_cyl(1);
    translate([                        0,             0, -H-GAP])                             link_gear_gear(e=3*D);
    translate([+2.5*D-D*(1-cos(angle/2)), D*sin(angle/2),     0]) rotate([0, 0,   180+angle]) hinge(1);
}


//translate([0, +1.5*D, 0]) display_simple(90);
translate([0,      0, 0]) display_simple(0);
//translate([0, -1.5*D, 0]) display_simple(-45);

//translate([0, +1.5*D, 0]) display_double(90);
//translate([0,      0, 0]) display_double(0);
//translate([0, -1.5*D, 0]) display_double(-45);

//translate([0, +1.5*D, 0]) display_double_large(90);
//translate([0,      0, 0]) display_double_large(0);
//translate([0, -1.5*D, 0]) display_double_large(-45);

//gear();
//arm();
//link_cyl_cyl();
//link_gear_cyl(0);
//link_gear_cyl(1);
//link_gear_gear();

//hinge(0);
//hinge(1);

// Animation
//display_double_large(90*$t);
