extends PlayerController
class_name PlayerWalkingState


#updates current motion for the root node
func _physics_process(delta):
	
	var moveDirection=applyFacingDirection(Vector2(
		Input.get_axis("forward","backward"),
		Input.get_axis("left","right")
		))*root.SPEED

	moveDirection=clamp(moveDirection,-v3Speed,v3Speed)
	moveDirection*=compareVelocities(moveDirection,root.velocity)
	moveDirection.x=moveDirection.x-root.velocity.x*root.DAMPING*root.amplifiedDecelInMotion if moveDirection.x!=0 else -root.velocity.x*root.decelSpeed
	moveDirection.z=moveDirection.z-root.velocity.z*root.DAMPING*root.amplifiedDecelInMotion if moveDirection.z!=0 else -root.velocity.z*root.decelSpeed
	root.velocity+=(moveDirection+root.GRAVITY)*delta
	
	#trigger jumping state upon jump
	if Input.is_action_just_pressed("jump")&&root.get_node("CoyoteTimerNode").canJump():
		get_parent().setActiveState("PlayerJumpingState")
	#trigger dash
	if Input.is_action_just_pressed("dash")&&get_parent().getState("PlayerDashingState").canDash():
		get_parent().setActiveState("PlayerDashingState")
	
