// TowerPro MG-995/995R/996/996R servo mockup

$fs=0.5;
$fa=2.5;

module screwBracket()
{
    difference() {
        union() {
            minkowski() {
                cube([5.25, 17, 1]);
                translate([1, 1, 0]) cylinder(h=1.5, d=2);
            }
            cube([5.25, 19, 2.5]);
            rotate([0, 10, 0]) translate([-1.4, 9, 1.7]) cube([8, 1, 2]);
        }

        // screw holes
        union() {
            translate([4.25, 4.3, -1]) cylinder(h=4, d=4.5);
            translate([4.25, 14.8, -1]) cylinder(h=4, d=4.5);
            translate([5, 3, -1]) cube([2.5, 2.5, 4]);
            translate([5, 13.5, -1]) cube([2.5, 2.5, 4]);
        }
    }
}


module TorqueMount()
{
    difference() {
        union() {
            translate([0, 0, 2.7]) cylinder(h=2, d=20);
            cylinder(h=4.7, d=9);
        }
        translate([0, 0, -1])cylinder(h=8, d=4.5);
        translate([7, 0, 2]) cylinder(h=4, d=3);
        rotate([0, 0, 90]) translate([7, 0, 2]) cylinder(h=4, d=3);
        rotate([0, 0, 180]) translate([7, 0, 2]) cylinder(h=4, d=3);
        rotate([0, 0, 270]) translate([7, 0, 2]) cylinder(h=4, d=3);
    }
}


module WireTerminal()
{
    translate([40, 6.5, 4]) cube([5, 7, 4]);
    translate([40, 7.5, 5.5]) cube([7, 5, 1]);
}


module MG995()
{
    translate([-10, -10, -28]) {
        
        // main part
        cube([40.5, 20, 36.5]);
        translate([40.5, 0.5, 28]) screwBracket();
        rotate([0, 0, 180]) translate([0, -19.5, 28]) screwBracket();
        translate([10, 10, 36.5]) cylinder(h=2, d=19);
        translate([10, 10, 38.5]) cylinder(h=1, d=13);
        translate([10, 10, 39.5]) cylinder(h=0.5, d=11);
        translate([14, 1.5, 36.5]) cube([21,17,2]);

        // torque connector
        translate([10,10,40]) cylinder(h=4.5, d=5);

        // silver torque disc
        *translate([10, 10, 40.5]) TorqueMount();

        //red wire terminal
        rotate([0,0,180]) translate([-42,-20,0]) WireTerminal();
    }
}


MG995();
