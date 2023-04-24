@tool
extends AbilityEffectResource
class_name AbilityParticleResource


@export var AbilityParticles:ShaderMaterial
@export var ParticlesMesh:Mesh
@export_range(0.,1.) var Explosiveness:float=0.
@export var Lifetime:float=0.
@export var particleAmount:int=16
@export var one_shot:bool


func getNode(addTo:Node):
	var AbilityNode=GPUParticles3D.new()
	AbilityNode.lifetime=Lifetime
	AbilityNode.explosiveness=Explosiveness
	AbilityNode.amount=particleAmount
	AbilityNode.one_shot=one_shot
	
	AbilityNode.process_material=AbilityParticles
	AbilityNode.draw_pass_1=ParticlesMesh
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
