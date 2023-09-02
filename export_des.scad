use <MX_DES_Standard.scad>
spru_n = 2;
spacing = 19.05;
spru_radius = 0.8;

row=5;
width=1;

des_spru(row=row, width=width, dot=false);

//union() {
//    translate([0, -19 *  0, 0])  des_spru(row=1);
//    translate([0, -19 *  1, 0])  des_spru(row=2);
//    translate([0, -19 *  2, 0])  des_spru(row=3);
//    translate([0, -19 *  3, 0])  des_spru(row=4);
//    translate([0, -19 *  4, 0])  des_spru(row=5);
//
//    translate([0, -19 *  6, 0])  des_spru(row=2, width=1.25);
//  translate([0, -19 *  7, 0])  des_spru(row=3, width=1.25);
//  translate([0, -19 *  8, 0])  des_spru(row=4, width=1.25);
//  translate([0, -19 *  9, 0])  des_spru(row=5, width=1.25);
//
//  translate([0, -19 * 11, 0])  des_spru(row=2, width=1.5);
//  translate([0, -19 * 12, 0])  des_spru(row=3, width=1.5);
//  translate([0, -19 * 13, 0])  des_spru(row=4, width=1.5);
//    translate([0, -19 * 14, 0])  des_spru(row=5, width=1.5);
//
//  translate([0, -19 * 16, 0])  des_spru(row=2, width=1.75);
//  translate([0, -19 * 17, 0])  des_spru(row=3, width=1.75);
//  translate([0, -19 * 18, 0])  des_spru(row=4, width=1.75);
//  translate([0, -19 * 19, 0])  des_spru(row=5, width=1.75);

//  translate([0, -19 * 21, 0])  des_spru(row=5, width=2);
//  translate([0, -19 * 22, 0])  des_spru(row=5, width=2.25);
//  translate([0, -19 * 23, 0])  des_spru(row=5, width=2.75);

//    translate([0, -19 * 25, 0])  des_spru(row=3, dot=true);
//    translate([0, -19 * 0, 0])  des_spru(row=3, ring=true);
//    translate([0, -19 * 26, 0])  des_spru(row=3, deepdish=true);
//    translate([0, -19 * 27, 0])  des_spru(row=3, deepdish=false);
//}

module des_spru(row, dot=false, deepdish=false, n=spru_n, width=1, radius=spru_radius, ring=false) {
    echo ("Row", row, "width", width);
    union() {
        for (i = [0 : n - 1]){
            translate([i * spacing * width, 0, 0])
            mirror([0,0,0])
            des_keycap(row=row, width=width, dot=dot, deepdish=deepdish, ring=ring);
        }

        for (i = [0 : n - 1 - 1]){
            translate([i * width * spacing + spacing / 2 - 3, 5, -0.8 * spru_radius])
            rotate([0, 90, 0])
            cylinder(h = 6, r = spru_radius, $fn=20);
        }
    }
}

module des_keycap(row, width=1, dot=false, deepdish=false, ring=false) {
    if      (row == 1) {rotate([0, 0, 180]) des_standard(5);}

    else if (row == 2 && width == 1   ) {des_standard(2);}
    else if (row == 2 && width == 1.25) {des_standard(9);}
    else if (row == 2 && width == 1.5 ) {des_standard(13);}
    else if (row == 2 && width == 1.75) {des_standard(17);}

    else if (row == 3 && width == 1 && !deepdish) {des_standard(1, dot=dot, ring=ring);}
    else if (row == 3 && deepdish)      {des_standard(3);}
    else if (row == 3 && width == 1.25) {des_standard(8);}
    else if (row == 3 && width == 1.5 ) {des_standard(12);}
    else if (row == 3 && width == 1.75) {des_standard(16);}

    else if (row == 4 && width == 1   ) {des_standard(0);}
    else if (row == 4 && width == 1.25) {des_standard(7);}
    else if (row == 4 && width == 1.5 ) {des_standard(11);}
    else if (row == 4 && width == 1.75) {des_standard(15);}

    else if (row == 5 && width == 1   ) {des_standard(4);}
    else if (row == 5 && width == 1.25) {des_standard(6);}
    else if (row == 5 && width == 1.5 ) {des_standard(10);}
    else if (row == 5 && width == 1.75) {des_standard(14);}
    else if (row == 5 && width == 2   ) {des_standard(18);}
    else if (row == 5 && width == 2.25) {des_standard(23);}
    else if (row == 5 && width == 2.75) {des_standard(31);}
}

module des_standard(keyID, dot=false, ring=false) {
    echo("keyID", keyID)
    keycap(
        keyID  = keyID, //change profile refer to KeyParameters Struct
        Stem   = true, //tusn on shell and stems
        crossSection = false,
        homeDot = dot, //turn on homedots
        homeRing = ring
    );
}


