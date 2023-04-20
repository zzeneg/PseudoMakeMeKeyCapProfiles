use <MX_DES_Convex.scad>

union() {
    for (i = [0:17]) {
        translate([0, -19 * i, 0]) des_default(keyID=i);
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


