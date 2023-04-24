@tool
extends Resource
class_name AbilityEffectResource


@export var AbilityShaderProgressionValue:String

@export var AbilityMeshAnimations:Array[Dictionary]:
	set(value):
		if value.size()>0:
			if value[value.size()-1]=={}:
				value[value.size()-1]={
					"offset":Vector3(),
					"rotation":Vector3(),
					"scale":Vector3.ONE,
					"duration":float(),
					"delay":float(),
					"shaderParameter":float()
				}
				if(value.size()-1==0):value[0].erase("duration")
		AbilityMeshAnimations=value
	get:return AbilityMeshAnimations

@export var NextPass:AbilityEffectResource


func getNode(addTo:Node):
	var AbilityNode=MeshInstance3D.new()
	addTo.add_child(AbilityNode)
	loadAnimation(AbilityNode,addTo)
	if NextPass:
		NextPass.getNode(AbilityNode)
	return AbilityNode



func loadAnimation(AbilityNode,root:Node):
	var tween:Tween=root.create_tween()
	AbilityNode.position=AbilityMeshAnimations[0].offset
	AbilityNode.rotation=AbilityMeshAnimations[0].rotation
	AbilityNode.scale=AbilityMeshAnimations[0].scale
	var lastFrameShaderParameter=AbilityMeshAnimations[0].shaderParameter
	tween.tween_interval(AbilityMeshAnimations[0].delay)
	for i in range(1,AbilityMeshAnimations.size()):
		var AbilityAnimationFrame=AbilityMeshAnimations[i]
		tween.tween_property(AbilityNode,"position",AbilityAnimationFrame.offset,AbilityAnimationFrame.duration)
		tween.parallel().tween_property(AbilityNode,"rotation",AbilityAnimationFrame.scale,AbilityAnimationFrame.duration)
		tween.parallel().tween_property(AbilityNode,"scale",AbilityAnimationFrame.scale,AbilityAnimationFrame.duration)
		tween.tween_interval(AbilityAnimationFrame.delay)
		if AbilityShaderProgressionValue!="":
			tween.tween_method(func(val):AbilityNode.mesh.surface_get_material(0).set_shader_parameter(AbilityShaderProgressionValue,val),lastFrameShaderParameter,AbilityAnimationFrame.shaderParameter,AbilityAnimationFrame.duration)
			lastFrameShaderParameter=AbilityAnimationFrame.shaderParameter
	

