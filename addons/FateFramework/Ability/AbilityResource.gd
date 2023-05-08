@tool
extends Resource
class_name AbilityResource
##handles storing the information of an ability[br]
##encompases main, secondary, motion, passive, and the name and descriptions


signal PrimaryDelayUpdated(maxDelay:float,curDelay:float)
signal SecondaryDelayUpdated(maxDelay:float,curDelay:float)
signal MotionDelayUpdated(maxDelay:float,curDelay:float)

##Name for the Ability itself
@export var Name:String
@export_group("Abilities")
@export_subgroup("Main")
##main ability exists
@export var hasMain:bool=false
##main ability name
@export var MainName:String
##main ability description
@export_multiline var MainDescription:String
##main ability [AbilityEffectResource]
@export var MainEffect:AbilityEffectResource
##delay between using the main Ability
@export var abilityDelay:float=0.
var _mainTimeLeft:float=0.
##energy used for the main ability
@export var mainAbilityEnergy:int=0.

@export_subgroup("Secondary")
##secondary ability exists
@export var hasSecondary:bool=false
##secondary ability name
@export var SecondaryName:String
##secondary ability description
@export_multiline var SecondaryDescription:String
##secondary ability [AbilityEffectResource]
@export var SecondaryEffect:AbilityEffectResource
##delay between using the secondary ability
@export var secondaryAbilityDelay:float=0.
var _secondaryTimeLeft:float=0.
##energy used for the secondary ability
@export var secondaryAbilityEnergy:int=0.

@export_subgroup("Motion")
##motion ability exists
@export var hasMotion:bool=false
##motion ability name
@export var MotionName:String
##motion ability description
@export_multiline var MotionDescription:String
##motion ability [AbilityEffectResource]
@export var MotionEffect:AbilityEffectResource
##delay between using the motion ability
@export var motionAbilityDelay:float=0.
##energy used for the motion ability
@export var motionAbilityEnergy:int=0.

var _motionTimeLeft:float=0.

@export_subgroup("Passive")
##passive ability exists
@export var hasPassive:bool=false
##passive ability name
@export var PassiveName:String
##passive ability description
@export_multiline var PassiveDescription:String
##passive ability [AbilityPassiveResource]
@export var PassiveEffect:AbilityPassiveResource

@export_group("")
##Primary [Script] for the Ability[br]
##Should extend [AbilityState]
@export var AbilityScript:Script

#this is set to the character containing the ability list
#it is used for getting things like statistics from the character
#using the ability
var _inheritedRoot:Node


var _lastTime:int=0
#updates the time left
func _process():
	var newTime=Time.get_ticks_msec()
	var _delta=(_lastTime-newTime)*0.001
	_lastTime=newTime
	
	if _mainTimeLeft>0.:
		_mainTimeLeft+=_delta
		emit_signal("PrimaryDelayUpdated",abilityDelay,_mainTimeLeft)
	if _secondaryTimeLeft>0.:
		_secondaryTimeLeft+=_delta
		emit_signal("SecondaryDelayUpdated",secondaryAbilityDelay,_secondaryTimeLeft)
	
	if _motionTimeLeft>0.:
		_motionTimeLeft+=_delta
		emit_signal("MotionDelayUpdated",motionAbilityDelay,_motionTimeLeft)



#returns the ability node for the resource
func getAbilityNode()->AbilityState:
	var state=AbilityState.new()
	state.set_script(AbilityScript)
	return state


##returns the [member Name] of the ability itself[br]
##this is different than the names of the ability subsets
##I.E. [member MainName], [member SecondaryName]
func getName()->String:
	return Name

##returns a [Dictionary] containing the data for the ability and it's separate parts
func getDescription()->Dictionary:
	var out={}
	if hasMain:out.Primary={"Name":MainName,"Description":MainDescription,"Cost":mainAbilityEnergy}
	if hasSecondary:out.Secondary={"Name":SecondaryName,"Description":SecondaryDescription,"Cost":secondaryAbilityEnergy}
	if hasMotion:out.Motion={"Name":MotionName,"Description":MotionDescription,"Cost":motionAbilityEnergy}
	if hasPassive:out.Passive={"Name":PassiveName,"Description":PassiveDescription}
	return out

##returns a dictionary of the abilty data
func getAbilityData()->Dictionary:
	var out:Dictionary={}
	#adds the descriptions and names of the component abilities
	out.merge(getDescription())
	
	return out




##returns a [Boolean] based on if you have enough energy to trigger the [annotation Main Ability][br]
##defaults to true if the [annotation Inherited Node] lacks an [annotation Energy Statistic]
func canTriggerMain()->bool:
	return _inheritedRoot.get_node("Statistics").getStatistic("Energy")==null||_inheritedRoot.get_node("Statistics").getStatistic("Energy").attemptCast(mainAbilityEnergy)

##returns a [Boolean] based on if you have enough energy to trigger the [annotation Secondary Ability][br]
##defaults to true if the [annotation Inherited Node] lacks an [annotation Energy Statistic]
func canTriggerSecondary()->bool:
	return _inheritedRoot.get_node("Statistics").getStatistic("Energy")==null||_inheritedRoot.get_node("Statistics").getStatistic("Energy").attemptCast(secondaryAbilityEnergy)

##returns a [Boolean] based on if you have enough energy to trigger the [annotation Motion Ability][br]
##defaults to true if the [annotation Inherited Node] lacks an [annotation Energy Statistic]
func canTriggerMotion()->bool:
	return _inheritedRoot.get_node("Statistics").getStatistic("Energy")==null||_inheritedRoot.get_node("Statistics").getStatistic("Energy").attemptCast(motionAbilityEnergy)

##attempts to trigger the [annotation Main Ability] if [method canTriggerMain] returns true[br]
##if it triggers, it will consume the corresponding [annotation ENERGY] for the ability
func attemptTriggerMain()->bool:
	if !canTriggerMain():return false
	var energy=_inheritedRoot.get_node("Statistics").getStatistic("Energy")
	if energy!=null:energy.changeBy(-mainAbilityEnergy)
	
	return true

##attempts to trigger the [annotation Secondary Ability] if [method canTriggerSecondary] returns true[br]
##if it triggers, it will consume the corresponding [annotation ENERGY] for the ability
func attemptTriggerSecondary()->bool:
	if !canTriggerSecondary():return false
	
	var energy=_inheritedRoot.get_node("Statistics").getStatistic("Energy")
	if energy!=null:energy.changeBy(-secondaryAbilityEnergy)
	
	return true

##attempts to trigger the [annotation Motion Ability] if [method canTriggerMotion] returns true[br]
##if it triggers, it will consume the corresponding [annotation ENERGY] for the ability
func attemptTriggerMotion()->bool:
	if !canTriggerMotion():return false
	
	var energy=_inheritedRoot.get_node("Statistics").getStatistic("Energy")
	if energy!=null:energy.changeBy(-motionAbilityEnergy)
	
	return true

