use <../lib/gear_spur.scad>


EPSILON = 0.05;

D = 20;
Z = 16;
m = D / Z;
H = 15;
GAP = 0.25;


module link() {
    translate([0, 0, GAP/2]) {
        linear_extrude(height=H-GAP) {
            import("geared_hinge.dxf", layer="link", $fn=64);
        }
    }
}

module link_1() {
    difference() {
        union() {
            translate([D/2, 0, 0]) external_gear_spur(m, Z, H-GAP);
            translate([-D/2, 0, 0]) cylinder(r=D/2, h=H-GAP, center=true, $fn=64);
            cube([D, D, H-GAP], center=true);
        }
        translate([D/2, 0, 0]) cylinder(r=4.25/2, h=H+2*EPSILON, center=true, $fn=16);
        translate([-D/2, 0, 0]) cylinder(r=4.25/2, h=H+2*EPSILON, center=true, $fn=16);
    }
}

module link_2() {
    difference() {
        union() {
            translate([D/2, 0, 0]) rotate([0, 0, 360/Z/2]) external_gear_spur(m, Z, H-GAP);
            translate([-D/2, 0, 0]) cylinder(r=D/2, h=H-GAP, center=true, $fn=64);
            cube([D-2, D, H-GAP], center=true);
        }
        translate([D/2, 0, 0]) cylinder(r=4.25/2, h=H+2*EPSILON, center=true, $fn=16);
        translate([-D/2, 0, 0]) cylinder(r=4.25/2, h=H+2*EPSILON, center=true, $fn=16);
    }
}

module link_3() {
    difference() {
        union() {
            translate([D/2, 0, 0]) rotate([0, 0, 360/Z/2]) external_gear_spur(m, Z, H-GAP);
            translate([-D/2, 0, 0]) external_gear_spur(m, Z, H-GAP);
            cube([D-2, D, H-GAP], center=true);
        }
        translate([D/2, 0, 0]) cylinder(r=4.25/2, h=H+2*EPSILON, center=true, $fn=16);
        translate([-D/2, 0, 0]) cylinder(r=4.25/2, h=H+2*EPSILON, center=true, $fn=16);
    }
}


module hinge_1() {
    difference() {
        union() {
            external_gear_spur(m, Z, H);
            translate([-D/2, 0, 0]) {
                cube([D, 2*D/3, H], center=true);
            }
        }
        cylinder(r=4.25/2, h=H+2*EPSILON, center=true, $fn=16);
    }
}


module hinge_2() {
    difference() {
        union() {
            rotate([0, 0, 360/Z/2]) {
                external_gear_spur(m, Z, H);
            }
            translate([D/2, 0, 0]) {
                cube([D, 2*D/3, H], center=true);
            }
        }
        cylinder(r=4.25/2, h=H+2*EPSILON, center=true, $fn=16);
    }
}


module hinge_3() {
    difference() {
        cube([D, 2*D/3, H], center=true);
        translate([D/2, 0, 0]) {
            cylinder(r=D/2+0.5, h=H+2*EPSILON, center=true, $fn=64);
        }
//      translate([-D/4, D/5, 0]) {
//          cylinder(r=3.25/2, h=H+2*EPSILON, center=true, $fn=16);
//      }
//      translate([-D/4, -D/5, 0]) {
//          cylinder(r=3.25/2, h=H+2*EPSILON, center=true, $fn=16);
//      }
    }
}


module hinge_complete_1() {
    hinge_1();
    translate([-D/2, 0, H]) {
        hinge_3();
    }
    translate([0, 0, 2*H]) {
        hinge_1();
    }
}


module hinge_complete_2() {
    hinge_2();
    translate([D/2, 0, H]) {
        rotate([0, 0, 180]) {
            hinge_3();
        }
    }
    translate([0, 0, 2*H]) {
        hinge_2();
    }
}


module display_1() {
    translate([ 0, 0, 0]) color("lightblue") hinge_1();
    translate([D, 0, 0]) color("lightgreen") hinge_2();
}


module display_2() {
    translate([0, 0, 0]) color("lightblue") hinge_1();
    translate([D*cos(45), D*sin(45), 0]) rotate([0, 0, 90]) color("lightgreen") hinge_2();
}


module display_3() {
    translate([0,  0, 0]) color("lightblue") hinge_1();
    translate([0, D, 0]) rotate([0, 0, 180]) color("lightgreen") hinge_2();
}


module display_complete_1() {
    translate([ 0, 0, 0]) color("lightblue") hinge_complete_1();
    translate([10, 0, H/2]) link();
    translate([2D, 0, 0]) color("lightgreen") hinge_complete_2();
}


module display_complete_2() {
    translate([0, 0, 0]) color("lightblue") hinge_complete_1();
    rotate([0, 0, 45]) translate([10, 0, H/2]) link();
    translate([20*cos(45), 20*sin(45), 0]) rotate([0, 0, 90]) color("lightgreen") hinge_complete_2();
}


module display_complete_3() {
    translate([0,  0, 0]) color("lightblue") hinge_complete_1();
    rotate([0, 0, 90]) translate([10, 0, H/2]) link();
    translate([0, D, 0]) rotate([0, 0, 180]) color("lightgreen") hinge_complete_2();
}


module print_half_hinge_1() {
    hinge_1();
    translate([-D/2, 0, 2*H/3]) {
        difference() {
            hinge_3();
            translate([-D/2-100/2, 0, H/6]) {
                cube([100, 100, 100]);
            }
        }
    }
}


module print_half_hinge_2() {
    hinge_2();
    translate([D/2, 0, 2*H/3]) {
        difference() {
            rotate([0, 0, 180]) {
                hinge_3();
            }
            translate([D/2-100/2, 0, H/6]) {
                cube([100, 100, 100]);
            }
        }
    }
}


display_1();
//display_2();
//display_3();

//hinge_1();
//hinge_2();
//hinge_3();

//hinge_complete_1();
//hinge_complete_2();

//display_complete_1();
//translate([0, 2*D, 0]) rotate([0, 0, -45]) display_complete_2();
//translate([0, 4*D, 0]) rotate([0, 0, -90]) display_complete_3();

//print_half_hinge_1();
//print_half_hinge_2();
//link();
//link_1();
//link_2();
//link_3();

//print_half_hinge_1();
//print_half_hinge_2();
//link();