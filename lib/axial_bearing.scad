// axial bearings module

EPSILON = 0.01;


function axial_bearing_dimensions(model) =
	model == "F3-8M"  ? [3,  8, 3.5, 6, 1.588]:
	model == "F4-9M"  ? [4,  9, 4,   6, 1.588]:
	model == "F4-10M" ? [4, 10, 4,   6, 1.588]:  // default
	model == "F5-10M" ? [5, 10, 4,   7, 1.588]:
	model == "F5-11M" ? [5, 11, 4.5, 7, 1.588]:
	model == "F5-12M" ? [5, 12, 4,   7, 1.588]:
	model == "F6-11M" ? [6, 11, 1.5, 8, 1.588]:
	model == "F6-14M" ? [6, 14, 4,   8, 1.588]:
	[4, 10, 4,   6, 1.588];  // default to F4-10M


function axial_bearing_d(model) = axial_bearing_dimensions(model)[0];
function axial_bearing_D(model) = axial_bearing_dimensions(model)[1];
function axial_bearing_h(model) = axial_bearing_dimensions(model)[2];
function axial_bearing_n(model) = axial_bearing_dimensions(model)[3];
function axial_bearing_b(model) = axial_bearing_dimensions(model)[4];

module _axial_bearing(d, D, h, n, b) {

	// center part
	difference() {
		cylinder(d=D-0.2, h=h*1/6, center=true, $fn=64);
		cylinder(d=d+0.2, h=h*1/6+10*EPSILON, center=true, $fn=64);
	}

	// balls
	assign(step=360/n)
	for (angle=[0:step:360]) {
		rotate([0, 0, angle]) {
			translate([0, (D+d)/4, 0]) {
				sphere(d=b, center=true, $fn=16);
			}
		}
	}

	// AS parts
	for (i=[-1, 1]) {
		translate([0, 0, i*(h-(h-b)/2)/2]) {
			difference() {
				cylinder(d=D, h=(h-b)/2, center=true, $fn=64);
				cylinder(d=d, h=(h-b)/2+10*EPSILON, center=true, $fn=64);
			}
		}
	}
}


module axial_bearing(model) {
	assign(
		d = axial_bearing_d(model),
		D = axial_bearing_D(model),
		h = axial_bearing_h(model),
		n = axial_bearing_n(model),
		b = axial_bearing_b(model)
	)
		color([0.8, 0.8, 0.8])
			_axial_bearing(d, D, h, n, b);
}


//axial_bearing();
