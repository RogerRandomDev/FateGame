extends PlayerController
class_name PlayerJumpingState

const JUMP_DAMPING:float=0.5

func onTrigger():
	root.linear_velocity.y=root.jumpForce
#	root.apply_central_force(Vector3(0,root.jumpForce,0))
	
#updates current motion for the root node
func _physics_process(delta):
	var moveDirection=applyFacingDirection(Vector2(
		Input.get_axis("forward","backward"),
		Input.get_axis("left","right")
		))*root.SPEED*JUMP_DAMPING

#	moveDirection=clamp(moveDirection,-v3Speed,v3Speed)
#	moveDirection*=compareVelocities(moveDirection,root.velocity)
	moveDirection*=16
	root.velocity+=(moveDirection)
	#return to walking
	if root.is_on_floor()&&root.velocity.y<=0.:
		get_parent().setActiveState("PlayerWalkingState")
	#trigger dash
	if Input.is_action_just_pressed("dash")&&get_parent().getState("PlayerDashingState").canDash():
		get_parent().setActiveState("PlayerDashingState")
