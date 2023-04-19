extends Node
class_name AbilityManagerNode


var activeAbility:Node;

#disasbles all Abilitys by default
func _ready():
	for ability in get_children():
		setAbilityProcess(ability,false)
	setAbilityProcess(get_child(0),true)




#sets the active Ability if available
func setActiveAbility(Ability:String):
	var newAbility=get_node_or_null(Ability)
	if(newAbility==null):return
	
	if(activeAbility!=null):setAbilityProcess(activeAbility,false)
	setAbilityProcess(newAbility,true)
	activeAbility=newAbility


#changes process mode for any Abilitys
func setAbilityProcess(Ability:Node,process:bool):
	Ability.set_physics_process(process)
	Ability.set_process_input(process)
	Ability.set_physics_process_internal(process)
	if(process):Ability.onTrigger()

#returns relevant Ability
func getAbility(Ability:String):
	return get_node_or_null(Ability);
