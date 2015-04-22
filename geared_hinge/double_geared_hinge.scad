use <../lib/gear_spur.scad>


EPSILON = 0.05;

D = 20;
Z = 16;
m = D / Z;
H = 15;
GAP = 0.25;


module link(h=H) {
difference() {
	union() {
	for (x=[-D/2, D/2]) {
		translate([x, 0, 0]) {
		cylinder(r=D/2, h=h, center=true, $fn=64);
		}
	}

	// Link
	cube([D, D*cos(26.7), H], center=true);
	}

	// Curved link
	for (y=[-D, D]) {
	translate([0, y, 0]) {
		cylinder(r=D/cos(26.7)-D/2, h=h+2*EPSILON, center=true, $fn=64);
	}
	}

	// Rotation holes
	for (x=[-D/2, D/2]) {
	translate([x, 0, 0]) {
		cylinder(r=4.25/2, h=h+2*EPSILON, center=true, $fn=16);
	}
	}
}
}


module link_gear_cyl(type=0) {
difference() {
	union() {
	translate([   0, 0, 0]) rotate([0, 0, type*360/Z/2]) external_gear_spur(m, Z, H-GAP);
	translate([  -D, 0, 0]) cylinder(r=D/2, h=H-GAP, center=true, $fn=64);
	translate([-D/2, 0, 0]) cube([D, D, H-GAP], center=true);
	}

	// Rotation holes
	translate([ 0, 0, 0]) cylinder(r=4.25/2, h=H+2*EPSILON, center=true, $fn=16);
	translate([-D, 0, 0]) cylinder(r=4.25/2, h=H+2*EPSILON, center=true, $fn=16);
}
}

module link_gear_gear() {
difference() {
	union() {
	translate([+D/2, 0, 0]) external_gear_spur(m, Z, H-GAP);
	translate([-D/2, 0, 0]) rotate([0, 0, 360/Z/2]) external_gear_spur(m, Z, H-GAP);
	                                                cube([D-2, D, H-GAP], center=true);
	}

	// Rotation holes
	translate([+D/2, 0, 0]) cylinder(r=4.25/2, h=H+2*EPSILON, center=true, $fn=16);
	translate([-D/2, 0, 0]) cylinder(r=4.25/2, h=H+2*EPSILON, center=true, $fn=16);
}
}


module gear(type=0) {
difference() {
	union() {
	rotate([0, 0, type*360/Z/2]) {
		external_gear_spur(m, Z, H);
	}
	translate([-D/2, 0, 0]) {
		cube([D, 2*D/3, H], center=true);
	}
	}

	// Rotation hole
	cylinder(r=4.25/2, h=H+2*EPSILON, center=true, $fn=16);
}
}


module arm() {
difference() {
	cube([D, 2*D/3, H], center=true);
	translate([D/2, 0, 0]) {
	cylinder(r=D/2+0.5, h=H+2*EPSILON, center=true, $fn=64);
	}

	// Assembling holes
	translate([-D/4, D/5, 0]) {
	cylinder(r=3.25/2,  h=H+2*EPSILON, center=true, $fn=16);
	}
	translate([-D/4, -D/5, 0]) {
	cylinder(r=3.25/2,  h=H+2*EPSILON, center=true, $fn=16);
	}
}
}


module hinge(type=0) {
gear(type);
translate([-D/2, 0, H]) {
	arm();
}
translate([0, 0, 2*H]) {
	gear(type);
}
}


module half_hinge(type=0) {
gear(type);
translate([-D/2, 0, 2*H/3]) {
	difference() {
	arm();
	translate([-D/2-100/2, 0, H/6]) {
		cube([100, 100, 100]);
	}
	}
}
}


module display_simple(angle=0) {
translate([-D/2, 0,   0]) rotate([0, 0,    -angle]) color("lightblue")  hinge(0);
translate([   0, 0,   H])                                               link();
translate([+D/2, 0,   0]) rotate([0, 0, 180+angle]) color("lightgreen") hinge(1);
}


module display_double(angle=0) {
translate([-3*D/2+D*(1-cos(angle/2)), D*sin(angle/2),  0]) rotate([0, 0,    -angle]) color("lightblue")  hinge(0);
translate([                        0,             0, 2*H])                                               link_gear_gear();
translate([                     -D/2,             0,   H]) rotate([0, 0,    -angle/2])                   link_gear_cyl(0);
translate([                     +D/2,             0,   H]) rotate([0, 0, 180+angle/2])                   link_gear_cyl(1);
                                                                                                         link_gear_gear();
translate([+3*D/2-D*(1-cos(angle/2)), D*sin(angle/2),  0]) rotate([0, 0, 180+angle]) color("lightgreen") hinge(1);
}


//translate([0, +2*D, 0]) display_simple(90);
//translate([0,    0, 0]) display_simple(45);
//translate([0, -2*D, 0]) display_simple(0);

translate([0, +2*D, 0]) display_double(90);
translate([0,    0, 0]) display_double(45);
translate([0, -2*D, 0]) display_double(0);

//hinge(0);
//half_hinge(0);
//hinge(1);
//half_hinge(1);
//link();
//link_gear_cyl(0);
//link_gear_cyl(1);
//link_gear_gear();
