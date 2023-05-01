use <Choc_Chicago_Steno.scad>
spru_n = 2;
spacing = 18.0 ;
spru_radius = 0.8;

union() {
//    translate([0, -spacing * 0, 0])  cs_spru(row=2);
//    translate([0, -spacing * 1, 0])  cs_spru(row=2, width=1.25);
//    translate([0, -spacing * 2, 0])  cs_spru(row=2, width=1.50);
//    translate([0, -spacing * 3, 0])  cs_spru(row=2, width=1.75);
//    translate([0, -spacing * 4, 0])  cs_spru(row=2, width=2.00);
//    translate([0, -spacing * 5, 0])  cs_spru(row=2, width=2.25);
//    translate([0, -spacing * 0, 0])  cs_spru(row=3);
//    translate([0, -spacing * 1, 0])  cs_spru(row=3, width=1.25);
//    translate([0, -spacing * 2, 0])  cs_spru(row=3, width=1.50);
//    translate([0, -spacing * 3, 0])  cs_spru(row=3, width=1.75);
//    translate([0, -spacing * 4, 0])  cs_spru(row=3, width=2.00);
//    translate([0, -spacing * 5, 0])  cs_spru(row=3, width=2.25);
}

module cs_spru(row, dot=false, n=spru_n, width=1, radius=spru_radius) {
    echo ("Row", row, "width", width);
    union() {
        for (i = [0 : n - 1]){
            translate([i * spacing * width, 0, 0])
            mirror([0,0,0])
            cs_keycap(row=row, width=width, dot=dot);
        }

        for (i = [0 : n - 1 - 1]){
            translate([width * spacing / 2 - 1.5, 0, -0.9 * spru_radius])
            rotate([0, 90, 0])
            cylinder(h = 3, r = spru_radius, $fn=15);
        }
    }
}

module cs_keycap(row, width=1, dot=false) {

    if      (row == 2 && width == 1   ) {cs_default( 0);}
    else if (row == 2 && width == 1.25) {cs_default( 5);}
    else if (row == 2 && width == 1.5 ) {cs_default( 7);}
    else if (row == 2 && width == 1.75) {cs_default( 9);}
    else if (row == 2 && width == 2)    {cs_default(11);}
    else if (row == 2 && width == 2.25) {cs_default(13);}

    else if (row == 3 && width == 1   ) {cs_default( 1);}
    else if (row == 3 && width == 1.25) {cs_default( 6);}
    else if (row == 3 && width == 1.5 ) {cs_default( 8);}
    else if (row == 3 && width == 1.75) {cs_default(10);}
    else if (row == 3 && width == 2)    {cs_default(12);}
    else if (row == 3 && width == 2.25) {cs_default(14);}

}

module cs_default(keyID, dot=false) {
    echo("keyID", keyID)
    keycap(
        keyID  = keyID, //change profile refer to KeyParameters Struct
        Stem   = true, //turns on shell and stems
        Dish = true,
        homeDot = dot, //turns on homedots
    );
}


