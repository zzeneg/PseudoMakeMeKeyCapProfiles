use <MX_DES_Thumb-minY-minZ.scad>
// use <Choc_DES_minY.scad>

spacing = 19.05;
spru_radius = 0.8;
mirror = true;

start = 24; end = 26; // MX
// start = 47; end = 49; // Choc

union() {
    for (i = [start : end]) {
        des_spru(i);

        if (mirror == true) {
            mirror([1, 0, 0]) des_spru(i);
        }
    }
}

module des_spru(keyID) {
    translate([19 * (keyID - start) + spacing/2, 0, 0]) des_default(keyID);

    if (keyID != start || mirror == true) {
        translate([(keyID - start) * spacing - 3, 5, -0.8 * spru_radius])
        rotate([0, 90, 0])
        cylinder(h = 6, r = spru_radius, $fn=20);
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


