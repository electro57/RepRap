// Cube with rounded edges on all sides
// The first parameters defines the size of the cube (array)
// The second parameter defines the edges radius along each axis (array)
//
// Thanks to hagen from OpenSCAD mailing list for this optimize solution

//rcube(size=[25, 25, 10], radius=[1, 1, 5], center=true, $fn=32);


module _rsquare(size=[1, 1], radius=0) {
	assign(sx=size[0], sy=size[1], r=min(radius, size[0]/2, size[1]/2)) {
		if (r == 0) {
			square(size=[sx, sy], center=true);  // not rounded
		}
		else {
			hull() {
				for (corner=[[sx/2-r, sy/2-r], [-sx/2+r, sy/2-r], [sx/2-r, -sy/2+r], [-sx/2+r, -sy/2+r]]) {
					translate(corner) {
						circle(r=r);
					}
				}
			}
		}
	}
}


module _rcube(size=[1, 1, 1], radius=[0, 0, 0]) {
	assign(sx=size[0], sy=size[1], sz=size[2], rx=radius[0], ry=radius[1], rz=radius[2]) {
		translate([sx/2, sy/2, sz/2]) {
			intersection() {
				rotate([90, 0, 0]) {
					rotate([0, 90, 0]) {
						linear_extrude(height=sx, center=true) {
							_rsquare(size=[sy, sz], radius=rx);
						}
					}
				}
	            rotate([90, 0, 0]) linear_extrude(height=sy, center=true) {
					_rsquare(size=[sx, sz], radius=ry);
				}
	            linear_extrude(height=sz, center=true) {
					_rsquare(size=[sx, sy], radius=rz);
				}
			}
        }
    }
}


module rcube(size=[1, 1, 1], radius=[0, 0, 0], center=true) {
	if (!center) {
		_rcube(size=size, radius=radius);
	}
	else {
		assign(sx=size[0], sy=size[1], sz=size[2]) {
			translate([-sx/2, -sy/2, -sz/2]) {
				_rcube(size, radius=radius);
			}
		}
	}
}


//module rcube(size=[1, 1, 1], radius=[0, 0, 0], center=true) {
//	assign(sx=size[0], sy=size[1], sz=size[2], rx=radius[0], ry=radius[1], rz=radius[2]) {
//		intersection() {
//
//			// Radius on X axis
//			rotate([0, 90, 0])
//			linear_extrude(height=sx, center=center) {
//				minkowski() {
//					square([sz-2*rx, sy-2*rx], center=center);
//					scale([rx, rx]) circle(1);
//				}
//			}
//
//			// Radius on Y axis
//			rotate([90, 0, 0])
//			linear_extrude(height=sy, center=center) {
//				minkowski() {
//					square([sx-2*ry, sz-2*ry], center=center);
//					scale([ry, ry]) circle(1);
//				}
//			}
//
//			// Radius on Z axis
//			linear_extrude(height=sz, center=center) {
//				minkowski() {
//					square([sx-2*rz, sy-2*rz], center=center);
//					scale([rz, rz]) circle(1);
//				}
//			}
//		}
//	}
//}
