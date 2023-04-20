extends Node
class_name AbilityState



@export var abilityResource:AbilityResource


var abilityArea:PhysicsShapeQueryParameters3D=PhysicsShapeQueryParameters3D.new()
var space_state:PhysicsDirectSpaceState3D
var root:Node3D

var justTrigered:bool=false
var justTrigeredSecondary:bool=false
var justTriggeredMotion:bool=false
func _ready():
	
	root=get_parent().get_parent()
	space_state=get_viewport().find_world_3d().direct_space_state

#updates ability timers
func _process(delta):
	abilityResource._process()


func _unhandled_input(event):
	#prevents double-trigger if moving mouse while pressing
	#not sure why it does that but i'm guessing 2 actions same frame, so it counted it still
	if not event is InputEventKey:return
	if Input.is_action_just_pressed("TriggerAbility")&&abilityResource.mainTimeLeft<=0.:
		abilityResource.mainTimeLeft=abilityResource.abilityDelay
		justTrigered=true
		AbilityTrigger()
	if Input.is_action_just_released("TriggerAbility")&&justTrigered:
		justTrigered=false
		AbilityRelease()
	if Input.is_action_just_pressed("TriggerAbilitySecondary")&&abilityResource.secondaryTimeLeft<=0.:
		abilityResource.secondaryTimeLeft=abilityResource.secondaryAbilityDelay
		justTrigeredSecondary=true
		AbilitySecondaryTrigger()
	if Input.is_action_just_released("TriggerAbilitySecondary")&&justTrigeredSecondary:
		justTrigeredSecondary=false
		AbilitySecondaryRelease()
	if Input.is_action_just_pressed("TriggerAbilityMotion")&&abilityResource.motionTimeLeft<=0.:
		abilityResource.motionTimeLeft=abilityResource.motionAbilityDelay
		justTriggeredMotion=true
		AbilityMotionTrigger()
	if Input.is_action_just_released("TriggerAbilityMotion")&&justTriggeredMotion:
		justTriggeredMotion=false
		AbilityMotionRelease()



func setShape(shape:Shape3D):abilityArea.shape=shape
func setShapeTransform(new_transform:Transform3D):abilityArea.transform=new_transform

func getEntitiesInRange():
	var collisions:=space_state.intersect_shape(abilityArea)
	return collisions.map(func(val):return val.collider)



#everything below is per-ability
#change them as needed to match needs

#run whenever you choose the given ability
func onTrigger():pass


#ability trigger functions
func AbilityTrigger():pass
func AbilityRelease():pass
func AbilitySecondaryTrigger():pass
func AbilitySecondaryRelease():pass
func AbilityMotionTrigger():pass
func AbilityMotionRelease():pass

#ability drawing function
#put in the code that creates the vfx for the ability itself
func drawAbilityEffect():pass
