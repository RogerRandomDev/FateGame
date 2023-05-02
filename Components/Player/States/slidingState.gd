extends PlayerController
class_name PlayerSlidingState

@export var slideSpeedMult:float=2.0
@export var speedDecay:float=0.9
@export var minDecay:float=10.
@export var downhillGain:float=5.
var initialVelocity:float=0.
func onTrigger():
	initialVelocity=root.linear_velocity.length()
	root.get_node("Model").rotation.x=PI/2.5
	root.get_node("Model").position.y=-0.5
func revertMesh():
	root.get_node("Model").rotation.x=0
	root.get_node("Model").position.y=0
#updates current motion for the root node
func _physics_process(delta):
	
	initialVelocity-=root.linear_velocity.y*delta * downhillGain * int(root.on_floor)
	var moveDirection=-Vector3(sin(root.rotation.y),0,cos(root.rotation.y))*root.SPEED*slideSpeedMult
	initialVelocity-=max(initialVelocity*delta*speedDecay,minDecay*delta)
	
	moveDirection*=initialVelocity

#	moveDirection=clamp(moveDirection,-v3Speed,v3Speed)
#	moveDirection*=compareVelocities(moveDirection,root.linear_velocity)
	root.velocity+=(moveDirection)
	
	#trigger jumping state upon jump
	if Input.is_action_just_pressed("jump")&&root.get_node("CoyoteTimerNode").canJump():
		revertMesh()
		get_parent().setActiveState("PlayerJumpingState")
	#return to walking state when exhausted initialvelocity
	if initialVelocity<=0.:
		revertMesh()
		get_parent().setActiveState("PlayerWalkingState")

