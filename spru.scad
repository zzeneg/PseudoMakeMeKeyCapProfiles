spacing = 19;
r = 0.8;

/* spru same STL */

count = 5;
stl ="./stl/MX-LP/DES_r2_1.00u_x2.stl";

union() {
  for (i = [0:count - 1]) {
    translate([0, i * spacing, 0]) import(stl);
  }

  translate([spacing / 2, -spacing / 2 * 0.9 - 1, -0.9 * r-r])
  rotate ([270, 0, 0])
  cylinder(h = (count) * spacing - spacing * 0.1, r = r, $fn=15)
  ;
};

/* spru different STLs */

// stls = [ "./stl/MX-minY-minZ/DES_r2_edge_x2.stl", "./stl/MX-minY-minZ/DES_r3_edge_x2.stl", "./stl/MX-minY-minZ/DES_r4_edge_x2.stl"];
// count = len(stls);
// offsetX = 0;
// offsetY = -5.5;
// offsetZ = -1;

// union() {
//   for (i = [0:count - 1]) {
//     translate([ 0, i * spacing, 1.25]) import(stls[i]);
//   }

//   translate([spacing / 2 + offsetX, spacing / 2 + offsetY, r + offsetZ])
//   rotate ([270, 0, 0])
//   cylinder(h = (count - 1) * spacing + 2, r = r, $fn=15)
//   ;
// };