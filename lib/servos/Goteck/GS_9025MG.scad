// Goteck GS-9025MG servo mockup

L = 23.2;
l = 12.2;
H = 23.7;
PLATE_L = 32;
PLATE_H = 2.0;
PLATE_H_POS = 19.3;
TOP_CYLINDER_H = 5;
SMALL_TOP_CYLINDER_D = 6.0;

AXIS_H = 3.4;
AXIS_D = 4.8;

SCREW_HOLE_CENTER = 2;
SCREW_HOLE_D = 2.5;
HOLE_SIZE = 1.5;

$fs = 0.5;
$fa = 2.5;


module GS_9025MG()
{
    translate([-l/2, -l/2, -PLATE_H_POS]) {
        difference() {
            union() {
                    
                // main part
                cube([L, l, H]);
                
                // support
                translate([-(PLATE_L-L) / 2, 0, PLATE_H_POS]) {
                    cube([PLATE_L, l, PLATE_H]);
                }
                
                // top big cylinder
                translate([l/2, l/2, H]) {
                    cylinder(d=l, h=TOP_CYLINDER_H);
                }
                
                // top small cylinder
                translate([l, l/2, H]) { 
                    cylinder(d=SMALL_TOP_CYLINDER_D, h=TOP_CYLINDER_H);
                }
                translate([l/2, l/2, H+TOP_CYLINDER_H]) {
                    cylinder(d=AXIS_D, h=AXIS_H);
                }
            }
            translate([-(PLATE_L-L)/2+SCREW_HOLE_CENTER, l/2, PLATE_H_POS]) {
                cylinder(d=SCREW_HOLE_D, h=10, center=true);
            }
            translate([-(PLATE_L-L)/2-1, l/2-HOLE_SIZE/2, PLATE_H_POS-1]) {
                cube([3,HOLE_SIZE,4]);
            }
            translate([PLATE_L-(PLATE_L-L)/2-SCREW_HOLE_CENTER, l/2, PLATE_H_POS-1]) {
                cylinder(d=SCREW_HOLE_D, h=10, center=true);
            }
            translate([PLATE_L-(PLATE_L-L)/2-SCREW_HOLE_CENTER, l/2-HOLE_SIZE/2, PLATE_H_POS-1]) {
                cube([3, HOLE_SIZE, 4]);
            }
        }
    }
}


GS_9025MG();
//projection(cut=false) rotate([0, -90, 0]) GS_9025MG();