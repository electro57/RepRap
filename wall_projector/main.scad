use <../lib/rounded_cube.scad>

EPSILON = 0.01;

$fs=0.5;
$fa=2.5;


module motor()
{
    difference() {
        union() {
            cylinder(d1=34, d2=36, h=1, center=false);
            translate([0, 0, 1]) {
                cylinder(d=36, h=3.5, center=false);
                translate([0, 0, 3.5]) {
                    cylinder(d1=36, d2=38, h=1 ,center=false);
                    translate([0, 0, 1]) {
                        cylinder(d=38, h=1.5, cetner=false);
                        translate([0, 0, 1.5]) {
                            cylinder(d=52, h=1.65, center=false);
                            translate([0, 0, 1.65]) {
                                cylinder(d=33, h=5, center=false);
                                translate([0, 0, 5]) {
                                    cylinder(d=25, h=1, center=false);
                                    translate([0, 0, 1]) {
                                        cylinder(d=15, h=1, center=false);
                                        translate([0, 0, 1]) {
                                            cylinder(d=14.8, h=3, center=false);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // Bottom hole
        translate([0, 0, -EPSILON]) {
            cylinder(d=9.5, h=3.5+2*EPSILON, center=false);
            translate([0, -15/2-6.5, 0]) {
                cube([20, 15, 2], center=true);
            }
        }

        // Fixating holes
        translate([0, 0, 7-EPSILON]) {
            for (z=[0:120:240]) {
                rotate([0, 0, z]) {
                    translate([23, 0, 0]) {
                        cylinder(d=3.5, h=1.65+2*EPSILON, center= false);
                    }
                }
            }
        }
        
        // Other holes
        translate([0, 0, 15-6-EPSILON]) {
            for (z=[0:60:300]) {
                rotate([0, 0, z]) {
                    translate([10.5, 0, 0]) {
                        cylinder(d=2, h=6+2*EPSILON, center= false);
                    }
                }
            }
        }
    }
}


module plate()
{
    translate([0, 0, 13.65]) {
        difference() {
            cylinder(d=95, h=1.25, center=false);
            translate([0, 0, -EPSILON]) {
                cylinder(d=25, h=1.25+2*EPSILON, center=false);
            }
        }
    }
}



module mirrors_support()
{
    difference() {
        union() {
            difference() {
                cylinder(d=60, h=10, center=false);
                for (i=[0:6]) {
                    rotate([0, 0, i*360/7]) {
                        translate([25, -40/2, -(15-10)/2-EPSILON]) {
                            rotate([0, (i-3)*0.5, 0])
                            cube([20, 40, 15+2*EPSILON], center=false);
                        }
                    }
                }
            }
        }
        translate([0, 0, -EPSILON]) {
            cylinder(d=33.5, h=3.65, center=false);
            cylinder(d=15.5, h=5, center=false);
            cylinder(d=15, h=12, center=false);
        }
        translate([0, 0, 3.65-EPSILON]) {
            for (z=[0:120:300]) {
                rotate([0, 0, z]) {
                    translate([10.5, 0, 0]) {
                        *cylinder(d=2.5, h=10, center= false);
                    }
                }
            }
        }
        translate([0, 0, 10]) {
            *cylinder(d=50, h=15, center=false);
        }
    }
}


module mirrors()
{
    for (z=[0:360/7:360]) {
        rotate([0, 0, 360/7/2+z]) {
            translate([35-5/2, -30/2, 0]) {
                cube([5, 30, 15], center=false);
            }
        }
    }
}


difference() {
    union() {
        *translate([0, 0, 11]) mirrors_support();
        translate([0, 0, 15]) color("white") mirrors();
        
        color("gray") motor();
//        color("moccasin")
            %plate();
    }
    *translate([0, 0, -EPSILON]) cube([100, 100, 100], center=false);
}
