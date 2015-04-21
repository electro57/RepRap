// TowerPro SG90 servo mockup


$fs = 0.5;
$fa = 2.5;

//    L = 22.8;
//    l = 12.6;
//    h = 22.8;
//    plateL = 32.5;
//    plateH = 2.7;
//    plateHPos = 16;
//    topCylinderH = 3.4;
//    smallTopCylinderD = 4.5;
//    
//    axisH = 2;
//    axisD = 4;
//    
//    screwHoleCenter=2;
//    screwHoleD=2;
//    holeSize=1;

L = 22.8;
l = 12.6;
H = 22.8;
PLATE_L = 32.5;
PLATE_H = 2.7;
PLATE_H_POS = 16;
TOP_CYLINDER_H = 3.4;
SMALL_TOP_CYLINDER_D = 4.5;

AXIS_H = 2;
AXIS_D = 4;

SCREW_HOLE_CENTER = 2;
SCREW_HOLE_D = 2;
HOLE_SIZE = 1;

$fs = 0.5;
$fa = 2.5;


module SG90()
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


SG90();
