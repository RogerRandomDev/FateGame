extends Resource
class_name AbilityResource

@export var Name:String
@export_multiline var Description:String

@export var AbilityScript:Script


#returns the ability node for the resource
func getAbilityNode()->AbilityState:
	var state=AbilityState.new()
	state.set_script(AbilityScript)
	return state



func getName()->String:
	return Name

func getDescription()->String:
	return Description
