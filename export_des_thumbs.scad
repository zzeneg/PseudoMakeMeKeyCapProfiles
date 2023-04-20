use <MX_DES_Thumb.scad>

union() {
    for (i = [0:2]) {
        translate([19 * i, 0, 0]) des_default(keyID=i);
    }

    for (i = [3:7]) {
        translate([19 * (i + 1), 0, 0]) des_default(keyID=i);
    }

    for (i = [8:11]) {
        translate([19 * (i + 2), 0, 0]) des_default(keyID=i);
    }

    for (i = [12:18]) {
        translate([19 * (i + 3), 0, 0]) des_default(keyID=i);
    }

    for (i = [20:23]) {
        translate([19 * (i + 4), 0, 0]) des_default(keyID=i);
    }
}

module des_default(keyID, home=false) {
    keycap(
        keyID  = keyID, //change profile refer to KeyParameters Struct
        Stem   = true, //tusn on shell and stems
        crossSection = false,
        homeDot = home, //turn on homedots
    );
}


