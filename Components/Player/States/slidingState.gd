extends PlayerController
class_name PlayerSlidingState

@export var slideSpeedMult:float=2.0
@export var speedDecay:float=0.9
@export var minDecay:float=10.
@export var downhillGain:float=5.
var initialVelocity:float=0.
var initialDirection:Vector3=Vector3.FORWARD
func onTrigger():
	initialVelocity=root.linear_velocity.length()
	initialDirection=(root.linear_velocity*Vector3(1,0,1)).normalized()
	root.get_node("Model").rotation.x+=PI/2.5
	root.get_node("Model").position.y-=0.5
	
func revertMesh():
	root.get_node("Model").rotation.x-=PI/2.5
	root.get_node("Model").position.y+=0.5
	
#updates current motion for the root node
func _physics_process(delta):
	
	initialVelocity-=root.linear_velocity.y*delta * downhillGain * int(root.on_floor)
	var faceDir=root.getFaceDirection()
	faceDir=-Vector3(sin(faceDir.y),0,cos(faceDir.y))
	var dir=applyFacingDirection(Vector2(Input.get_axis("forward","backward"),Input.get_axis("left","right")))
	if(dir==Vector3.ZERO):dir=applyFacingDirection(Vector2(-1,0))
	dir=(dir+faceDir*2)/3
	initialDirection=initialDirection.move_toward(dir,delta*5)
	var moveDirection=initialDirection*root.SPEED*slideSpeedMult
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

