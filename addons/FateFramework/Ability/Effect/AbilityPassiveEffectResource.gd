@tool
extends Resource
class_name AbilityPassiveEffect
##Creates the passive effect for the [AbilityPassiveResource]


##mesh for the effect[br]
##will be the particle mesh if [member EffectParticles] is not null
@export var EffectMesh:Mesh
##Script that is attached to the effect
@export var effectScript:Script
@export_group("AnimationData")
##duration in seconds of the animation
@export var animationLength:float=1.
##Animation keys for the effect[br]
##supports position, rotation, scale, and calling functions
@export var EffectAnimationKeys:Array[Dictionary]:
	set(value):
		if(value.size()>0):
			if(value[value.size()-1]=={}):
				value[value.size()-1]={
					"Parameter":"",
					"Value":Vector3(),
					"Time":float()
				}
			
		EffectAnimationKeys=value
@export_group("Particles")
##Sets the [GPUParticles3D] if it is not null
##uses the [member EffectMesh] for particle mesh if not null
@export var EffectParticles:ShaderMaterial
##amount of particles
@export var Amount:int
##particle lifetime
@export var LifeTime:float
##particle explosiveness
@export var Explosiveness:int

##loads the effect into the scene attached to the attachTo[br]
##returns the created effect node
func loadEffect(attachTo:Node,root:Node)->Node:
	#defaults to setting particles if they exist
	#trying to optimize is painful
	var effectNode=MeshInstance3D.new()
	if EffectParticles:
		var particles=GPUParticles3D.new()
		particles.process_material=EffectParticles
		particles.mesh=EffectMesh
	else:
		effectNode=MeshInstance3D.new()
		effectNode.mesh=EffectMesh
		
	attachTo.add_child(effectNode)
	#adds the effect script only if it exists
	if effectScript:
		var effectScriptNode=Node.new()
		effectScriptNode.name="effectScript"
		effectScriptNode.set_script(effectScript)
		effectScriptNode.root=root
		effectNode.add_child(effectScriptNode)
	
	if EffectAnimationKeys.size():loadAnimation(effectNode)
	return effectNode

#creates the animation for the passive effect
#i prefer tweens, but in this situation
#they are just less versatile for it
#not to mention more taxing on the cpu
#since i would have to recreate it each loop
##loads the animation using the [member EffectAnimationKeys] and [member animationLength]
func loadAnimation(animateOn:Node3D)->void:
	var animationHolder:=AnimationPlayer.new()
	var nodeAnimation=Animation.new()
	var animationLibrary:=AnimationLibrary.new()
	animateOn.add_child(animationHolder)
	#creates the library and animation name to bind to the player
	animationLibrary.add_animation("passive",nodeAnimation)
	animationHolder.add_animation_library("passive",animationLibrary)
	
	#adds tracks and binds them to the node to animate
	nodeAnimation.add_track(Animation.TYPE_POSITION_3D)
	nodeAnimation.add_track(Animation.TYPE_ROTATION_3D)
	nodeAnimation.add_track(Animation.TYPE_SCALE_3D)

	#binds rest the tracks to root node
	for i in range(0,3):nodeAnimation.track_set_path(i,"../")
	#binds callback track to run on the custom script for the passive effect
	if effectScript:
		nodeAnimation.add_track(Animation.TYPE_METHOD)
		nodeAnimation.track_set_path(3,"effectScript")
	
	
	for keyFrame in EffectAnimationKeys:
		var trackNumber=getTrackNumber(keyFrame.Parameter)
		nodeAnimation.track_insert_key(trackNumber,keyFrame.Time,keyFrame.Value)
	nodeAnimation.loop_mode=Animation.LOOP_LINEAR
	
	animationHolder.play("passive/passive")
	nodeAnimation.length=animationLength


##returns the related number to set the
##animation track to based on the param
func getTrackNumber(param:String)->int:
	return (
		int(param=="position")+
		int(param=="rotation")*2+
		int(param=="scale")*3+
		int(param=="methodCall")*4
	)-1
