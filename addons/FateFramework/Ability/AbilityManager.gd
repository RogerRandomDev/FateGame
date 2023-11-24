extends Node
class_name AbilityManagerNode
##manages swapping and handling the abilities and [AbilityState]

##used primarily by the [AbilityResource] for special functionality
signal AbilityTriggered
##used primarily by the [AbilityResource] for special functionality
signal AbilityReleased
##used primarily by the [AbilityResource] for special functionality
signal SecondaryAbilityTriggered
##used primarily by the [AbilityResource] for special functionality
signal SecondaryAbilityReleased
##used primarily by the [AbilityResource] for special functionality
signal MotionAbilityTriggered
##used primarily by the [AbilityResource] for special functionality
signal MotionAbilityReleased

##the current ability in use
var activeAbility:Node;


#disasbles all Abilitys by default
func _ready():
	for ability in get_children():
		setAbilityProcess(ability,false)
	setActiveAbility("KnockBackAbility")


##triggers the ability based from order main secondary motoin
func triggerAbility(ability:int):
	if not activeAbility:return
	match ability:
		0:
			if activeAbility.abilityResource._mainTimeLeft<=0.:
				if !activeAbility.abilityResource.attemptTriggerMain():return
				activeAbility.abilityResource._mainTimeLeft=activeAbility.abilityResource.abilityDelay
				activeAbility.justTriggered=true
				emit_signal('AbilityTriggered')
		1:
			if activeAbility.abilityResource._secondaryTimeLeft<=0.:
				if !activeAbility.abilityResource.attemptTriggerSecondary():return
				activeAbility.abilityResource._secondaryTimeLeft=activeAbility.abilityResource.secondaryAbilityDelay
				activeAbility.justTriggeredSecondary=true
				emit_signal('SecondaryAbilityTriggered')
		2: if activeAbility.abilityResource._motionTimeLeft<=0.:
			var timeTaken=abs(activeAbility.abilityResource._last_motion_press-Time.get_ticks_msec())
			#forces it to be a double-press, and makes sure it wasnt instant to stop a bug
			if timeTaken<=250&&timeTaken!=0:
				if !activeAbility.abilityResource.attemptTriggerMotion():return
				activeAbility.abilityResource._motionTimeLeft=activeAbility.abilityResource.motionAbilityDelay
				activeAbility.justTriggeredMotion=true
				emit_signal('MotionAbilityTriggered')
			else:
				activeAbility.abilityResource._last_motion_press=Time.get_ticks_msec()
##releases the ability based from order main secondary motoin
func releaseAbility(ability:int):
	if not activeAbility:return
	match ability:
		0:
			if activeAbility.justTriggered:
				activeAbility.justTriggered=false
				emit_signal('AbilityReleased')
		1: if activeAbility.justTriggeredSecondary:
			activeAbility.justTriggeredSecondary=false
			emit_signal('SecondaryAbilityReleased')
		2: if activeAbility.justTriggeredMotion:
			activeAbility.justTriggeredMotion=false
			emit_signal('MotionAbilityReleased')



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
	
	Ability.justTriggered=false
	Ability.justTriggeredSecondary=false
	Ability.justTriggeredMotion=false
	Ability.set_physics_process(process)
	Ability.set_process_input(process)
	Ability.set_physics_process_internal(process)
	if(process):Ability.onTrigger()

##returns relevant [AbilityState]
func getAbility(Ability:String)->AbilityState:
	return get_node_or_null(Ability);


##runs the method of the given name on all the abilities
##returns an array of the returned values
func attemptRunAll(funcName:String,nodeCalled:Node)->Array:
	var returnedValues:Array=[]
	for ability in get_children():
		if ability.has_method(funcName):returnedValues.push_back(ability.call(funcName,nodeCalled))
	
	return returnedValues
