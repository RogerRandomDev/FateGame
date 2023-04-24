@tool
extends Resource
class_name AbilityResource

@export var Name:String
@export_group("Abilities")
@export_subgroup("Main")
@export var hasMain:bool=false
@export_multiline var MainDescription:String
@export var MainEffect:AbilityEffectResource
@export var abilityDelay:float=0.
var mainTimeLeft:float=0.

@export_subgroup("Secondary")
@export var hasSecondary:bool=false
@export_multiline var SecondaryDescription:String
@export var SecondaryEffect:AbilityEffectResource
@export var secondaryAbilityDelay:float=0.
var secondaryTimeLeft:float=0.

@export_subgroup("Motion")
@export var hasMotion:bool=false
@export_multiline var MotionDescription:String
@export var MotionEffect:AbilityEffectResource
@export var motionAbilityDelay:float=0.
var motionTimeLeft:float=0.

@export_subgroup("Passive")
@export var hasPassive:bool=false
@export_multiline var PassiveDescription:String
@export var PassiveEffect:AbilityPassiveResource

@export_group("")
@export var AbilityScript:Script


var lastTime:int=0
#updates the time left 
func _process():
	var newTime=Time.get_ticks_msec()
	var _delta=(lastTime-newTime)*0.001
	lastTime=newTime
	mainTimeLeft+=_delta
	secondaryTimeLeft+=_delta
	motionTimeLeft+=_delta



#returns the ability node for the resource
func getAbilityNode()->AbilityState:
	var state=AbilityState.new()
	state.set_script(AbilityScript)
	return state



func getName()->String:
	return Name

func getDescription()->Dictionary:
	var out={}
	if hasMain:out.Primary=MainDescription
	if hasSecondary:out.Secondary=SecondaryDescription
	if hasMotion:out.Motion=MotionDescription
	if hasPassive:out.Passive=PassiveDescription
	return out



