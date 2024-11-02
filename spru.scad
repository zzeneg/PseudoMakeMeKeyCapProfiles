spacing = 17;
r = 0.8;

/* spru same STL */

// count = 1;
// stl ="./stl/MX-minY-minZ/chocV2/DES_r1_r2_r3_r4_edge.stl";
// offsetX = -9.5;
// offsetY = -5.5;
// offsetZ = 0;

// union() {
//   for (i = [0:count - 1]) {
//     translate([0, i * spacing, 0]) import(stl);
//     // mirror([1, 0, 0]) translate([(i+1) * spacing, 0, 0]) import(stl);
//   }

//   translate([spacing / 2 + offsetX, spacing / 2 + offsetY, r + offsetZ])
//   rotate ([270, 0, 90])
//   cylinder(h = (count) * spacing - spacing * 0.1, r = r, $fn=15)
//   ;
// };

/* spru different STLs */

stls = [ "./MX_DES_Thumb_Mid-minY-minZ.stl", "./MX_DES_Standard-minY-minZ-r2.stl", "./MX_DES_Standard-minY-minZ-r3.stl", "./MX_DES_Standard-minY-minZ-r4.stl"];
count = len(stls);
offsetX = -3;
offsetY = -5.5;
offsetZ = 0;

union() {
  for (i = [0:count - 1]) {
    translate([ 0, -i * spacing, 1.25]) import(stls[i]);
  }

  translate([spacing / 2 + offsetX, spacing / 2 + offsetY, r + offsetZ])
  rotate ([270, 0, 180])
  cylinder(h = (count - 1) * spacing + 2, r = r, $fn=15)
  ;
};