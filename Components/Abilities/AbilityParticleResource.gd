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
	AbilityNode.position=AbilityMeshTransformations[0].basis.x
	AbilityNode.rotation=AbilityMeshTransformations[0].basis.y
	AbilityNode.scale=AbilityMeshTransformations[0].basis.z
	if AbilityShaderProgressionValue!="":AbilityNode.mesh.surface_get_material(0).set_shader_parameter(AbilityShaderProgressionValue,AbilityMeshTransformations[0].origin.z)
	tween.tween_interval(AbilityMeshTransformations[0].origin.y)
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
