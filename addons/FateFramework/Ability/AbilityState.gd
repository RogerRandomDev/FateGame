extends Node
class_name AbilityState
##the base node for Abilities
##handled using a [AbilityManagerNode]

##the [AbilityResource] for the ability's data and effects
@export var abilityResource:AbilityResource

##a [PhysicsShapeQueryParameters3D] to use for the ability area of effect
var abilityArea:PhysicsShapeQueryParameters3D=PhysicsShapeQueryParameters3D.new()
##stored to prevent having to call multiple times
var space_state:PhysicsDirectSpaceState3D
##the root node, should usually be a [RigidBody3D] acting as an [annotation entity] or [annotation player]
var root:Node3D

##main ability just activated
var justTrigered:bool=false
##secondary ability just activated
var justTrigeredSecondary:bool=false
#motion ability just activated
var justTriggeredMotion:bool=false
func _ready():
	
	root=get_parent().get_parent()
	space_state=get_viewport().find_world_3d().direct_space_state
	abilityResource._inheritedRoot=root

#updates ability timers
func _process(delta):
	abilityResource._process()


func _unhandled_input(event):
	#prevents double-trigger if moving mouse while pressing
	#not sure why it does that but i'm guessing 2 actions same frame, so it counted it still
	
	if Input.is_action_just_pressed("TriggerAbility")&&abilityResource._mainTimeLeft<=0.:
		if !abilityResource.attemptTriggerMain():return
		abilityResource._mainTimeLeft=abilityResource.abilityDelay
		justTrigered=true
		AbilityTrigger()
	if Input.is_action_just_released("TriggerAbility")&&justTrigered:
		justTrigered=false
		AbilityRelease()
	if Input.is_action_just_pressed("TriggerAbilitySecondary")&&abilityResource._secondaryTimeLeft<=0.:
		if !abilityResource.attemptTriggerSecondary():return
		abilityResource._secondaryTimeLeft=abilityResource.secondaryAbilityDelay
		justTrigeredSecondary=true
		AbilitySecondaryTrigger()
	if Input.is_action_just_released("TriggerAbilitySecondary")&&justTrigeredSecondary:
		justTrigeredSecondary=false
		AbilitySecondaryRelease()
	if Input.is_action_just_pressed("TriggerAbilityMotion")&&abilityResource._motionTimeLeft<=0.:
		if !abilityResource.attemptTriggerMotion():return
		abilityResource._motionTimeLeft=abilityResource.motionAbilityDelay
		justTriggeredMotion=true
		AbilityMotionTrigger()
	if Input.is_action_just_released("TriggerAbilityMotion")&&justTriggeredMotion:
		justTriggeredMotion=false
		AbilityMotionRelease()


##sets the [member abilityArea] shape
func setShape(shape:Shape3D)->void:abilityArea.shape=shape
##updates the transform of the [member abilityArea]
func setShapeTransform(new_transform:Transform3D)->void:abilityArea.transform=new_transform

##returns an array of all the nodes that intersect [member abilityArea]
func getEntitiesInRange()->Array:
	var collisions:=space_state.intersect_shape(abilityArea)
	return collisions.map(func(val):return val.collider)



#everything below is per-ability
#change them as needed to match needs

##run whenever you choose the given ability
func onTrigger()->void:pass


#ability trigger functions

##runs when triggering the [annotation primary ability]
func AbilityTrigger()->void:pass
##runs on releasing the [annotation primary ability]
func AbilityRelease()->void:pass
##runs when triggering the [annotation secondary ability]
func AbilitySecondaryTrigger()->void:pass
##runs on releasing the [annotation secondary ability]
func AbilitySecondaryRelease()->void:pass
##runs when triggering the [annotation motion ability]
func AbilityMotionTrigger()->void:pass
##runs on releasing the [annotation motion ability]
func AbilityMotionRelease()->void:pass

#ability drawing function
#put in the code that creates the vfx for the ability itself
##DEPRACATED FUNCTION
func drawAbilityEffect()->void:pass
