extends Node
class_name PassiveScriptResource
##base resource for [annotation Passive Ability] Scripts

##reference to the [RigidBody3D] that contains the passive
var root:Node
##the shape query for the passive
var shapeQuery=PhysicsShapeQueryParameters3D.new()



##returns all nodes excluding [member root] within range of [member shapeQuery]
func checkWithinRange(pos:Vector3,range:float)->Array:
	shapeQuery.exclude=[root]
	
	shapeQuery.shape=SphereShape3D.new()
	shapeQuery.shape.radius=range
	shapeQuery.transform.origin=pos
	
	var col:=get_viewport().world_3d.direct_space_state.intersect_shape(shapeQuery)
	
	return col
