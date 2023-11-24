extends PlayerController
class_name PlayerSlidingState

@export var slideSpeedMult:float=1.0
@export var speedDecay:float=0.2
@export var minDecay:float=60.
@export var downhillGain:float=0.1
var initialVelocity:float=0.
var initialDirection:Vector3=Vector3.FORWARD
var wasAbleToJump:bool=false
func onTrigger():
	initialVelocity=root.velocity.length()
	initialDirection=(root.velocity*Vector3(1,0,1)).normalized()
	wasAbleToJump=root.get_node("CoyoteTimerNode").canJump()
	root.anim_data["state"]="Sliding"

#updates current motion for the root node
func _physics_process(delta):
	wasAbleToJump=wasAbleToJump||root.get_node("CoyoteTimerNode").canJump()
	initialVelocity-=root.velocity.y*delta * downhillGain * int(root.is_on_floor())
	var faceDir=root.getFaceDirection()
	faceDir=-Vector3(sin(faceDir.y),0,cos(faceDir.y))
	var dir=applyFacingDirection(Vector2(Input.get_axis("forward","backward"),Input.get_axis("left","right")))
	if(dir==Vector3.ZERO):dir=applyFacingDirection(Vector2(-1,0))
	dir=(dir+faceDir*2)/3
	initialDirection=initialDirection.move_toward(dir,delta*5)
	var moveDirection=initialDirection*root.SPEED*slideSpeedMult
	initialVelocity-=max(initialVelocity*delta*speedDecay,minDecay*delta)
	
	moveDirection*=initialVelocity
	moveDirection.y+=root.velocity.y+root.GRAVITY.y*delta
#	moveDirection=clamp(moveDirection,-v3Speed,v3Speed)
#	moveDirection*=compareVelocities(moveDirection,root.linear_velocity)
	root.velocity=(moveDirection)
	
	#trigger jumping state upon jump
	if Input.is_action_just_pressed("jump")&&wasAbleToJump:
		get_parent().setActiveState("PlayerJumpingState")
	#return to walking state when exhausted initialvelocity
	if initialVelocity<=0.:
		get_parent().setActiveState("PlayerWalkingState")

