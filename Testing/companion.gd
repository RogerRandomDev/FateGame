extends RigidBody3D


@export var targetPos:Vector3
@export var targetRotation:Vector3
@export var lookAt:Node
@export var moveForce:float=2.

func _physics_process(_delta):
	var moveBy=(global_position - targetPos)
	moveBy.x=clamp(moveBy.x,-2,2)
	moveBy.y=clamp(moveBy.y,-5,5)
	moveBy.z=clamp(moveBy.z,-2,2)
	apply_central_force(-moveBy * moveForce * mass)
	
	targetRotation.y=-Vector2(global_position.x,global_position.z).angle_to_point(Vector2(lookAt.global_position.x,lookAt.global_position.z))-rotation.y
	
	if(abs(targetRotation.y)>PI):targetRotation.y-=PI*2*sign(targetRotation.y)
	angular_velocity=(targetRotation+Vector3(0,PI/2,0))*4
	


func mixWithAngle(rot1:Vector3,rot2:Vector3,mixBy:float):
	return (rot1*(1.-mixBy)+rot2*(mixBy))
