@tool
extends AbilityEffectResource
class_name AbilityMeshResource
##Ability Effect that uses a [MeshInstance3D]


##[Mesh] for the ability effect
@export var AbilityMesh:Mesh


##returns a [MeshInstance3D] with [member AbilityMesh] applied[br]
func getNode(addTo:Node)->Node3D:
	var AbilityNode=MeshInstance3D.new()
	AbilityNode.mesh=AbilityMesh
	addTo.add_child(AbilityNode)
	loadAnimation(AbilityNode,addTo)
	return AbilityNode


##applies the animation to the ability effect in the same way as [AbilityEffectResource]
##ignoreFree is used by the inspector plugin to prevent issues
func loadAnimation(AbilityNode:Node3D,root:Node,ignoreFree:bool=false)->Tween:
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
		if AbilityShaderProgressionValue!="":
			tween.parallel().tween_method(func(val):AbilityNode.mesh.surface_get_material(0).set_shader_parameter(AbilityShaderProgressionValue,val),lastFrameShaderParameter,AbilityAnimationFrame.shaderParameter,AbilityAnimationFrame.duration)
			lastFrameShaderParameter=AbilityAnimationFrame.shaderParameter
		tween.tween_interval(AbilityAnimationFrame.delay)
	if !ignoreFree:tween.tween_callback(AbilityNode.queue_free)
	return tween
