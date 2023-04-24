extends StateNode
class_name PlayerController







var v3Speed:Vector3



func _ready():
	root=get_parent().get_parent()
	v3Speed=Vector3(root.SPEED,root.SPEED,root.SPEED)



#applies damping force based on directions
func compareVelocities(vel0,vel1):
	var accelOrDecel=vel0.normalized().dot(vel1.normalized()) > 0
	print(vel0.normalized().dot(vel1.normalized()))
	return Vector3(
		root.accelSpeed if accelOrDecel else root.decelSpeed,
		1.,
		root.accelSpeed if accelOrDecel else root.decelSpeed
	)

#rotates the input vector by the current rotation basis of the root node
func applyFacingDirection(inputVector:Vector2)->Vector3:
	var direction=(root.transform.basis * Vector3(inputVector.y,0,inputVector.x)).normalized()*inputVector.length()
	return direction

