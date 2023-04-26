extends Node
class_name AbilityManagerNode
##manages swapping and handling the abilities and [AbilityState]

##the current ability in use
var activeAbility:Node;

#disasbles all Abilitys by default
func _ready():
	for ability in get_children():
		setAbilityProcess(ability,false)
	setAbilityProcess(get_child(0),true)




##sets the [member activeAbility] if the Ability Parameter exists
func setActiveAbility(Ability:String):
	var newAbility=get_node_or_null(Ability)
	if(newAbility==null):return
	
	if(activeAbility!=null):setAbilityProcess(activeAbility,false)
	setAbilityProcess(newAbility,true)
	activeAbility=newAbility


##changes process mode for any Abilities[br]
##does not disable [method _process] so as to allow miscellaneous functionality[br]
##calls [method AbilityState.onTrigger] to the activated ability if set to process true
func setAbilityProcess(Ability:Node,process:bool)->void:
	Ability.set_physics_process(process)
	Ability.set_process_input(process)
	Ability.set_physics_process_internal(process)
	if(process):Ability.onTrigger()

##returns relevant [AbilityState]
func getAbility(Ability:String)->AbilityState:
	return get_node_or_null(Ability);
