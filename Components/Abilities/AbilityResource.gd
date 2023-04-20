@tool
extends Resource
class_name AbilityResource

@export var Name:String
@export_group("Descriptions")
@export_subgroup("Main")
@export var hasMain:bool=false
@export_multiline var MainDescription:String
@export_subgroup("Secondary")
@export var hasSecondary:bool=false
@export_multiline var SecondaryDescription:String
@export_subgroup("Motion")
@export var hasMotion:bool=false
@export_multiline var MotionDescription:String
@export_subgroup("Passive")
@export var hasPassive:bool=false
@export_multiline var PassiveDescription:String
@export_group("")
@export var AbilityScript:Script


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



