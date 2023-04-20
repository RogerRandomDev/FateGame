@tool
extends Resource
class_name AbilityEffectResource


@export var AbilityShaderProgressionValue:String

@export var AbilityMeshTransformations:Array[Transform3D]



func getNode(addTo:Node):
	var AbilityNode=MeshInstance3D.new()
	addTo.add_child(AbilityNode)
	loadAnimation(AbilityNode,addTo)
	
	return AbilityNode



func loadAnimation(AbilityNode,root:Node):
	var tween:Tween=root.create_tween()
	AbilityNode.position=AbilityMeshTransformations[0].basis.x
	AbilityNode.rotation=AbilityMeshTransformations[0].basis.y
	AbilityNode.scale=AbilityMeshTransformations[0].basis.z
	for i in range(1,AbilityMeshTransformations.size()):
		var AbilityTransformation=AbilityMeshTransformations[i]
		tween.tween_property(AbilityNode,"position",AbilityTransformation.basis.x,AbilityTransformation.origin.x)
		tween.parallel().tween_property(AbilityNode,"rotation",AbilityTransformation.basis.y,AbilityTransformation.origin.x)
		tween.parallel().tween_property(AbilityNode,"scale",AbilityTransformation.basis.z,AbilityTransformation.origin.x)
		tween.tween_interval(AbilityTransformation.origin.y)
		if AbilityShaderProgressionValue!="":
			tween.tween_method(func(val):AbilityNode.mesh.surface_get_material(0).set_shader_parameter(AbilityShaderProgressionValue,val),0,AbilityTransformation.origin.z,AbilityTransformation.origin.x)
	

