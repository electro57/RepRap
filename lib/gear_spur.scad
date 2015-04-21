// gear_spur module
//
// derivated from "publicDomainGearV1.1"
// http://www.thingiverse.com/thing:5505
// by Leemon Baird, 2011, Leemon@Leemon.com
// see this module for more informations

$fs=0.5;
$fa=2.5;

// TODO: replace twist param with beta angle ; manage real module vs apparent module


/////////////////////////////////////////// API ///////////////////////////////////////////

// m                    gear module
// Z                    total number of teeth around the entire perimeter
// h                    height of gear
// D                    external diameter of the gear
// center               true to center the gear on Z axis
// twist                teeth rotate this many degrees from bottom of gear to top
//                      360 makes the gear a screw with each thread going around once
// teeth_to_hide        number of teeth to delete to make this only a fraction of a circle
// pressure_angle       controls how straight or bulged the tooth sides are
//
module external_gear_spur(m, Z, h, center=true, twist=0, teeth_to_hide=0, pressure_angle=20)
{
    external_gear_spur_(m, Z, h, center, twist, teeth_to_hide, pressure_angle);
}

module internal_gear_spur(m, Z, h, D, center=true, twist=0, teeth_to_hide=0, pressure_angle=20)
{
    internal_gear_spur_(m, Z, h, D, center, twist, teeth_to_hide, pressure_angle);
}

module flat_gear_spur(m, Z, h, e, center=true, twist=0, pressure_angle=20)
{
    flat_gear_spur_(m, Z, h, e, center, twist, pressure_angle);
}


/////////////////////////////////////////// Examples ///////////////////////////////////////////

module example_1()
{
    assign(m=1, Z1=33, Z2=11, h=3) {
        rotate([0, 0, 180/Z1])
            internal_gear_spur(m, Z1, h, D=40);
        
        translate([0, (Z1-Z2)/2, 0])
            color("red") external_gear_spur(m, Z2, h);
    }
}

// Use FPS=10, Steps=36
module example_2()
{
    assign(m=1, Z1=33, Z2=11, h=3) {
        rotate([0, 0, 180/Z1+100*$t*Z2/Z1])
            internal_gear_spur(m, Z1, h, D=40);
        
        translate([0, (Z1-Z2)/2, 0])
            rotate([0, 0, 100*$t])
                color("red") external_gear_spur(m, Z2, h);
    }
}

module example_3()
{
    assign(m=1, Z=55, h1=2, h2=5.5, D=63) {
        difference() {
            union() {
                translate([0, 0, -h1]) {
                    cylinder(r=D/2, h=h1);
                }
                internal_gear_spur(m, Z, h2, D, center=false);
                cylinder(r=8, h=8);
            }
            cylinder(r=6.5/2, h=25, center=true);
        }
    }
}

module example_4()
{
    assign(m=1, Z=20, h=5, e=1) {
        flat_gear_spur(m, Z, h, e);
        translate([0, m*Z/2, 0]) external_gear_spur(m, Z, h);
    }
}

//example_1();
//example_2();
//example_3();
//example_4();


/////////////////////////////////////////// Lib ///////////////////////////////////////////

module external_gear_spur_(m, Z, h, center, twist, teeth_to_hide, pressure_angle)
{
    assign(p = m * Z / 2)    // radius of pitch circle (primitif)
    union() {

        // base cylinder
        assign(r = p - 1.25 * m)    // radius of root circle (pied)
        cylinder(r=r, h=h, center=center);

        // teeth
        for (i = [0:Z-teeth_to_hide-1]) {
            rotate([0, 0, i*360/Z]) {
                linear_extrude(height=h, center=center, convexity=1, twist=twist) {
                    gear_spur_tooth_2D(p, m, pressure_angle);
                }
            }
        }
    }
}


module internal_gear_spur_(m, Z, h, D, center, twist, teeth_to_hide, pressure_angle)
{
    assign(p = m * Z / 2)    // radius of pitch circle (primitif)
    union() {

        // base cylinder
        assign(r = p + 1.25 * m)    // radius of root circle (pied)
        if (center == true) {
            difference() {
                cylinder(r=D/2, h=h, center=center);
                cylinder(r=r, h=h+0.1, center=center);
            }
        }
        else {
            difference() {
                cylinder(r=D/2, h=h, center=center);
                translate([0, 0, -0.1/2]) {
                    cylinder(r=r, h=h+0.1, center=center);
                }
            }
        }

        // teeth
        for (i = [0:Z-teeth_to_hide-1]) {
            rotate([0, 0, i*360/Z]) {
                linear_extrude(height=h, center=center, convexity=1, twist=twist) {
                    translate([0, m * Z / 2, 0]) mirror([0, 1, 0]) translate([0, -m * Z / 2, 0]) {
                        gear_spur_tooth_2D(p, m, pressure_angle);
                    }
                }
            }
        }
    }
}


module flat_gear_spur_(m, Z, h, e, center, twist, pressure_angle)
{
    assign(p = m * Z / 2)   // radius of pitch circle (primitif)
    assign(step = PI * m)   // teeth step
    union() {

        // base
        if (center) {
            translate([0, -1.25*m-e/2, 0]) {
                cube([(Z-0.585)*step, e, h], center=true);
            }
        }
        else {
            translate([0, -1.25*m-e/2, h/2]) {
                cube([(Z-0.585)*step, e, h], center=true);
            }
        }

        // teeth
        for (i = [0:Z-1]) {
            translate([(-(Z-1)/2+i)*step, -p, 0]) {
                linear_extrude(height=h, center=center, convexity=1, twist=twist) {
                    gear_spur_tooth_2D(p, m, pressure_angle);
                }
            }
        }
    }
}


module gear_spur_tooth_2D(p, m, pressure_angle=20)
{
    assign(Z = p / m)                                    // number of teeth
    assign(c = p + m)                                    // radius of outer circle (tête)
    assign(b = p * cos(pressure_angle))                  // radius of base circle (base de la dent)
    assign(r = p - 1.25 * m)                             // radius of root circle (pied)
    assign(t = m * PI / 2)                               // tooth width at pitch circle
    assign(k = -iang(b, p) - t / 2 / p / PI * 180)       // angle to where involute meets base circle on each side of tooth
    polygon(
        points=[
            polar(r, r < b ? k : -180/Z),
            q7(0/5, r, b, c, k,  1), q7(1/5, r, b, c, k,  1), q7(2/5, r, b, c, k,  1),
            q7(3/5, r, b, c, k,  1), q7(4/5, r, b, c, k,  1), q7(5/5, r, b, c, k,  1),
            q7(5/5, r, b, c, k, -1), q7(4/5, r, b, c, k, -1), q7(3/5, r, b, c, k, -1),
            q7(2/5, r, b, c, k, -1), q7(1/5, r, b, c, k, -1), q7(0/5, r, b, c, k, -1),
            polar(r, r < b ? -k : 180/Z),
        ],
        paths=[[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]]
    );
}


/////////////////////////////////////////// Helpers ///////////////////////////////////////////

// convert polar to cartesian coordinates
function polar(r, theta) = r * [sin(theta), cos(theta)];

// unwind a string this many degrees to go from radius r1 to radius r2
function iang(r1, r2) = sqrt((r2 / r1) * (r2 / r1) - 1) / PI * 180 - acos(r1 / r2);

// point at radius d on the involute curve
function q6(b, s, t, d) = polar(d, s * (iang(b, d) + t));

// radius a fraction f up the curved side of the tooth
function q7(f, r, b, r2, t, s) = q6(b, s, t, (1 - f) * max(b, r) + f * r2);







































/////////////////////////////////////////// Doc ///////////////////////////////////////////

// Wikipedia:
//
// Roue dentée normalisée (alpha = 20°)
//
// La forme des dents est normalisée (le profil et les proportions entre la hauteur et la largeur).
// On définit une valeur appelée « module » et notée m qui caractérise entièrement la géométrie de la dent :
//
//    la largeur de la dent au niveau du cercle primitif est PI * m / 2 ;
//    la hauteur de la dent est 2.25 * m ;
//    si h est la hauteur d'une dent, le cercle primitif est à 0.56 * h du bas de la dent (cercle de pied) et à 0.44 * h du sommet
//    (cercle de tête).
//
// Le module représente de fait :
//
//    le diamètre du cercle primitif (ou diamètre primitif) divisé par le nombre de dents : m = D / Z ;
//    la hauteur des dents divisée par 2.25 : m = h / 2.25.
//
// La donnée de m et de z caractérise la roue dentée normalisée d'un point de vue cinématique.
// Roue à denture droite normale
//
//    diamètre primitif D = m * Z
//    pas p = m / PI
//    saillie h_a = m
//    creux h_f = 1.25 * m
//    hauteur de dents h = h_a + h_f = 2.25 * m
//    diamètre de tête D_a = D + 2 * h_a= D + 2 * m
//    diamètre de pied D_f = D - 2 * h_f = D - 2.5 * m
//    diamètre de base D_b = D / cos(alpha)
//
// Roue à denture hélicoïdale
//
// Dans le cas d'une denture hélicoïdale, on distingue le module réel du module apparent :
//
//    le module réel mn correspond à une coupe droite de la dent, une coupe par un plan perpendiculaire aux arêtes ;
//    le module apparent mt correspond à une coupe par un plan perpendiculaire à l'axe de la roue.
//
// Si l'on appelle beta l'inclinaison de l'hélice, on a :
//
//    mt = mn / cos(beta).
//
// On a donc :
//
//    diamètre primitif : d = mt * Z ;
//    diamètre de tête : D_a = D + 2 * mn
