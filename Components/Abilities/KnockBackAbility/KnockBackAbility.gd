extends AbilityState
class_name KnockBackAbility

@export var range:float:
	set(value):
		range=value
		updateShape()
	get:return range
@export var power:float

func _ready():
	super._ready()
	updateShape()

func updateShape():
	var s=SphereShape3D.new()
	s.radius=range
	setShape(s)


func AbilityTrigger():
	var ability=abilityResource.MainEffect.getNode(root)
	
	setShapeTransform(root.global_transform)
	var targets=getEntitiesInRange()
	for target in targets:
		if target is RigidBody3D:
			var dir=(target.global_position-root.global_position)
			
			target.apply_central_impulse(-(dir.normalized()*(dir.length()-range)/range)*power)
func AbilitySecondaryTrigger():
	var ability=abilityResource.SecondaryEffect.getNode(root)
	setShapeTransform(root.global_transform)
	var targets=getEntitiesInRange()
	for target in targets:
		if target is RigidBody3D:
			var dir=(target.global_position-root.global_position)
			
			target.apply_central_impulse((dir.normalized()*(dir.length()-range)/range)*power)


func AbilityMotionTrigger():
	var r:=PhysicsRayQueryParameters3D.new()

	r.from=root.global_transform.origin
	r.exclude=[root]
	r.to=r.from-Vector3(sin(root.rotation.y),sin(-root.get_node("CameraArm").rotation.x),cos(root.rotation.y))*8.
	var col:=space_state.intersect_ray(r)
	var moveTo=r.to
	if col:
		moveTo=col.position-r.from.direction_to(r.to)*Vector3(1,2,1)
	root.moveTo(moveTo)
	var data={'travelDistance':moveTo-r.from,'origin':r.from}
	var ability=abilityResource.MotionEffect.getNode(root.get_parent())
	
	
	ability.look_at_from_position(data.origin,data.travelDistance+data.origin)
	
	ability.global_position=data.origin+data.travelDistance/2.+Vector3(0,1,0)
	ability.process_material.set_shader_parameter("emission_box_extents",Vector3(0.25,1,data.travelDistance.length()/2.))






func drawMotionAbilityEffect(norm:bool=true,data:Dictionary={}):
	var ability=GPUParticles3D.new()
	
	
	ability.amount=32
	ability.explosiveness=1
	ability.draw_pass_1=PlaneMesh.new()
	ability.draw_pass_1.size=Vector2(0.1,0.1)
	ability.draw_pass_1.orientation=PlaneMesh.FACE_Z
	var b=PlaneMesh.new()
	
	var a=StandardMaterial3D.new()
	a.billboard_mode=BaseMaterial3D.BILLBOARD_ENABLED
	
	ability.draw_pass_1.surface_set_material(0,a)
	ability.process_material=load("res://Components/Abilities/KnockBackAbility/knockBackAbilityMotion.tres")
	root.get_parent().add_child(ability)
	
	
