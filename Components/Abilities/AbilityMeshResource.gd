@tool
extends AbilityEffectResource
class_name AbilityMeshResource


@export var AbilityMesh:Mesh



func getNode(addTo:Node):
	var AbilityNode=MeshInstance3D.new()
	AbilityNode.mesh=AbilityMesh
	addTo.add_child(AbilityNode)
	loadAnimation(AbilityNode,addTo)
	return AbilityNode



func loadAnimation(AbilityNode,root:Node):
	var tween:Tween=root.create_tween()
	AbilityNode.position=AbilityMeshTransformations[0].basis.x
	AbilityNode.rotation=AbilityMeshTransformations[0].basis.y
	AbilityNode.scale=AbilityMeshTransformations[0].basis.z
	if AbilityShaderProgressionValue!="":AbilityNode.mesh.surface_get_material(0).set_shader_parameter(AbilityShaderProgressionValue,AbilityMeshTransformations[0].origin.z)
	
	var lastParam=AbilityMeshTransformations[0].origin.z
	for i in range(1,AbilityMeshTransformations.size()):
		var AbilityTransformation=AbilityMeshTransformations[i]
		tween.tween_property(AbilityNode,"position",AbilityTransformation.basis.x,AbilityTransformation.origin.x)
		tween.parallel().tween_property(AbilityNode,"rotation",AbilityTransformation.basis.y,AbilityTransformation.origin.x)
		tween.parallel().tween_property(AbilityNode,"scale",AbilityTransformation.basis.z,AbilityTransformation.origin.x)
		if AbilityShaderProgressionValue!="":tween.parallel().tween_method(func(val):AbilityNode.mesh.surface_get_material(0).set_shader_parameter(AbilityShaderProgressionValue,val),lastParam,AbilityTransformation.origin.z,AbilityTransformation.origin.x)
		lastParam=AbilityTransformation.origin.z
		tween.tween_interval(AbilityTransformation.origin.y)
	tween.tween_callback(AbilityNode.queue_free)
	
	

