@tool
extends Resource
class_name AbilityEffectResource
##Resource for handling ability effect[br]
##extend this to create more varied sub-effects[br]
##used by [AbilityMeshResource] and [AbilityParticleResource]

##the shader parameter to be modified by [member AbilityMeshAnimations][br]
##only supports floats
@export var AbilityShaderProgressionValue:String

##creates the animation format for parsing in [method loadAnimation]
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
##creates a second [AbilityEffectResource] after itself[br]
##used to create multi-layered effects
@export var NextPass:AbilityEffectResource

##creates the ability node and loads the animations onto it[br]
##then adds self as child to addTo before calling [method loadAnimation]
func getNode(addTo:Node)->Node3D:
	var AbilityNode=Node3D.new()
	addTo.add_child(AbilityNode)
	loadAnimation(AbilityNode,addTo)
	if NextPass:
		NextPass.getNode(AbilityNode)
	return AbilityNode


##loads the animation from [member AbilityMeshAnimations] into a [Tween][br]
func loadAnimation(AbilityNode:Node3D,root:Node)->Tween:
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
	return tween

