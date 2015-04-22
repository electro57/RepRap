/*
 * Bearing model.
 *
 * Originally by Hans Häggström, 2010.
 * Modified by Frédéric Mantegazza (2015)
 *
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later
 */

EPSILON = 0.01;


BEARING_INNER_DIAMETER = 0;
BEARING_OUTER_DIAMETER = 1;
BEARING_WIDTH = 2;


// Bearing dimensions
// model == XXX ? [inner dia, outer dia, width]:
function bearingDimensions(model) =
    model ==  623 ? [ 3, 10, 4]:
    model ==  624 ? [ 4, 13, 5]:
    model ==  684 ? [ 5, 11, 5]:  // or [4, 9, 4]: ???
	model == "MR105" ? [5, 10, 3]:
	model == "MR115" ? [5, 11, 4]:
    model ==  695 ? [ 5, 13, 4]:
    model ==  605 ? [ 5, 14, 5]:
    model ==  625 ? [ 5, 16, 5]:
	model ==  106 ? [ 6, 10, 3]:
	model ==  126 ? [ 6, 12, 4]:
	model ==  696 ? [6, 15, 5]:
	model ==  626 ? [6, 19, 6]:
    model ==  627 ? [ 7, 22, 7]:
    model ==  688 ? [ 8, 16, 4]:
    model ==  698 ? [ 8, 19, 6]:
    model ==  608 ? [ 8, 22, 7]:
    model == 6700 ? [10, 16, 4]:
    model == 6800 ? [10, 19, 5]:
    model == 6900 ? [10, 22, 6]:
    model == 6701 ? [12, 18, 4]:
    model == 6801 ? [12, 21, 5]:
    model == 6901 ? [12, 24, 6]:
    model == 6702 ? [15, 21, 4]:
    model == 6703 ? [17, 23, 4]:
    [8, 22, 7]; // this is the default


function bearing_d(model) = bearingDimensions(model)[BEARING_INNER_DIAMETER];
function bearing_D(model) = bearingDimensions(model)[BEARING_OUTER_DIAMETER];
function bearing_w(model) = bearingDimensions(model)[BEARING_WIDTH];


module _bearing(d, D, w, pos, rot) {

	module ring(D, d, w) {
		difference() {
			cylinder(r=D/2, h=w, $fs=0.1);
			translate([0,0,-EPSILON]) {
				cylinder(r=d/2, h=w+2*EPSILON, $fs=0.1);
			}
		}
	}

	inner_rim = d + (D - d) * 0.25;
	outer_rim = D - (D - d) * 0.25;
	mid_sink = w * 0.1;

    translate(pos) rotate(rot) {
        difference() {
            ring(D, d, w);
            translate([0, 0, -EPSILON]) {
                ring(outer_rim, inner_rim, mid_sink+EPSILON);
            }
            translate([0, 0, w-mid_sink]) {
                ring(outer_rim, inner_rim, mid_sink+EPSILON);
            }
        }
    }
}


module bearing(model, pos=[0,0,0], rot=[0,0,0]) {
	d = bearing_d(model);
	D = bearing_D(model);
	w = bearing_w(model);
	color([0.5, 0.5, 0.5]) {
		_bearing(d, D, w, pos, rot);
	}
}


bearing(model=608, pos=[10, 10, 10], rot=[0, 90, 45]);


