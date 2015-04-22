use <../lib/rounded_cube.scad>
use <../lib/bearing.scad>

EPSILON = 0.01;

EXTRUDER_W = 15;
ARM_W = 11;

FILAMENT_D = 1.75;
FILAMENT_Y_SHIFT = -(10 + FILAMENT_D) / 2;

HOTEND_R = 16.5 / 2;
HOTEND_UP_RING_H = 4.5;  // GRRF=3.6, Paoparts=4.5

MK7_W = 11;
MK7_W1 = 7.5;
MK7_W2 = 3.5;
MK7_R = 6.35;

CUT = false;
CUT_BODY = true;
CUT_ARM = true;

CUT_VITAMINS = false;
CUT_MOTOR = false;
CUT_MK7 = false;
CUT_PUSHER_BEARING = true;
CUT_HOTEND = false;
CUT_FAN_MOUNT = false;

$fs=0.5;
$fa=2.5;


module body()
{
    difference() {
        color("yellow") {
            difference() {
    
                // base
                rotate([90, 0, 0]) {
                    rotate([0, -90, 0]) {
                        linear_extrude(height=EXTRUDER_W, center=true, convexity=5) {
                            import(file="main.dxf", layer="body");
                        }
                    }
                }
            
                // motor centering
                translate([EXTRUDER_W/2-2, 0, 0]) {
                    rotate([0, 90, 0]) {
                        cylinder(d=19, h=2+EPSILON, center=false);
                    }
                }
            
                // motor fixating
                for (angle=[-90, 0, 90]) {
                    rotate([angle, 0, 0,]) {
                        translate([0, 26/2, 0]) {
                            rotate([0, 90, 0]) {
                                *cylinder(d=3, h=EXTRUDER_W+2*EPSILON, center=true);
                            }
                        }
                    }
                }
        
                // filament hole
                translate([0, FILAMENT_Y_SHIFT, 0]) {
                    *cylinder(d=4, h=20, center=false);  // with PTFE
                    cylinder(d=2.5, h=20, center=false);  // without PTFE
                    mirror([0, 0, 1]) {
                        cylinder(d=6, h=30, center=false);
                    }
                }
        
                // MK7 hole
                rotate([0, 90, 0]) {
                    *cylinder(d=13.5, h=EXTRUDER_W+2*EPSILON, center=true);
                }
            
                // hotend hole
                translate([0, FILAMENT_Y_SHIFT, -25-EPSILON]) {
                    cylinder(d=16, h=9, center=false);
                }
                for (y=[-7, 7]) {
                    translate([0, FILAMENT_Y_SHIFT+y, -16-HOTEND_UP_RING_H]) {
                        rotate([0, 90, 0]) {
                            cylinder(d=3, h=EXTRUDER_W+EPSILON*2, center=true);
                        }
                    }
                }
        
                // pusher screw hole
                translate([0, -17.5+EPSILON, 8]) {
                    rotate([90, 0, 0]) {
                        cylinder(d=3, h=15, center=false);
                        cylinder(d=5.5*2/sqrt(3), h=4, center=false, $fn=6);
                    }
                }
        
                // mounting holes
                for (z=[-7.5, 7.5]) {
                    translate([0, 17.5-1, z]) {
                        rotate([-90, 0, 0]) {
                            cylinder(d=4, h=5, center=false);
                            cylinder(d=7, h=1+1, center=false);
                        }
                    }
                }
            }
        }

        if (CUT && CUT_BODY) {
            color("gold") cut();
        }
    }
}


module arm()
{
    difference() {
        color("lightgreen") {
            difference() {
        
                // base
                rotate([90, 0, 0]) {
                    rotate([0, -90, 0]) {
                        linear_extrude(height=ARM_W, center=true, convexity=5) {
                            import(file="main.dxf", layer="arm");
                        }
                    }
                }
        
                // pusher bearing hole
                translate([0, -10/2-2-10/2, 0]) {
                    difference() {
                        union() {
                            rotate([0, 90, 0]) {
                                cylinder(d=10+1.5, h=4+0.75*2, center=true);  // 10 is bearing OD, 4 is bearing W, 0.75 is M3 washer W
                            }
                            cube([4+0.75*2, 15, 5], center=true);
                        }
                        translate([4/2, 0, 0]) {
                            rotate([0, 90, 0]) {
                                cylinder(d1=4.5, d2=6, h=0.75, center=false);
                            }
                        }
                        translate([-4/2, 0, 0]) {
                            rotate([0, -90, 0]) {
                                cylinder(d1=4.5, d2=6, h=0.75, center=false);
                            }
                        }
                    }
                }
    
                // pusher screw hole
                translate([0, -17.5-EPSILON, 8]) {
                    rotate([-90, 0, 0]) {
                        cylinder(d1=3.5, d2=3, h=1.5, center=false);
                    }
                }
            }
        }

        if (CUT && CUT_ARM) {
            color("green") cut(EPSILON);
        }
    }
}


module morph(d, w, h, r, step=1)
{
    for (i=[0:step/h:1]) {
        translate([0, 0, h*i-EPSILON]) {
            assign(ratio=h/d+(1-i)*(d-h)/d, radius=d/2-i*(d/2-r)) {
                rcube([d, ratio*d, step+2*EPSILON], radius=[0, 0, radius], center=true);
            }
        }
    }
}
//difference() {
//  translate([0, 0, 6+EPSILON]) cube([30, 30, 12], center=true);
//  morph(d=28, w=17, r=17/2, h=12.5, step=0.25);
//}


module morph2(l1, w1, r1, l2, w2, r2, h, r, step=1)
{
    //render()
    for (i=[0:step/h:1]) {
        translate([0, 0, h*i-EPSILON]) {
            assign(l=l1+i*(l2-l1), w=w1+i*(w2-w1), r=r1+i*(r2-r1), dh=step+2*EPSILON) {

                // base
                linear_extrude(height=dh, center=false) {
                    polygon(points=[
                                    [ l/2  ,  w/2-r],
                                    [ l/2-r,  w/2  ],
                                    [-l/2+r,  w/2  ],
                                    [-l/2  ,  w/2-r],
                                    [-l/2  , -w/2+r],
                                    [-l/2+r, -w/2  ],
                                    [ l/2-r, -w/2  ],
                                    [ l/2  , -w/2+r]
                                    ]);
                }
            
                // corners
                if (l/2 >= r && w/2 >= r) {
                    for (x=[-l/2+r, l/2-r]) {
                        for (y=[-w/2+r, w/2-r]) {
                            translate([x, y, 0]) {
                                cylinder(r=r, h=dh, center=false);
                            }
                        }
                    }
                }
                else {
                    cylinder(r=r, h=dh, center=false);
                }
            }
        }
    }
}
//difference() {
//  translate([0, 0, 6]) cube([30, 30, 12], center=true);
//  morph2(l1=28, w1=28, r1=28/2, l2=28, w2=17, r2=17/2, h=12.5, step=0.25);
//}


module fan_mount(print=false)
{
    difference() {
        color("lightcoral") {
            translate([0, FILAMENT_Y_SHIFT, -40.5]) {
                difference() {
            
                    // base
                    union() {
                        translate([15/2-3, 0, 0]) {
                            rcube([15, 30, 30], radius=[2, 0, 0], center=true);
                        }
                        translate([9.75, 0, 17]) {
                            rcube([4.5, 22, 14], radius=[2, 0, 0], center=true);
                        }
                    }

                    // hotend hole
                    cylinder(d=17, h=50, center=true);

                    // fan hole
                    translate([-EPSILON, 0, 0]) {
                        rotate([0, 90, 0]) {
                            if (print) {
                                translate([0, 0, 12.5])
                                mirror([0, 0, 1])
                                morph(d=28, w=17, h=17, r=2, step=0.25);  // h=12.5
                            }
                            else {
                                cylinder(d1=17, d2=28, h=12.5, center=false);
                                scale([1, 17/28, 1])
                                    cylinder(d=28, h=12.5, center=false);
                            }
                        }
                    }

                    // mounting fan holes
                    for (y=[-12, 12]) {
                        for (z=[-12, 12]) {
                            translate([12+EPSILON, y, z]) {
                                rotate([0, -90, 0]) {
                                    cylinder(d=2, h=10, center=false);
                                }
                            }
                        }
                    }

                    // mountings holes
                    for (y=[-7, 7]) {
                        translate([12+EPSILON, y, 15+5]) {
                            rotate([0, -90, 0]) {
                                rotate([0, 0, 15]) {
                                    cylinder(d=5.5*2/sqrt(3), h=2.5, center=false, $fn=6);
                                }
                                translate([0, 0, 2.5+0.25]) {
                                    cylinder(d=3, h=3, center=false);
                                }
                            }
                        }
                    }
                }
            }
        }

        if (CUT && CUT_FAN_MOUNT) {
            *color("crimson") cut(6*EPSILON);
        }
    }
}


module mk7()
{
    difference() {
        color("lightblue") {
            rotate([0, 90, 0]) {
                difference() {
                    translate([0, 0, -7.5]) {
                        difference() {
                            cylinder(r=MK7_R, h=MK7_W, center=false);
                            translate([0, 0, -EPSILON]) {
                                cylinder(d=6, h=MK7_W+2*EPSILON, center=false);
                            }
                        }
                    }
                    rotate_extrude(convexity=5) {
                        translate([7.25, 0, 0]) {
                            circle(r=2.25);
                        }
                    }
                }
            }
        }

        if (CUT_VITAMINS && CUT_MK7) {
            color("cornflowerblue") cut(shift=2*EPSILON);
        }
    }
}


module pusher_bearing()
{
    difference() {
        color("lightblue") {
            bearing(pos=[-4/2, -10/2-2-10/2, 0], angle=[0, 90, 0], model=623);
        }

        if (CUT_VITAMINS && CUT_PUSHER_BEARING) {
            color("cornflowerblue") cut(shift=3*EPSILON);
        }
    }
}


module motor()
{
    difference() {
        color("lightgray") {
            rotate([0, -90, 0]) {
                difference() {
                    union() {
                        translate([0, 0, 34/2]) {
                            rcube([35, 35, 34], radius=[0, 0, 3], center=true);
                        }
                        translate([0, 0, 34]) {
                            cylinder(d=32, h=28, center=false);
                            translate([0, 0, 28]) {
                                cylinder(d=19, h=2, center=false);
                                translate([0, 0, 2]) {
                                    cylinder(d=6, h=18, center=false);
                                }
                            }
                        }
                    }
            
                    // shaft cut
                    translate([2, -5, 34+28+2+0.5+6]) {
                        cube([5, 10, 12], center=false);
                    }
            
                    // shaft hole (for print)
                    translate([0, 0, 34+28+2-10]) {
                        *cylinder(d=6, h=10+EPSILON, center=false);
                    }
            
                    // mounting holes
                    for (angle=[0, 90, 180, 270]) {
                        rotate([0, 0, angle]) {
                            translate([26/2, 0, 34+28-10]) {
                                cylinder(d=2.5, h=10+EPSILON, center=false);
                            }
                        }
                    }
                }
            }
        }

        if (CUT_VITAMINS && CUT_MOTOR) {
            color("gray") cut(shift=4*EPSILON);
        }
    }
}


module hotend()
{
    difference() {
        color("orange") {
            rotate([0, 0, 90]) {
                import("lib/hotend_paoparts.stl", convexity=10);
            }
        }

        if (CUT_VITAMINS && CUT_HOTEND) {
            color("darkorange") cut(shift=5*EPSILON);
        }
    }
}


module vitamins()
{
    translate([0, FILAMENT_Y_SHIFT, 0]) {

        // filament
        color("pink") cylinder(d=FILAMENT_D, h=100, center=true);

        // hotend
        translate([0, 0, -75.65]) hotend();
    
        // PTFE
//        translate([0, 0, 4]) {
//            difference() {
//                %cylinder(d=4, h=25, center=false);
//                %cylinder(d=2, h=25, center=false);
//            }
//        }
        translate([0, 0, -16]) {
            difference() {
                union() {
                    %cylinder(d=6, h=10.5, center=false);
                    translate([0, 0, 10.5]) {
                        %cylinder(d1=6, d2=4, h=2, center=false);
                    }
                }
                %cylinder(d=2, h=12, center=false);
            }
        }
    }

    // MK7
    mk7();

    // motor
    translate([34+28+2+6-0.5, 0, 0]) motor();

    // pusher bearing
    translate([0, -14.5, -10]) rotate([-1.5, 0, 0]) translate([0, 14.5, 10]) pusher_bearing();
}


module cut(shift=0)
{
    translate([-20/2+shift, -5, -10]) {
        cube([20, 60, 140], center=true);
    }
}


module display()
{
    body();
    translate([0, -14.5, -10]) rotate([-1.5, 0, 0]) translate([0, 14.5, 10]) arm();
    fan_mount(print=false);
    vitamins();
}


display();
//vitamins();

//body();
//arm();
//fan_mount(print=true);  // WARNING: very long rendering when 'print' is true

//motor();
