
$fs=0.5;
$fa=2.5;


module servo_bracket_1_top()
{
    difference() {
        linear_extrude(height=5, convexity=3) {
            import(file="main.dxf", layer="0");
        }
        cylinder(d=3, h=5);
        cylinder(d=5.5, h=4);
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


module servo_test()
{
    difference() {
        cylinder(d=10, h=4);
        cylinder(d=6, h=3);
        cylinder(d=3, h=4);
    }
}


//servo_bracket_1_top();
//servo_bracket_1_bottom();
servo_test();