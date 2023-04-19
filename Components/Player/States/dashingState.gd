extends PlayerController
class_name PlayerDashingState

@export var delayBetweenDashes:float=1
@export var dashDuration:float=0.5
@export var dashSpeed:float=8.

var dashDelay:float=0.;

func onTrigger():
	root.velocity.y=0
	dashDelay=delayBetweenDashes+dashDuration
#handles lowering current dash times
func _process(delta):dashDelay-=delta


#updates current motion for the root node
func _physics_process(_delta):
	root.velocity=Vector3(0,0,-dashSpeed).rotated((root.rotation+root.get_node("CameraArm").rotation).normalized(),(root.rotation+root.get_node("CameraArm").rotation).length())
	root.get_node("MeshInstance3D").global_rotation=root.rotation+root.get_node("CameraArm").rotation+Vector3(-PI/3,0,0)
	#ends at end of dash
	if(dashDelay<=delayBetweenDashes):
		get_parent().setActiveState("PlayerWalkingState")
		resetMesh()
	#can also be canceled in the middle of the dash
	elif(Input.is_action_just_pressed("dash")):
		dashDelay=delayBetweenDashes
		resetMesh()
		get_parent().setActiveState("PlayerWalkingState")


func resetMesh():
	root.get_node("MeshInstance3D").rotation=Vector3.ZERO;

func canDash():return dashDelay<=0
