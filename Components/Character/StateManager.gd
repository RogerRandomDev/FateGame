extends Node
class_name StateManagerNode


var activeState:Node;

#disasbles all states by default
func _ready():
	for state in get_children():
		setStateProcess(state,false)




#sets the active state if available
func setActiveState(state:String):
	var newState=get_node_or_null(state)
	if(newState==null):return
	
	if(activeState!=null):setStateProcess(activeState,false)
	setStateProcess(newState,true)
	activeState=newState


#changes process mode for any states
func setStateProcess(state:Node,process:bool):
	state.set_physics_process(process)
	state.set_process_input(process)
	state.set_physics_process_internal(process)
	if(process):state.onTrigger()

#returns relevant state
func getState(state:String):
	return get_node_or_null(state);
