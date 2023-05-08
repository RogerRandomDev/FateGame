extends AbilityState
class_name KnockBackAbility

@export var rangeOf:float:
	set(value):
		rangeOf=value
		updateShape()
	get:return rangeOf
@export var power:float


func _ready():
	super._ready()
	updateShape()
	if root.get_node_or_null("Model/AbilityOrigin"):
		abilityResource.PassiveEffect.loadPassive.call_deferred(root.get_node("Model/AbilityOrigin"),root)
func updateShape():
	var s=SphereShape3D.new()
	s.radius=rangeOf
	setShape(s)


func AbilityTrigger():
	var _ability=abilityResource.MainEffect.getNode(root)
	
	setShapeTransform(root.global_transform)
	var targets=getEntitiesInRange()
	for target in targets:
		if target is RigidBody3D:
			var dir=(target.global_position-root.global_position)
			
			target.apply_central_impulse(-(dir.normalized()*(dir.length()-rangeOf)/rangeOf)*power)
func AbilitySecondaryTrigger():
	var _ability=abilityResource.SecondaryEffect.getNode(root)
	setShapeTransform(root.global_transform)
	var targets=getEntitiesInRange()
	for target in targets:
		if target is RigidBody3D:
			var dir=(target.global_position-root.global_position)
			
			target.apply_central_impulse((dir.normalized()*(dir.length()-rangeOf)/rangeOf)*power)

func AbilityMotionTrigger():
#	var state=root.get_node("States").setActiveState("ChargingState")
#	state.chargeDirection=Vector3(sin(root.rotation.y),sin(-root.get_node("CameraArm").rotation.x),cos(root.rotation.y))
	var r:=PhysicsRayQueryParameters3D.new()
	
	r.from=root.global_transform.origin
	r.exclude=[root]
	#sets modifier to direction of motion if moving above 2 linear_velocity
	#otherwise sets it to direction of the camera
	var modifier=root.linear_velocity.normalized() if root.linear_velocity.length_squared()>2 else -Vector3(sin(root.rotation.y),sin(-root.get_node("CameraArm").rotation.x),cos(root.rotation.y))
	r.to=r.from+modifier*8.
	var col:=space_state.intersect_ray(r)
	var moveTo=r.to
	if col:moveTo=col.position+col.normal
		
	
	var data={'travelDistance':moveTo-r.from,'origin':r.from}
	var ability=abilityResource.MotionEffect.getNode(root.get_parent())
	
	ability.global_position=data.origin+data.travelDistance/2.+Vector3(0,1,0)
	
	#can't run a look_at if the direction matches the up vector, so i check if it is close
	#and just rotate it up if it is instead
	if(abs((r.to-ability.global_position).normalized()).y>=0.99):ability.rotation.x=PI/2
	else:ability.look_at(r.to)
	
	root.moveTo(moveTo)
	ability.process_material.set_shader_parameter("emission_box_extents",Vector3(0.25,1,data.travelDistance.length()/2.))







##intercept the death attempt for self and prevents it
func attemptingToDie(nodeCalled:Node):
	var stat=root.get_node("Statistics").getStatistic("Energy")
	if not stat:return 'dontDie'
	if !stat.attemptCast(nodeCalled._remainderLeft):return 'failedSave'
	
	stat.changeBy(-nodeCalled._remainderLeft)
	nodeCalled.changeBy(1)
	
	return 'dontDie'
