D = 100;
H = 10;
NB_FACES = 7;
FACE_WIDTH = 2 * D / 2 * sin((360 / NB_FACES) / 2) * 0.65;
PROJECTION_DISTANCE = 3000;
LINES_DISTANCES = 3;
MIRROR_ANGLE = asin(LINES_DISTANCES / PROJECTION_DISTANCE);


module test_1()
{
    difference() {
        cylinder(d=D, h=H, center=true, $fn=128);
        cylinder(d=3, h=H+1, center=true, $fn=16);

        for (angle=[0:360/NB_FACES:360-1]) {
            rotate([0, 0, angle]) {
                translate([D/2-7, 0, 0]) {
                    echo(NB_FACES*angle/360*MIRROR_ANGLE);
                    rotate([0, NB_FACES*angle/360*MIRROR_ANGLE, 0]) {
                        union() {
                            translate([10/2, 0, 0]) {
                               cube([10, FACE_WIDTH, 2*H], center=true);
                            }
                            translate([2/2, 0, 0]) {
                               cube([2, FACE_WIDTH+2, 2*H], center=true);
                            }
                        }
                    }
                }
            }
        }
    }
}


module test_2()
{
    difference() {
        cylinder(d=D, h=H, center=true, $fn=128);
        cylinder(d=3, h=H+1, center=true, $fn=16);

        for (angle=[0:360/NB_FACES:360-1]) {
            rotate([0, 0, angle]) {
                translate([D/2-4, 0, 0]) {
                    echo(NB_FACES*angle/360*MIRROR_ANGLE);
                    rotate([0, NB_FACES*angle/360*MIRROR_ANGLE, 0]) {
                        translate([10/2, 0, 0]) {
                           cube([10, 100, 2*H], center=true);
                        }
                    }
                }
            }
        }
    }
}


//test_1();
test_2();
