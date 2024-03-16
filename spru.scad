spacing = 16;
r = 0.8;

//spru same STL

stl ="./stl/MX/lowprofile/minY/DES_r3_1.00u_x2.stl";
count = 5;

union() {
  for (i = [0:count - 1]) {
    translate([0, i * spacing, 0]) import(stl);
  }

  translate([spacing / 2, -spacing / 2 * 0.9 - 1, -0.9 * r-r])
  rotate ([270, 0, 0])
  cylinder(h = (count) * spacing - spacing * 0.1, r = r, $fn=15)
  ;
};

//spru different STLs

// stls = [ "./stl/MX/lowprofile/minY/DES_thumb_ergo_1u_fanned.stl", "./stl/MX/lowprofile/minY/DES_r3_dot_x2.stl" ];
// count = len(stls);
// offsetX = -3;
// offsetY = 1;
// offsetZ = 2.1;

// union() {
//   for (i = [0:count - 1]) {
//     translate([ 0, i * spacing, 1.25]) import(stls[i]);
//   }

//   translate([spacing / 2 + offsetX, -spacing / 2 * 0.9 - 1 + offsetY, -0.9 * r-r + offsetZ])
//   rotate ([270, 0, 0])
//   cylinder(h = (count) * spacing - spacing * 0.1, r = r, $fn=15)
//   ;
// };