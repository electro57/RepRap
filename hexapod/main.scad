
$fs=0.5;
$fa=2.5;


module servo_shaft(h)
{
    cylinder(d=5.5, h=h);
    for (a=[0:360/24:360]) {
        rotate([0, 0, a]) {
            translate([5.5/2, 0, 0]) {
                cylinder(d=0.65, h=h, $fn=4);
            }
        }
    }
}


module servo_bracket_1_top()
{
    difference() {
        linear_extrude(height=5, convexity=3) {
            import(file="main.dxf", layer="0");
        }
        cylinder(d=3, h=5);
        servo_shaft(h=4);
        cylinder(d=13.5, h=1);
    }
}


module servo_bracket_1_bottom()
{
    difference() {
        linear_extrude(height=5, convexity=3) {
            import(file="main.dxf", layer="0");
        }
        cylinder(d=7.5, h=5);
        cylinder(d=10.5, h=4);
    }
}


module servo_bracket_1_middle()
{
    difference() {
        cube([42, 20, 5], center=true);
        for (x=[-42/2, 42/2]) {
            for (y=[-6, 6]) {
                translate([x, y, 0]) {
                    rotate([0, 90, 0]) {
                        cylinder(d=2, h=20, center=true);
                    }
                }
            }
        }
    }
}


module servo_test()
{
    difference() {
        cylinder(d=10, h=4);
        servo_shaft();
    }
}


//servo_bracket_1_top();
//servo_bracket_1_bottom();
servo_bracket_1_middle();
//servo_test();