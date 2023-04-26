
use <scad-utils/morphology.scad> //for cheaper minwoski
use <scad-utils/transformations.scad>
use <scad-utils/shapes.scad>
use <scad-utils/trajectory.scad> use <scad-utils/trajectory_path.scad>
use <sweep.scad>
use <skin.scad>
//use <z-butt.scad>
/*TODOS
 0. iterative design basis ? param to swing?
    a. dish depth
    c. dish traj pitch adjustments
    b. render stability
       i.add fillet angle adjustments to avoid unwanted cuts
 1. Thubms?
 2. convex?
 3. Lateral?
     0.b.i must be resolved

*/

//enum
Choc = 0;
MX = 1;
Null =2;
spru = true;

//// override Z-butt param
//lp_key = [
////     "base_sx", 18.5,
////     "base_sy", 18.5,
//     "base_sx", 17.65,
//     "base_sy", 16.5,
//     "cavity_sx", 16.1,
//     "cavity_sy", 14.9,
//     "cavity_sz", 1.6,
//     "cavity_ch_xy", 1.6,
//     "indent_inset", 1.5
//     ];
/*Tester */


crossBool=false;

for(i = [0:2]){
  translate([-32,     0 - 16 * i, 0]) keycap(keyID = 3 * i, heightAdjust = 4, Stem = MX, crossSection = crossBool, Sym = true,  homeDot = false);
  translate([-16,     0 - 16 * i, 0]) keycap(keyID = 3 * i, heightAdjust = 2, Stem = MX, crossSection = crossBool, Sym = true,  homeDot = false);
  translate([0,       0 - 16 * i, 0]) keycap(keyID = 3 * i, heightAdjust = 0, Stem = MX, crossSection = crossBool, Sym = true,  homeDot = false);
  translate([48 - 32, 0 - 16 * i, 0]) keycap(keyID = 3 * i + 9, heightAdjust = 4, Stem = MX, crossSection = crossBool, Sym = true,  homeDot = false);
  translate([48 - 16, 0 - 16 * i, 0]) keycap(keyID = 3 * i + 9, heightAdjust = 2, Stem = MX, crossSection = crossBool, Sym = true,  homeDot = false);
  translate([48 -  0, 0 - 16 * i, 0]) keycap(keyID = 3 * i + 9, heightAdjust = 0, Stem = MX, crossSection = crossBool, Sym = true,  homeDot = false);
}

for(i = [0:2]){
  translate([-32,     60 - 16 * i, 0]) keycap(keyID = 3 * i, heightAdjust = 4, Stem = Choc, crossSection = crossBool, Sym = true,  homeDot = false);
  translate([-16,     60 - 16 * i, 0]) keycap(keyID = 3 * i, heightAdjust = 2, Stem = Choc, crossSection = crossBool, Sym = true,  homeDot = false);
  translate([0,       60 - 16 * i, 0]) keycap(keyID = 3 * i, heightAdjust = 0, Stem = Choc, crossSection = crossBool, Sym = true,  homeDot = false);
  translate([48 - 32, 60 - 16 * i, 0]) keycap(keyID = 3 * i + 9, heightAdjust = 4, Stem = Choc, crossSection = crossBool, Sym = true,  homeDot = false);
  translate([48 - 16, 60 - 16 * i, 0]) keycap(keyID = 3 * i + 9, heightAdjust = 2, Stem = Choc, crossSection = crossBool, Sym = true,  homeDot = false);
  translate([48 -  0, 60 - 16 * i, 0]) keycap(keyID = 3 * i + 9, heightAdjust = 0, Stem = Choc, crossSection = crossBool, Sym = true,  homeDot = false);
}

// spru
if (spru) {
    for(i = [-2:3]) {
        translate([i * 16,  0 - 22, -1.1]) rotate([90, 0, 0]) cylinder(h = 4, r = 0.8, $fn=20);
        translate([i * 16,  0 -  6, -1.1]) rotate([90, 0, 0]) cylinder(h = 4, r = 0.8, $fn=20);
        translate([i * 16, 60 - 22, -1.1]) rotate([90, 0, 0]) cylinder(h = 4, r = 0.8, $fn=20);
        translate([i * 16, 60 -  6, -1.1]) rotate([90, 0, 0]) cylinder(h = 4, r = 0.8, $fn=20);
    }
}

//-Parameters
wallthickness = 1.1; // 1.75 for mx size, 1.1
topthickness  = 2.5; //2 for phat 3 for chicago
stepsize      = 30;  //resolution of Trajectory
step          = 40;       //resolution of ellipes
fn            = 60;          //resolution of Rounded Rectangles: 60 for output
layers        = 60;    //resolution of vertical Sweep: 50 for output
angularSteps  = 30;

//---Stem param

//injection param
draftAngle = 0; //degree  note:Stem Only
Tol    = 0.00; //stem tolarance
stemRot = 0;
stemRad = 5.55; // stem outer radius
stemLen = 5.55 ;
stemCrossHeight = 4;
extra_vertical  = 0.6;
StemBrimDep     = 0.25;
stemLayers      = 50; //resolution of stem to cap top transition
//TODO: Add wall thickness transition?

dishpow = 2; //power to dish depth transition
h = 1;
//Homing
hRadius = .125;
ArchAngle =  22;

keyParameters = //keyParameters[KeyID][ParameterID]
[
//  BotWid, BotLen, TWDif, TLDif, keyh, WSft, LSft  XSkew, YSkew, ZSkew,/*|*/ WEx, LEx, CapR0i, CapR0f, CapR1i, CapR1f, CapREx, StemEx, chop shift
    //Column 0
    //set R2 14x14 choc trantisiton  wid 14.5 len 13.5
    //R2
    [15.06,  13.06, 4.5, 4.5, 4.65,   0,  -0.0,   -13,  0,  0,      2,   2,    3,      5,     1,    3.5,     2,       2, 0],
    [15.06,  13.06, 4.0, 8.0,-1.0,  0.0,  0.0, 0.0, -0, -0,/*|*/ 2,   2,    3,      5,     1,    3.5,     2,       2, 0],
    [15.06,  13.06, 9.6, 8.6,-1.0,  0.0,  0.0, 0.0, -0, -0,/*|*/ 2,   2,    3,      5,     1,    3.5,     2,       2, 0],

    //R3
    [15.06,  13.06, 4.5, 4.5, 3.5,    0,  0.0,    3,  0,  0,      2,   2,    3,      5,     1,    3.5,     2,       2, 0],
    [15.06,  13.06, 4.0, 8.0,-1.0,  0.0,  0.0, 0.0, -0, -0,/*|*/ 2,   2,    3,      5,     1,    3.5,     2,       2, 0],
    [15.06,  13.06, 9.6, 8.6,-1.0,  0.0,  0.0, 0.0, -0, -0,/*|*/ 2,   2,    3,      5,     1,    3.5,     2,       2, 0],
    //R4
    [15.06,  13.06, 4.5, 4.5, 5.35,    0,  0,    9,  0,  0,      2,   2,    3,      5,     1,    3.5,     2,       2, 0],
    [15.06,  13.06, 4.0, 8.0,-1.0,  0.0,  0.0, 0.0, -0, -0,/*|*/ 2,   2,    3,      5,     1,    3.5,     2,       2, 0],
    [15.06,  13.06, 9.6, 8.6,-1.0,  0.0,  0.0, 0.0, -0, -0,/*|*/ 2,   2,    3,      5,     1,    3.5,     2,       2, 0], //R2 Bottom MX
    //No Yaw
    //R2 Lat
    [15.06,13.06, 4.5, 4.5, 4.65+.8, 0.25,  -0.0,   -13,  8,  5,      2,   2,    3,      5,     1,    3.5,     2,       2, 0],
    [15.06,  13.06, 4.0, 8.0,-1.0,  0.0,  0.0, 0.0, -0, -0,/*|*/ 2,   2,    3,      5,     1,    3.5,     2,       2, 0],
    [15.06,  13.06, 9.6, 8.6,-1.0,  0.0,  0.0, 0.0, -0, -0,/*|*/ 2,   2,    3,      5,     1,    3.5,     2,       2, 0],
    //R3 Lat
    [15.06,  13.06, 4.5, 4.5,3.5+.8,.25,  0.0,   3,  8,  5,      2,   2,    3,      5,     1,    3.5,     2,       2, 0],
    [15.06,  13.06, 4.0, 8.0,-1.0,  0.0,  0.0, 0.0, -0, -0,/*|*/ 2,   2,    3,      5,     1,    3.5,     2,       2, 0],
    [15.06,  13.06, 9.6, 8.6,-1.0,  0.0,  0.0, 0.0, -0, -0,/*|*/ 2,   2,    3,      5,     1,    3.5,     2,       2, 0],
    //R4 Lat
    [15.06,  13.06, 4.5, 4.5, 5.35+.8, .25,  0,    9,  8,  5,      2,   2,    3,      5,     1,    3.5,     2,       2, 0],
    [15.06,  13.06, 4.0, 8.0,-1.0,  0.0,  0.0, 0.0, -0, -0,/*|*/ 2,   2,    3,      5,     1,    3.5,     2,       2, 0],
    [15.06,  13.06, 9.6, 8.6,-1.0,  0.0,  0.0, 0.0, -0, -0,/*|*/ 2,   2,    3,      5,     1,    3.5,     2,       2, 0], //R2 Bottom MX
];

dishParameters = //dishParameter[keyID][ParameterID]
[
//FFwd1 FFwd2 FPit1 FPit2 DhDIn DhDFnF DhDFnB DhDif ArcIn FArcFn FArcEx  BFwd1 BFwd2 BPit1 BPit2 BArcFn BArcEx
  [ 6,  3,   10,  -50,    5,   1.8,   1.2,  3,    8.5,     15,    2,     6.0,   4.0,  13,   30,   15,   2], //R2
  [], [],// buffer
  [ 4.75,  3.5,   12,  -55,    5,   1.8,   1.8,  3,    8.5,     15,    2,     4.75,   3.7,  13,   -50,   15,   2], //R3
  [], [],// buffer
  [ 5.5,  3.0,  18,   -55,    5,   1,   1.8,  3,    8.5,     15,    2,     5.00,   4.4,   6,   -55,   15,   2], //R4
//  [ 5.,  4.4,   6,   -55,    5,   1,   1.8,  3,    8.5,     15,    2,     6.00,   3.0,   18,   -55,   15,   2], //R4
  [], [],// buffer

  [ 6,  3,   10,  -50,    5,   1.8,   1.2,  3,    8.5,     15,    2,     6.0,   4.0,  13,   30,   15,   2], //R2
  [], [],// buffer
  [ 4.75,  3.5,   12,  -55,    5,   1.8,   1.8,  3,    8.5,     15,    2,     4.75,   3.7,  13,   -50,   15,   2], //R3
  [], [],// buffer
  [ 5.5,  3.0,  18,   -55,    5,   1,   1.8,  3,    8.5,     15,    2,     5.00,   4.4,   6,   -55,   15,   2], //R4
//  [ 5.,  4.4,   6,   -55,    5,   1,   1.8,  3,    8.5,     15,    2,     6.00,   3.0,   18,   -55,   15,   2], //R4
  [], [],// buffer

];

secondaryDishParam = [
[    2,    2,    2,   2, 2,   228,    198,    195,   4/(8),  4/8,  4.05,   3,    8,     2,   213,    195,   191,   80, 90],
[], [],// buffer
[    2,    2,    2,   2, 2,   229,    195,    198,   4/(8),  4/8,  4.05,   3,    8,     2,   213,    195,   195,   80, 90],
[], [],// buffer
[    3,    2,    2,   2, 2,   228,    190,    185,   4/(8),  4/8,  4.05,   3,    8,     2,   213,    195,   191,   80, 90],
[], [],// buffer

[    2,    2,    2,   2, 2,   228,    198,    195,   4/(8),  4/8,  4.05,   3,    8,     2,   213,    195,   191,   80, 90],
[], [],// buffer
[    2,    2,    2,   2, 2,   229,    195,    198,   4/(8),  4/8,  4.05,   3,    8,     2,   213,    195,   195,   80, 90],
[], [],// buffer
[    3,    2,    2,   2, 2,   228,    190,    185,   4/(8),  4/8,  4.05,   3,    8,     2,   213,    195,   191,   80, 90],
[], [],// buffer
];

function BottomWidth(keyID)  = keyParameters[keyID][0];  //
function BottomLength(keyID) = keyParameters[keyID][1];  //
function TopWidthDiff(keyID) = keyParameters[keyID][2];  //
function TopLenDiff(keyID)   = keyParameters[keyID][3];  //
function KeyHeight(keyID)    = keyParameters[keyID][4];  //
function TopWidShift(keyID)  = keyParameters[keyID][5];
function TopLenShift(keyID)  = keyParameters[keyID][6];
function XAngleSkew(keyID)   = keyParameters[keyID][7];
function YAngleSkew(keyID)   = keyParameters[keyID][8];
function ZAngleSkew(keyID)   = keyParameters[keyID][9];
function WidExponent(keyID)  = keyParameters[keyID][10];
function LenExponent(keyID)  = keyParameters[keyID][11];
function CapRound0i(keyID)   = keyParameters[keyID][12];
function CapRound0f(keyID)   = keyParameters[keyID][13];
function CapRound1i(keyID)   = keyParameters[keyID][14];
function CapRound1f(keyID)   = keyParameters[keyID][15];
function ChamExponent(keyID) = keyParameters[keyID][16];
function StemExponent(keyID) = keyParameters[keyID][17];
function ChopShift(keyID)    = keyParameters[keyID][18];

function FrontForward1(keyID) = dishParameters[keyID][0];  //
function FrontForward2(keyID) = dishParameters[keyID][1];  //
function FrontPitch1(keyID)   = dishParameters[keyID][2];  //
function FrontPitch2(keyID)   = dishParameters[keyID][3];  //
function DishDepthInit(keyID) = dishParameters[keyID][4];  //
function DishDepthFinF(keyID) = dishParameters[keyID][5];  //
function DishDepthFinB(keyID) = dishParameters[keyID][6];  //
function DishHeightDif(keyID) = dishParameters[keyID][7];  //
function InitArc(keyID)       = dishParameters[keyID][8];
function FrontFinArc(keyID)   = dishParameters[keyID][9];
function FrontArcExpo(keyID)  = dishParameters[keyID][10];
function BackForward1(keyID)  = dishParameters[keyID][11];  //
function BackForward2(keyID)  = dishParameters[keyID][12];  //
function BackPitch1(keyID)    = dishParameters[keyID][13];  //
function BackPitch2(keyID)    = dishParameters[keyID][14];  //
function BackFinArc(keyID)    = dishParameters[keyID][15];
function BackArcExpo(keyID)   = dishParameters[keyID][16];

function TanInit(keyID)                   = secondaryDishParam[keyID][0];
function ForwardTanFin(keyID)             = secondaryDishParam[keyID][1];
function BackTanFin(keyID)                = secondaryDishParam[keyID][2];
function ForwardTanArcExpo(keyID)         = secondaryDishParam[keyID][3];
function BackTanArcExpo(keyID)            = secondaryDishParam[keyID][4];
function TransitionAngleInit(keyID)       = secondaryDishParam[keyID][5];
function ForwardTransitionAngleFin(keyID) = secondaryDishParam[keyID][6];
function BackTransitionAngleFin(keyID)    = secondaryDishParam[keyID][7];
function ForwardFilRatio(keyID)           = secondaryDishParam[keyID][8];
function BackFilRatio(keyID)              = secondaryDishParam[keyID][9];

function TanInit2(keyID)                   = secondaryDishParam[keyID][9];
function ForwardTanFin2(keyID)             = secondaryDishParam[keyID][10];
function BackTanFin2(keyID)                = secondaryDishParam[keyID][11];
function TanArcExpo2(keyID)                = secondaryDishParam[keyID][12];
function TransitionAngleInit2(keyID)       = secondaryDishParam[keyID][13];
function ForwardTransitionAngleFin2(keyID) = secondaryDishParam[keyID][14];
function BackTransitionAngleFin2(keyID)    = secondaryDishParam[keyID][15];
function ForwardFilAngle2(keyID)           = secondaryDishParam[keyID][16];
function BackFilAngle2(keyID)              = secondaryDishParam[keyID][17];

function FrontTrajectory(keyID) =
  [
    trajectory(forward = FrontForward1(keyID), pitch =  FrontPitch1(keyID)), //more param available: yaw, roll, scale
    trajectory(forward = FrontForward2(keyID), pitch =  FrontPitch2(keyID))  //You can add more traj if you wish
  ];

function BackTrajectory (keyID) =
  [
    trajectory(backward = BackForward1(keyID), pitch =  -BackPitch1(keyID)),
    trajectory(backward = BackForward2(keyID), pitch =  -BackPitch2(keyID)),
  ];

//------- function defining Dish Shapes,
//helper function
function flip (singArry) = [for(i = [len(singArry)-1:-1:0]) singArry[i]];
function mirrorX (singArry) = [for(i = [len(singArry)-1:-1:0]) [-singArry[i][0], singArry[i][1]]];
function mirrorY (singArry) = [for(i = [len(singArry)-1:-1:0]) [singArry[i][0], -singArry[i][1]]];

//function ()

function Fade (Arry1, Arry2, t, steps, pows) =len(Arry1)==len(Arry2) ? [for(i = [0:len(Arry1)-1]) (1-pow(t/steps, pows))*Arry1[i]+pow(t/steps, pows)*Arry2[i]]: [[0,0]];

function Mix (a, b, t, steps, pows)= (1-pow(t/steps, pows))*a+pow(t/steps, pows)*b;
function smoothStart (init, fin, t, steps, power) =
  (1-pow(t/steps,power))*init + pow(t/steps,power)*fin ;

function smoothStop (init, fin, t, steps, power) =
  (fin-init)*(1-pow(1-t/steps,power))+init;

function smoothestStep (init, fin, t, steps) =
  (fin - init)*(-20*pow(t/steps,7) + 70*pow(t/steps,6) - 84*pow(t/steps,5) +35*pow(t/steps,4)) + init;

  function ellipse(a, b, d = 0, rot1 = 0, rot2 = 360) = [for (i =[0:angularSteps]) let(t = smoothStart(rot1,rot2,i,angularSteps,1)) [a*cos(t)+a, b*sin(t)*(1+d*cos(t))]]; //Centered at a apex to avoid inverted face

  function ellipse2(a, b, d = 0, rot1 = 0, rot2 = 360, Shift =[0,0]) = [for (i =[0:angularSteps/2]) let(t = smoothStart(rot1,rot2,i,angularSteps/2,1)) [a*cos(t)+a, b*sin(t)*(1+d*cos(t))]+Shift]; //Centered at a apex to avoid inverted face


function DishShape (a,b, phi = 200, theta, r, Sym = false) =
  concat(
//   [[c+a,b]],
    ellipse(a, b, d = 0, rot1 = 90, rot2 = 270)

//    [for (n = [1:step/2])let(sig = atan(a*cos(phi)/-b*sin(phi)), t = theta*n/step*2)
//     [ r*cos(-atan(-a*cos(phi)/b*sin(phi))-t)
//      +a*cos(phi)
//      -r*cos(sig)
//      +a,
//
//       r*sin(-atan(-a*cos(phi)/b*sin(phi))-t)
//      +b*sin(phi)
//      +r*sin(sig)]
//    ],
//
//
//    [[a,b*sin(phi)-r*sin(theta)*2]] //bounday vertex to clear ends
  );

function DishShape2 (a,b, phi = 200, theta, r, filRatio=1) =
  concat(
//   [[c+a,b]],
    [[a,-(b*sin(phi)-r*sin(theta)*2)]], //bounday vertex to clear ends

    mirrorY(
      [for (n = [1:2:step/2])let(sig = atan(a*cos(phi)/-b*sin(phi)), t = theta*n/step*2*filRatio)
        [ r*cos(-atan(-a*cos(phi)/b*sin(phi))-t) + a*cos(phi)
          -r*cos(sig) +a,

          r*sin(-atan(-a*cos(phi)/b*sin(phi))-t) + b*sin(phi)
          +r*sin(sig)]
      ]),

    mirrorY(ellipse(a, b, d = 0,rot1 = 180, rot2 = phi)),

    ellipse(a, b, d = 0,rot1 = 180, rot2 = phi),

    [for (n = [1:2:step/2])let(sig = atan(a*cos(phi)/-b*sin(phi)), t = theta*n/step*2*filRatio)
      [r*cos(-atan(-a*cos(phi)/b*sin(phi))-t)
       +a*cos(phi)
       -r*cos(sig)
       +a,

       r*sin(-atan(-a*cos(phi)/b*sin(phi))-t)
       +b*sin(phi)
       +r*sin(sig)]
    ],

    [[a,b*sin(phi)-r*sin(theta)*2]] //bounday vertex to clear ends

  );

function DishShape3 (a1,b1,a2,b2, phi = 200, theta, r, filRatio=1) =
  concat(
//   [[c+a,b]],
    [[a,-(b*sin(phi)-r*sin(theta)*2)]], //bounday vertex to clear ends

    mirrorY(
      [for (n = [1:2:step/2])let(sig = atan(a*cos(phi)/-b*sin(phi)), t = theta*n/step*2*filRatio)
        [ r*cos(-atan(-a*cos(phi)/b*sin(phi))-t) + a*cos(phi)
          -r*cos(sig) +a,

          r*sin(-atan(-a*cos(phi)/b*sin(phi))-t) + b*sin(phi)
          +r*sin(sig)]
      ]),
    mirrorY(ellipse(a, b, d = 0,rot1 = 180, rot2 = phi)),
    ellipse(a, b, d = 0,rot1 = 180, rot2 = phi),

      [for (n = [1:2:step/2])let(sig = atan(a*cos(phi)/-b*sin(phi)), t = theta*n/step*2*filRatio)
        [r*cos(-atan(-a*cos(phi)/b*sin(phi))-t)
          +a*cos(phi)
          -r*cos(sig)
          +a,

        r*sin(-atan(-a*cos(phi)/b*sin(phi))-t)
          +b*sin(phi)
        +r*sin(sig)]
      ],

    [[a,b*sin(phi)-r*sin(theta)*2]] //bounday vertex to clear ends
  );

function oval_path(theta, phi, a, b, c, deform = 0) = [
 a*cos(theta)*cos(phi), //x
 c*sin(theta)*(1+deform*cos(theta)) , //
 b*sin(phi),
];

path_trans2 = [for (t=[0:step:180])   translation(oval_path(t,0,10,15,2,0))*rotation([0,90,0])];


//--------------Function definng Cap
function CapTranslation(t, keyID, heightShift =0) =
  [
    ((-t)/layers*TopWidShift(keyID)),   //X shift
    ((-t)/layers*TopLenShift(keyID)),   //Y shift
    (t/layers*(KeyHeight(keyID)+heightShift))    //Z shift
  ];

function InnerTranslation(t, keyID) =
  [
    ((t)/layers*TopWidShift(keyID)),   //X shift
    ((t)/layers*TopLenShift(keyID)),   //Y shift
    (t/layers*(KeyHeight(keyID)-topthickness))    //Z shift
  ];

function CapRotation(t, keyID) =
  [
    ((-t)/layers*XAngleSkew(keyID)),   //X shift
    ((-t)/layers*YAngleSkew(keyID)),   //Y shift
    ((-t)/layers*ZAngleSkew(keyID))    //Z shift
  ];

function CapTransform(t, keyID) =
  [
    pow(t/layers, WidExponent(keyID))*(BottomWidth(keyID) -TopWidthDiff(keyID)) + (1-pow(t/layers, WidExponent(keyID)))*BottomWidth(keyID) ,
    pow(t/layers, LenExponent(keyID))*(BottomLength(keyID)-TopLenDiff(keyID)) + (1-pow(t/layers, LenExponent(keyID)))*BottomLength(keyID)
  ];
function CapBottomTransform(t, pow2, keyID) =
  [
   smoothestStep (CapTransform(t, keyID)[0],
                pow(t/layers,pow2)*(BottomWidth(keyID) -TopWidthDiff(keyID)) + (1-pow(t/layers, pow2))*BottomWidth(keyID),
                t,
                layers
               ),
   smoothestStep(CapTransform(t, keyID)[1],
                pow(t/layers, pow2)*(BottomLength(keyID)-TopLenDiff(keyID)) + (1-pow(t/layers, pow2))*BottomLength(keyID),
                t,
                layers
               )
  ];
function CapRoundness(t, keyID) =
  [
    pow(t/layers, ChamExponent(keyID))*(CapRound0f(keyID)) + (1-pow(t/layers, ChamExponent(keyID)))*CapRound0i(keyID),
    pow(t/layers, ChamExponent(keyID))*(CapRound1f(keyID)) + (1-pow(t/layers, ChamExponent(keyID)))*CapRound1i(keyID)
  ];

  function CapBototmRoundness(t, keyID) =
  [
    pow(t/layers, ChamExponent(keyID))*(CapRound0f(keyID)) + (1-pow(t/layers, ChamExponent(keyID)))*CapRound0i(keyID),
    pow(t/layers, ChamExponent(keyID))*(CapRound1f(keyID)) + (1-pow(t/layers, ChamExponent(keyID)))*CapRound1i(keyID)
  ];

function CapRadius(t, keyID) = pow(t/layers, ChamExponent(keyID))*ChamfFinRad(keyID) + (1-pow(t/layers, ChamExponent(keyID)))*ChamfInitRad(keyID);

function InnerTransform(t, keyID) =
  [
    pow(t/layers, WidExponent(keyID))*(BottomWidth(keyID) -TopLenDiff(keyID)-wallthickness*2) + (1-pow(t/layers, WidExponent(keyID)))*(BottomWidth(keyID) -wallthickness*2),
    pow(t/layers, LenExponent(keyID))*(BottomLength(keyID)-TopLenDiff(keyID)-wallthickness*2) + (1-pow(t/layers, LenExponent(keyID)))*(BottomLength(keyID)-wallthickness*2)
  ];

function StemTranslation(t, keyID) =
  [
    ((t)/stemLayers*TopWidShift(keyID)),   //X shift
    (-(t)/stemLayers*TopLenShift(keyID)),   //Y shift
    stemCrossHeight+.5+StemBrimDep + (t/stemLayers*(KeyHeight(keyID)- topthickness - stemCrossHeight-.1 -StemBrimDep))    //Z shift
  ];

function StemRotation(t, keyID) =
  [
    (-(t)/stemLayers*XAngleSkew(keyID)),   //X shift
    (-(t)/stemLayers*YAngleSkew(keyID)),   //Y shift
    ((t)/stemLayers*ZAngleSkew(keyID))    //Z shift
  ];

function StemTransform(t, keyID) =
  [
    pow(t/stemLayers, StemExponent(keyID))*(BottomWidth(keyID) -TopLenDiff(keyID)) + (1-pow(t/stemLayers, StemExponent(keyID)))*(stemWid - 2*slop),
    pow(t/stemLayers, StemExponent(keyID))*(BottomLength(keyID)-TopLenDiff(keyID)) + (1-pow(t/stemLayers, StemExponent(keyID)))*(stemLen - 2*slop)
  ];

function StemRadius(t, keyID) = pow(t/stemLayers,3)*3 + (1-pow(t/stemLayers, 3))*1;
  //Stem Exponent

//

function FTanRadius(t, keyID) = pow(t/stepsize,ForwardTanArcExpo(keyID) )*ForwardTanFin(keyID) + (1-pow(t/stepsize, ForwardTanArcExpo(keyID) ))*TanInit(keyID);

function BTanRadius(t, keyID) = pow(t/stepsize,BackTanArcExpo(keyID) )*BackTanFin(keyID)  + (1-pow(t/stepsize, BackTanArcExpo(keyID) ))*TanInit(keyID);

function ForwardTanTransition(t, keyID) =(1-pow(t/stepsize, ForwardTanArcExpo(keyID)))*TransitionAngleInit(keyID) +  pow(t/stepsize,ForwardTanArcExpo(keyID))*ForwardTransitionAngleFin(keyID);

function BackTanTransition(t, keyID) = (1-pow(t/stepsize, BackTanArcExpo(keyID) ))*TransitionAngleInit(keyID)  +  pow(t/stepsize,BackTanArcExpo(keyID))*BackTransitionAngleFin(keyID);


///----- KEY Builder Module
module keycap(keyID = 0, cutLen = 0, visualizeDish = false, crossSection = false, Dish = true, SecondaryDish = false, Stem = false, homeDot = false, Stab = 0, Legends = false, Sym = false, Rotation = 0,  heightAdjust =0) {

  //Set Parameters for dish shape
  FrontPath = quantize_trajectories(FrontTrajectory(keyID), steps = stepsize, loop=false, start_position= $t*4);
  BackPath  = quantize_trajectories(BackTrajectory(keyID),  steps = stepsize, loop=false, start_position= $t*4);

  //Scaling initial and final dim tranformation by exponents
  function FrontDishArc(t) =  pow((t)/(len(FrontPath)),FrontArcExpo(keyID))*FrontFinArc(keyID) + (1-pow(t/(len(FrontPath)),FrontArcExpo(keyID)))*InitArc(keyID);
  function BackDishArc(t)  =  pow((t)/(len(FrontPath)),BackArcExpo(keyID))*BackFinArc(keyID) + (1-pow(t/(len(FrontPath)),BackArcExpo(keyID)))*InitArc(keyID);

  function DishDepthF(t, keyID, p) = pow((t)/(len(FrontPath)),p)*DishDepthFinF(keyID) + (1-pow(t/(len(FrontPath)),p))*DishDepthInit(keyID);
  function DishDepthB(t, keyID, p) = pow((t)/(len(FrontPath)),p)*DishDepthFinB(keyID) + (1-pow(t/(len(FrontPath)),p))*DishDepthInit(keyID);

  FrontCurve = [ for(i=[0:len(FrontPath)-1]) transform(FrontPath[i],
    Sym ? DishShape2( a= DishDepthF(i, keyID, dishpow), b= FrontDishArc(i), phi = ForwardTanTransition(i, keyID) , theta= 60, r = FTanRadius(i, keyID), filRatio = ForwardFilRatio(keyID)) : DishShape( a= DishDepthF(i, keyID,dishpow), b= FrontDishArc(i), phi = ForwardTanTransition(i, keyID)  , theta= 60, r = FTanRadius(i, keyID), filRatio = ForwardFilRatio(keyID))
  ) ];
  BackCurve  = [ for(i=[0:len(BackPath)-1])  transform(BackPath[i],
    Sym ? DishShape2(DishDepthB(i, keyID, dishpow), BackDishArc(i), phi = BackTanTransition(i, keyID), theta= 60, r = BTanRadius(i, keyID), filRatio = BackFilRatio(keyID)) : DishShape(DishDepthB(i, keyID, dishpow), BackDishArc(i), phi = BackTanTransition(i, keyID), theta= 60, r = BTanRadius(i, keyID), filRatio = BackFilRatio(keyID))
  ) ];

   //Homing Arch
   FrontHomeR = [ for(i=[0:len(FrontPath)-6]) let(r = smoothStart(hRadius,.05, i, len(FrontPath)-6,1) )
    transform(FrontPath[i],
              ellipse2(
                  a=r,
                  b=r,
                  d = 0,
                  rot1=0,
                  rot2=360,
                  Shift =ellipse(a=DishDepthF(i, keyID,dishpow), b=FrontDishArc(i), d = 0,rot1 = 180, rot2 = ForwardTanTransition(i, keyID))[ArchAngle]-[hRadius,0]))];
    FrontHomeL = [ for(i=[0:len(FrontPath)-6]) let(r = smoothStart(hRadius,.05, i, len(FrontPath)-6,1) )
    transform(FrontPath[i],
              ellipse2(
                  a=r,
                  b=r,
                  d = 0,
                  rot1=0,
                  rot2=360,
                  Shift =flip(mirrorY(ellipse(a=DishDepthF(i, keyID,dishpow), b=FrontDishArc(i), d = 0,rot1 = 180, rot2 = ForwardTanTransition(i, keyID))))[ArchAngle] -[hRadius,0]))];
    BackHomeR = [ for(i=[0:len(BackPath)-6]) let(r = smoothStart(hRadius,.05, i, len(FrontPath)-6,1) )
    transform(BackPath[i],
              ellipse2(
                  a=r,
                  b=r,
                  d = 0,
                  rot1=0,
                  rot2=360,
                  Shift =ellipse(a=DishDepthF(i, keyID,dishpow), b=BackDishArc(i), d = 0,rot1 = 180, rot2 = BackTanTransition(i, keyID))[ArchAngle]-[hRadius,0]))];
    BackHomeL = [ for(i=[0:len(BackPath)-6]) let(r = smoothStart(hRadius,.05, i, len(FrontPath)-6,1) )
    transform(BackPath[i],
              ellipse2(
                  a=r,
                  b=r,
                  d = 0,
                  rot1=0,
                  rot2=360,
                  Shift =flip(mirrorY(ellipse(a=DishDepthF(i, keyID,dishpow), b=BackDishArc(i), d = 0,rot1 = 180, rot2 = BackTanTransition(i, keyID))))[ArchAngle] -[hRadius,0]))];
  //builds
  difference(){
    union(){
//      difference(){
        skin([for (i=[0:layers]) transform(translation(CapTranslation(i, keyID,heightAdjust)) * rotation(CapRotation(i, keyID)), elliptical_rectangle(CapTransform(i, keyID), b = CapRoundness(i,keyID),fn=fn))]); //outer shell
        //Bottom shell
        if( Stem == Choc){
        skin([for (i=[0:layers]) transform(translation(CapTranslation(i, keyID+1)) * rotation(CapRotation(i, keyID+1)), elliptical_rectangle(CapTransform(i, keyID+1), b =  CapRoundness(i,keyID+1),fn=fn))]); //outer shell
        }else {
          skin([for (i=[0:layers])
            transform(translation(CapTranslation(i, keyID+2)) * rotation(CapRotation(i, keyID+2)),
             elliptical_rectangle(CapBottomTransform(i,.5, keyID+2), b  = CapRoundness(i,keyID+2),fn=fn),)]); //outer shell
          }
        //Cut inner shell
//      }
      if(Stem == Choc){
        rotate([0,0,stemRot])translate([0,0,-1.75+KeyHeight(keyID+2)])choc_stem(draftAng = draftAngle); // generate mx cherry stem, not compatible with box
      } else if (Stem +MX){
        translate([0,0,-3.7+KeyHeight(keyID+2)])rotate(stemRot)cylinder(d =5.5, 3.75, $fn= 64);

//        translate([0,0,-.001])skin([for (i=[0:stemLayers]) transform(translation(StemTranslation(i,keyID))*rotation(StemRotation(i, keyID)), rounded_rectangle_profile(StemTransform(i, keyID),fn=fn,r=1 /*StemRadius(i, keyID) */ ))]); //outer shell


      }
    //cut for fonts and extra pattern for light?
     if(visualizeDish == true && Dish == true){
      #translate([-TopWidShift(keyID),-TopLenShift(keyID),KeyHeight(keyID)+heightAdjust-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),Rotation])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(FrontCurve);
      #translate([-TopWidShift(keyID),-TopLenShift(keyID),KeyHeight(keyID)+heightAdjust-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),Rotation])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(BackCurve);
     }
    }

    //Cuts

    //Fonts
    if(cutLen != 0){
      translate([sign(cutLen)*(BottomLength(keyID)+CapRound0i(keyID)+abs(cutLen))/2,0,0])
        cube([BottomWidth(keyID)+CapRound1i(keyID)+1,BottomLength(keyID)+CapRound0i(keyID),50], center = true);
    }
    if(Legends ==  true){
      }
   //Dish Shape
    if(Dish == true){
      translate([-TopWidShift(keyID),.0001-TopLenShift(keyID),KeyHeight(keyID)+heightAdjust-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),Rotation])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(FrontCurve);
      translate([-TopWidShift(keyID),-TopLenShift(keyID),KeyHeight(keyID)+heightAdjust-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),Rotation])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(BackCurve);

    if (Stem == MX){
      translate([0,0,-3.7+KeyHeight(keyID+2)])rotate(stemRot){
          skin(StemCurve);
          skin(StemCurve2);
        }
      }
     if(SecondaryDish == true){
       translate([BottomWidth(keyID)/2,-BottomLength(keyID)/2,KeyHeight(keyID)-SDishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90-XAngleSkew(keyID),270-ZAngleSkew(keyID)])skin(SBackCurve);
       mirror([1,0,0])translate([BottomWidth(keyID)/2,-BottomLength(keyID)/2,KeyHeight(keyID)-SDishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90-XAngleSkew(keyID),270-ZAngleSkew(keyID)])skin(SBackCurve);

     }
   }
     if(crossSection == true) {
       translate([0,-25,-.1])cube([15,50,15]);
     }
  }
  //Homing dot
  if(homeDot == true)translate([-TopWidShift(keyID),.0001-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)])
      rotate([0,-YAngleSkew(keyID),Rotation])
      rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)]){
          skin(FrontHomeR);
          skin(FrontHomeL);
          skin(BackHomeR);
          skin(BackHomeL);
      }
//  translate([0,0,KeyHeight(keyID)-DishHeightDif(keyID)-.25])sphere(d = 1);
}

//------------------stems
$fn = fn;

MXWid = 4.03/2+Tol; //horizontal lenght
MXLen = 4.23/2+Tol; //vertical length

MXWidT = 1.15/2+Tol; //horizontal thickness
MXLenT = 1.25/2+Tol; //vertical thickness

function stem_internal(sc=1) = sc*[
[MXLenT, MXLen],[MXLenT, MXWidT],[MXWid, MXWidT],
[MXWid, -MXWidT],[MXLenT, -MXWidT],[MXLenT, -MXLen],
[-MXLenT, -MXLen],[-MXLenT, -MXWidT],[-MXWid, -MXWidT],
[-MXWid,MXWidT],[-MXLenT, MXWidT],[-MXLenT, MXLen]
];  //2D stem cross with tolance offset and additonal transformation via jog
//trajectory();
function StemTrajectory() =
  [
    trajectory(forward = 4.25)  //You can add more traj if you wish
  ];

  StemPath  = quantize_trajectories(StemTrajectory(),  steps = 1 , loop=false, start_position= $t*4);
  StemCurve  = [ for(i=[0:len(StemPath)-1])  transform(StemPath[i],  stem_internal()) ];

function StemTrajectory2() =
  [
    trajectory(forward = .5)  //You can add more traj if you wish
  ];

  StemPath2  = quantize_trajectories(StemTrajectory2(),  steps = 10, loop=false, start_position= $t*4);
  StemCurve2  = [ for(i=[0:len(StemPath2)-1])  transform(StemPath2[i]*scaling([(1.1-.1*i/(len(StemPath2)-1)),(1.1-.1*i/(len(StemPath2)-1)),1]),  stem_internal()) ];


module choc_stem(draftAng = 5) {
  stemHeight = 3.1;
  dia = .15;
  wids = 1.16/2;
  lens = 1.45;
  module Stem() {
    difference(){
      translate([0,0,-stemHeight/2])linear_extrude(height = stemHeight)hull(){
        translate([wids-dia,-lens])circle(d=dia);
        translate([-wids+dia,-lens])circle(d=dia);
        translate([wids-dia,  lens])circle(d=dia);
        translate([-wids+dia, lens])circle(d=dia);
      }

    //cuts
      translate([3.9,0])cylinder(d1=7+sin(draftAng)*stemHeight, d2=7,3.5, center = true, $fn = 64);
      translate([-3.9,0])cylinder(d1=7+sin(draftAng)*stemHeight,d2=7,3.5, center = true, $fn = 64);
    }
  }

  translate([5.7/2,0,-stemHeight/2+2])Stem();
  translate([-5.7/2,0,-stemHeight/2+2])Stem();
}

/// ----- helper functions
function rounded_rectangle_profile(size=[1,1],r=1,fn=32) = [
	for (index = [0:fn-1])
		let(a = index/fn*360)
			r * [cos(a), sin(a)]
			+ sign_x(index, fn) * [size[0]/2-r,0]
			+ sign_y(index, fn) * [0,size[1]/2-r]
];

function elliptical_rectangle(a = [1,1], b =[1,1], fn=32) = [
    for (index = [0:fn-1]) // section right
     let(theta1 = -atan(a[1]/b[1])+ 2*atan(a[1]/b[1])*index/fn)
      [b[1]*cos(theta1), a[1]*sin(theta1)]
    + [a[0]*cos(atan(b[0]/a[0])) , 0]
    - [b[1]*cos(atan(a[1]/b[1])) , 0],

    for(index = [0:fn-1]) // section Top
     let(theta2 = atan(b[0]/a[0]) + (180 -2*atan(b[0]/a[0]))*index/fn)
      [a[0]*cos(theta2), b[0]*sin(theta2)]
    - [0, b[0]*sin(atan(b[0]/a[0]))]
    + [0, a[1]*sin(atan(a[1]/b[1]))],

    for(index = [0:fn-1]) // section left
     let(theta2 = -atan(a[1]/b[1])+180+ 2*atan(a[1]/b[1])*index/fn)
      [b[1]*cos(theta2), a[1]*sin(theta2)]
    - [a[0]*cos(atan(b[0]/a[0])) , 0]
    + [b[1]*cos(atan(a[1]/b[1])) , 0],

    for(index = [0:fn-1]) // section Top
     let(theta2 = atan(b[0]/a[0]) + 180 + (180 -2*atan(b[0]/a[0]))*index/fn)
      [a[0]*cos(theta2), b[0]*sin(theta2)]
    + [0, b[0]*sin(atan(b[0]/a[0]))]
    - [0, a[1]*sin(atan(a[1]/b[1]))]
]/2;

function sign_x(i,n) =
	i < n/4 || i > n-n/4  ?  1 :
	i > n/4 && i < n-n/4  ? -1 :
	0;

function sign_y(i,n) =
	i > 0 && i < n/2  ?  1 :
	i > n/2 ? -1 :
	0;
