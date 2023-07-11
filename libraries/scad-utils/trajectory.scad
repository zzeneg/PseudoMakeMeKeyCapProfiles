use <so3.scad>

function val(a=undef,default=undef) = a == undef ? default : a;
function vec_is_undef(x,index_=0) = index_ >= len(x) ? true :
is_undef_or_oob(x[index_]) && vec_is_undef(x,index_+1);

function is_undef_or_oob(x) = is_undef(x) ? true : is_list(x) ? vec_is_undef(x) : false;
// Either a or b, but not both
function either(a,b,default=undef) = is_undef_or_oob(a) ? (is_undef_or_oob(b) ? default : b) : is_undef_or_oob(b) ? a : undef;

function translationv(left=undef,right=undef,up=undef,down=undef,forward=undef,backward=undef,translation=undef) = 
translationv_2(
	       x = either(up,is_undef(down) ? down : -down),
	       y = either(right,is_undef(left) ? left : -left),
	       z = either(forward,is_undef(backward) ? backward : -backward),
	translation = translation);

function translationv_2(x,y,z,translation) =
	x == undef && y == undef && z == undef ? translation :
	is_undef_or_oob(translation) ? [val(x,0),val(y,0),val(z,0)]
	: undef;

function rotationv(pitch=undef,yaw=undef,roll=undef,rotation=undef) = 
	rotation == undef ? [val(yaw,0),val(pitch,0),val(roll,0)] :
	pitch == undef && yaw == undef && roll == undef ? rotation :
	undef;

function trajectory(
	left=undef,    right=undef,
	up=undef,      down=undef,
	forward=undef, backward=undef,
	translation=undef,

    pitch=undef,
    yaw=undef,
    roll=undef,
    rotation=undef
) = concat(
	translationv(left=left,right=right,up=up,down=down,forward=forward,backward=backward,translation=translation),
	rotationv(pitch=pitch,yaw=yaw,roll=roll,rotation=rotation)
);
