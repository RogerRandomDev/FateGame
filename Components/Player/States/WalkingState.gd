extends PlayerController
class_name PlayerWalkingState



#updates current motion for the root node
func _physics_process(_delta):
	buildInput(_delta)
	var baseInput=inputBuild
	baseInput.x*=0.25+0.5*float(baseInput.x<0.0)*(1+int(Input.is_action_pressed("TriggerAbilityMotion")))
	
	var moveDirection=applyFacingDirection(baseInput)
	
#	moveDirection=clamp(moveDirection,-v3Speed,v3Speed)
#	moveDirection*=compareVelocities(moveDirection,root.linear_velocity)
	moveDirection*=4
	root.velocity+=(moveDirection)*root.SPEED
	current_input_motions=baseInput
	#trigger jumping state upon jump
	if Input.is_action_just_pressed("jump")&&root.get_node("CoyoteTimerNode").canJump():
		get_parent().setActiveState("PlayerJumpingState")
	#trigger dash
	if Input.is_action_just_pressed("dash")&&get_parent().getState("PlayerDashingState")&&get_parent().getState("PlayerDashingState").canDash():
		get_parent().setActiveState("PlayerDashingState")
	#trigger slide
	if Input.is_action_just_pressed("slide"):
		get_parent().setActiveState("PlayerSlidingState")
	updateAnimation()


func updateAnimation()->void:
	var player=root.get_node("Model/AnimationTree")
	var motion=current_input_motions
	var myAction="Idle"
	if motion.length_squared()>0.5:myAction="Moving"
	root.anim_data["motion"]=motion
	root.anim_data["state"]=myAction
	player.set("parameters/Moving/blend_position",motion.x*0.5)
	
