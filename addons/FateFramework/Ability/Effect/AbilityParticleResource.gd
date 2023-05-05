@tool
extends AbilityEffectResource
class_name AbilityParticleResource
##Ability Effect that uses a [GPUParticles3D]

##The [ShaderMaterial] for the particles
@export var AbilityParticles:ShaderMaterial
##The [Mesh] for the particles
@export var ParticlesMesh:Mesh
##Particle Explosiveness
@export_range(0.,1.) var Explosiveness:float=0.
##Particle lifetime
@export var Lifetime:float=0.
##particle quantity
@export var particleAmount:int=16
##if particles are one shot or not
@export var one_shot:bool

##returns a [GPUParticles3D] with the [member Lifetime] [member particleAmount] [member Explosiveness] and [member one_shot] applied[br]
func getNode(addTo:Node)->Node3D:
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

##animates the [GPUParticles3D] in the same way as [AbilityEffectResource]
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
