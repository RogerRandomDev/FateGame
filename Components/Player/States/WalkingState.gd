extends PlayerController
class_name PlayerWalkingState


#updates current motion for the root node
func _physics_process(_delta):
	
	var moveDirection=applyFacingDirection(Vector2(
		Input.get_axis("forward","backward"),
		Input.get_axis("left","right")
		))*root.SPEED

#	moveDirection=clamp(moveDirection,-v3Speed,v3Speed)
#	moveDirection*=compareVelocities(moveDirection,root.linear_velocity)
	moveDirection*=16
	root.velocity+=(moveDirection)
	
	#trigger jumping state upon jump
	if Input.is_action_just_pressed("jump")&&root.get_node("CoyoteTimerNode").canJump():
		get_parent().setActiveState("PlayerJumpingState")
	#trigger dash
	if Input.is_action_just_pressed("dash")&&get_parent().getState("PlayerDashingState")&&get_parent().getState("PlayerDashingState").canDash():
		get_parent().setActiveState("PlayerDashingState")
	#trigger slide
	if Input.is_action_just_pressed("slide"):
		get_parent().setActiveState("PlayerSlidingState")
