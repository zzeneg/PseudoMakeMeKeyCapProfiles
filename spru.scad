spacing = 17;
r = 0.8;

offsetX = 1;
offsetY = -4.5;
offsetZ = -2;

/* spru same STL */

count = 3;
stl ="./stl/MX-minY-minZ/DES_r2_1.00u_x2.stl";

union() {
  for (i = [0:count - 1]) {
    translate([0, i * spacing, 0]) import(stl);
  }

  translate([spacing / 2 + offsetX, spacing / 2 + offsetY, r + offsetZ])
  rotate ([270, 0, 0])
  cylinder(h = (count - 1) * spacing + 2, r = r, $fn=15)
  ;
};

/* spru different STLs */

// stls = ["./stl/MX-minY-minZ/DES_r4_edge_x2.stl", "./stl/MX-minY-minZ/DES_r3_edge_x2.stl", "./stl/MX-minY-minZ/DES_r2_edge_x2.stl", "./stl/MX-minY-minZ/DES_r1_edge_x2.stl"];
// stls = ["./stl/MX-minY-minZ/DES_r3_dot_x2.stl", "./stl/MX-minY-minZ/DES_r3_edge_x2.stl"];
// stls = ["./stl/Choc-minY/DES_r3_dot_x2.stl", "./stl/Choc-minY/DES_r3_edge_x2.stl"];
// count = len(stls);

// union() {
//   for (i = [0:count - 1]) {
//     translate([ 0, i * spacing, 0]) import(stls[i]);
//   }

//   translate([spacing / 2 + offsetX, spacing / 2 + offsetY, r + offsetZ])
//   rotate ([270, 0, 0])
//   cylinder(h = (count - 1) * spacing + 2, r = r, $fn=15)
//   ;
// };