extends Node
class_name StateManagerNode
##Manager For handling [StateNode]

##current [StateNode] in use
var activeState:Node;

#prevents changing state when false
var canChange:bool=true
#disasbles all states by default
func _ready():
	for state in get_children():
		setStateProcess(state,false)




##sets the active state if available
func setActiveState(state:String)->Node:
	if !canChange:return
	var newState=get_node_or_null(state)
	if(newState==null):return
	
	if(activeState!=null):setStateProcess(activeState,false)
	setStateProcess(newState,true)
	activeState=newState
	return newState


##changes process mode for any states
func setStateProcess(state:Node,process:bool):
	state.set_physics_process(process)
	state.set_process_input(process)
	state.set_physics_process_internal(process)
	if(process):state.onTrigger()

##returns relevant state
func getState(state:String):
	return get_node_or_null(state);


##runs the method of the given name on all the states.
##returns an array of the returned values.
##could probably be most used for adding a "downed" state before dying.
##Or to add a dying state to allow for an animation to run first
func attemptRunAll(funcName:String,nodeCalled:Node)->Array:
	var returnedValues:Array=[]
	for state in get_children():
		#need to implement this into weapons later
		if state.has_method(funcName):returnedValues.push_back(state.call(funcName,nodeCalled))
	
	return returnedValues
##locks changing
func lock()->void:canChange=false
##unlocks changing
func unlock()->void:canChange=true
