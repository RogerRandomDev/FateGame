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
	tween.tween_callback(AbilityNode.queue_free)

