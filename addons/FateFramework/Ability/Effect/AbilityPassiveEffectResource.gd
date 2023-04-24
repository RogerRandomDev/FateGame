@tool
extends Resource
class_name AbilityPassiveEffect


enum test{a,b,c}
@export var EffectMesh:Mesh
@export var effectScript:Script
@export_group("AnimationData")
@export var animationLength:float=1.
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
@export var EffectParticles:ShaderMaterial
@export var Amount:int
@export var LifeTime:int
@export var Explosiveness:int

#loads the effect into the scene attached to the attachTo
func loadEffect(attachTo:Node,root:Node):
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
func loadAnimation(animateOn:Node3D):
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
	

func getTrackNumber(param:String):
	return (
		int(param=="position")+
		int(param=="rotation")*2+
		int(param=="scale")*3+
		int(param=="methodCall")*4
	)-1
