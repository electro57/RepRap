use <../lib/rounded_cube.scad>

EPSILON = 0.01;

PLATE_D = 95;
PLATE_d = 25;
PLATE_H = 1.25;

MIRROR_POS_D = 70;

MIRROR_W = 30;
MIRROR_H = 15;
MIRROR_T = 5;

MIRROR_SUPPORT_D = MIRROR_POS_D + 15;
MIRROR_SUPPORT_d = 33.25;
MIRROR_SUPPORT_H = 3;

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


module mirrors_bottom_support()
{
    difference() {
        rotate([0, 0, 360/7/2]) {
            difference() {
                cylinder(d=MIRROR_SUPPORT_D*1.1, h=MIRROR_SUPPORT_H, center=false, $fn=7);
                translate([0, 0, -EPSILON]) {
                    cylinder(d=MIRROR_SUPPORT_d, h=MIRROR_SUPPORT_H+2*EPSILON, center=false);
                }
            }
        }
        for (z=[0:360/7:360]) {
            rotate([0, 0, z]) {
                translate([MIRROR_POS_D/2-MIRROR_T/2, -MIRROR_W/2, -EPSILON+0.5]) {
                    cube([MIRROR_T, MIRROR_W, MIRROR_SUPPORT_H+2*EPSILON], center=false);
                }
            }
        }

        // Fixating holes
        for (z=[0:360/7:360]) {
            rotate([0, 0, z]) {
                translate([28, 0, -EPSILON]) {
                    cylinder(d=3.5, h=MIRROR_SUPPORT_H+2*EPSILON, center= false);
                }
            }
        }
    }
    
    // Mirror bottom support
    for (z=[0:360/7:360]) {
        rotate([0, 0, z]) {
            translate([MIRROR_POS_D/2, 0, 0]) {
                difference() {
                    rotate([90, 0, 0]) {
                        cylinder(d=2, h=MIRROR_W, center=true);
                    }
                    translate([0, 0, -3/2]) {
                        cube([MIRROR_T, MIRROR_W, 3], center=true);
                    }
                }
            }
        }
    }
}


module mirrors_top_support()
{
    difference() {
        union() {
            rotate([0, 0, 360/7/2]) {
                difference() {
                    cylinder(d=MIRROR_SUPPORT_D*1.1, h=MIRROR_SUPPORT_H, center=false, $fn=7);
                    translate([0, 0, -EPSILON]) {
                        cylinder(d=MIRROR_SUPPORT_d+15, h=MIRROR_SUPPORT_H+2*EPSILON, center=false);
                    }
                }
            }
    
            // Pushers
            for (z=[0:360/7:360]) {
                rotate([0, 0, z]) {
                    translate([MIRROR_POS_D/2+MIRROR_T/2+1/2+4.12/2, 0, 0]) {  // Beuh!
                        rcube([4.12, 6, 5], [2, 0, 0], center=true);
                    }
                    translate([MIRROR_POS_D/2-MIRROR_T/2-1/2-4.12/2, 0, 0]) {  // Beuh!
                        *rcube([4.12, 6, 5], [2, 0, 0], center=true);
                    }
                }
            }
        }
        
        // Mirrors space
        for (z=[0:360/7:360]) {
            rotate([0, 0, z]) {
                translate([MIRROR_POS_D/2-(MIRROR_T+1)/2, -MIRROR_W/2, -EPSILON]) {
                    cube([MIRROR_T+1, MIRROR_W, MIRROR_SUPPORT_H-1], center=false);
                }
            }
        }

        // Fixating holes
        for (z=[0:360/7:360]) {
            rotate([0, 0, z]) {
                translate([28, 0, -EPSILON]) {  // Beuh!
                    cylinder(d=3.5, h=MIRROR_SUPPORT_H+2*EPSILON, center=false);
                }
            }
        }

        // Pushers holes
        for (z=[0:360/7:360]) {
            rotate([0, 0, z]) {
//                translate([MIRROR_POS_D/2+MIRROR_T/2, 0, 0]) {
//                    rotate([0, 90, 0]) {
//                        cylinder(d=1.5, h=20, center=true);
//                    }
//                }
                translate([MIRROR_POS_D/2+MIRROR_T/2+2.5, 0, 0]) {
                    rotate([0, 90, 0]) {
                        cylinder(d=1.5, h=5, center=true);
                    }
                }
            }
        }
    }
}


module mirrors()
{
    for (z=[0:360/7:360]) {
        rotate([0, 0, z]) {
            translate([MIRROR_POS_D/2-MIRROR_T/2, -MIRROR_W/2, 0]) {
                cube([MIRROR_T, MIRROR_W, MIRROR_H], center=false);
            }
        }
    }
}



module display()
{
    translate([0, 0, 15]) mirrors_bottom_support();
    translate([0, 0, 15+15]) mirrors_top_support();
    translate([0, 0, 15+1]) %mirrors();
    
    color("gray") motor();
    color("moccasin") plate();
}


display();

//mirrors_bottom_support();
//rotate([0, 180, 0]) mirrors_top_support();

