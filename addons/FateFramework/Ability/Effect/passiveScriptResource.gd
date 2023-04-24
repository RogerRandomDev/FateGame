extends Node
class_name PassiveScriptResource

var root:Node
var shapeQuery=PhysicsShapeQueryParameters3D.new()




func checkWithinRange(pos:Vector3,range:float):
	shapeQuery.exclude=[root]
	
	shapeQuery.shape=SphereShape3D.new()
	shapeQuery.shape.radius=range
	shapeQuery.transform.origin=pos
	
	var col:=get_viewport().world_3d.direct_space_state.intersect_shape(shapeQuery)
	
	return col
