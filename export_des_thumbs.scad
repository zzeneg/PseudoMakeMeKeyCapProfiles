use <MX_DES_Thumb.scad>

spacing = 19.05;
spru_radius = 0.8;

// start = 0; end = 2;
// start = 3; end = 7;
// start = 8; end = 11;
// start = 12; end = 18;
// start = 20; end = 23;
start = 24; end = 26;

union() {
    for (i = [start : end]) {
        des_spru(i);
        mirror([1, 0, 0]) des_spru(i);
    }
}

module des_spru(keyID) {
    translate([19 * (keyID - start) + spacing/2, 0, 0]) des_default(keyID);

    translate([(keyID - start) * spacing - 3, 5, -0.8 * spru_radius])
    rotate([0, 90, 0])
    cylinder(h = 6, r = spru_radius, $fn=20);
}

module des_default(keyID, home=false) {
    keycap(
        keyID  = keyID, //change profile refer to KeyParameters Struct
        Stem   = true, //tusn on shell and stems
        crossSection = false,
        homeDot = home, //turn on homedots
    );
}


