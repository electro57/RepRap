use <../lib/rounded_cube.scad>

EPSILON = 0.05;

PLATE_D = 95;
PLATE_d = 25;
PLATE_H = 1.25;

MIRROR_POS_D = 72;

MIRROR_W = 30.5;
MIRROR_H = 15;
MIRROR_T = 5;

MIRROR_SUPPORT_D = MIRROR_POS_D + 15;
MIRROR_SUPPORT_d = 33.25;
MIRROR_SUPPORT_T = 2;

$fs=0.5;
$fa=2.5;

PRINT = true;
SUPPORT_W = 0.5;
LAYER_H = 0.2;


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
        rotate([0, 0, 360/7/2]) {
            difference() {
                cylinder(d=PLATE_D, h=MIRROR_H, center=false, $fn=7);
                translate([0, 0, -EPSILON]) {
                    cylinder(d=MIRROR_SUPPORT_d, h=MIRROR_SUPPORT_T+2*EPSILON, center=false);
                }
                translate([0, 0, MIRROR_SUPPORT_T]) {
                    cylinder(d=PLATE_D-25, h=MIRROR_H-MIRROR_SUPPORT_T+EPSILON, center=false, $fn=7);
                }
            }
        }
        
        // Mirrors horizontal windows
        for (z=[0:360/7:360]) {
            rotate([0, 0, z]) {
                difference() {
                    translate([MIRROR_POS_D/2-MIRROR_T/2, -MIRROR_W/2, MIRROR_SUPPORT_T]) {
                        cube([PLATE_D/2-MIRROR_POS_D/2, MIRROR_W, MIRROR_H-2*MIRROR_SUPPORT_T], center=false);
                    }
    
                    // Pushers
                    translate([MIRROR_POS_D/2+MIRROR_T/2+4.3, -MIRROR_W/4, MIRROR_SUPPORT_T]) {
                        rotate([0, -90, 0]) {
                            cylinder(d=MIRROR_SUPPORT_T*2, h=4.3, center=false);
                        }
                    }
                    translate([MIRROR_POS_D/2+MIRROR_T/2+4.3, 0, MIRROR_SUPPORT_T]) {
                        rotate([0, -90, 0]) {
                            cylinder(d=MIRROR_SUPPORT_T*2, h=4.3, center=false);
                        }
                    }
                    translate([MIRROR_POS_D/2+MIRROR_T/2+4.3, MIRROR_W/4, MIRROR_SUPPORT_T]) {
                        rotate([0, -90, 0]) {
                            cylinder(d=MIRROR_SUPPORT_T*2, h=4.3, center=false);
                        }
                    }
                }
            }
        }

        // Mirrors vertical windows
        for (z=[0:360/7:360]) {
            rotate([0, 0, z]) {
                translate([MIRROR_POS_D/2, 0, MIRROR_H]) {
                    rotate([0, -1, 0]) {  // forward
                        translate([0, 0, -MIRROR_H/2]) {
                            cube([MIRROR_T, MIRROR_W, MIRROR_H+0.5], center=true);
                        }
                    }
                    rotate([0, 1, 0]) {  // backward
                        translate([0, 0, -MIRROR_H/2]) {
                            cube([MIRROR_T, MIRROR_W, MIRROR_H+0.5], center=true);
                        }
                    }
                }
            }
        }

        // Fixating holes
        for (z=[0:360/7:360]) {
            rotate([0, 0, 360/7/2+z]) {
                translate([30, 0, -EPSILON]) {
                    cylinder(d=3.5, h=MIRROR_SUPPORT_T+2*EPSILON, center= false);
                }
            }
        }
 
        // Pushers holes
        for (z=[0:360/7:360]) {
            rotate([0, 0, z]) {
                translate([MIRROR_POS_D/2+MIRROR_T/2+2.5, -MIRROR_W/4, MIRROR_SUPPORT_T]) {
                    rotate([0, 90, 0]) {
                        cylinder(d=2, h=5, center=true);
                    }
                }
                translate([MIRROR_POS_D/2+MIRROR_T/2+2.5, 0, MIRROR_SUPPORT_T]) {
                    rotate([0, 90, 0]) {
                        cylinder(d=2, h=5, center=true);
                    }
                }
                translate([MIRROR_POS_D/2+MIRROR_T/2+2.5, MIRROR_W/4, MIRROR_SUPPORT_T]) {
                    rotate([0, 90, 0]) {
                        cylinder(d=2, h=5, center=true);
                    }
                }
            }
        }
    }
                    
    // Support
    if (PRINT) {
         for (z=[0:360/7:360]) {
            rotate([0, 0, z]) {
                translate([MIRROR_POS_D/2+MIRROR_T/2, -MIRROR_W/4-SUPPORT_W/2, 2*MIRROR_SUPPORT_T]) {
                    cube([4.3, SUPPORT_W, MIRROR_H-2*MIRROR_SUPPORT_T-MIRROR_SUPPORT_T-LAYER_H], center=false);
                }
                translate([MIRROR_POS_D/2+MIRROR_T/2, -SUPPORT_W/2, 2*MIRROR_SUPPORT_T]) {
                    cube([4.3, SUPPORT_W, MIRROR_H-2*MIRROR_SUPPORT_T-MIRROR_SUPPORT_T-LAYER_H], center=false);
                }
                translate([MIRROR_POS_D/2+MIRROR_T/2, MIRROR_W/4-SUPPORT_W/2, 2*MIRROR_SUPPORT_T]) {
                    cube([4.3, SUPPORT_W, MIRROR_H-2*MIRROR_SUPPORT_T-MIRROR_SUPPORT_T-LAYER_H], center=false);
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
    translate([0, 0, 15]) mirrors_support();
    *translate([0, 0, 15]) %mirrors();
    
    color("gray") motor();
    color("moccasin") plate();
}


display();

//mirrors_support();
