extends Node
class_name AbilityState

@export var abilityDuration:float=0.
@export var abilityDelay:float=0.
@export var secondaryAbilityDuration:float=0.
@export var secondaryAbilityDelay:float=0.
var abilityArea:PhysicsShapeQueryParameters3D=PhysicsShapeQueryParameters3D.new()
var space_state:PhysicsDirectSpaceState3D
var root:Node3D

var timeLeft:float=0.
var secondaryTimeLeft:float=0.
var justTrigered:bool=false
var justTrigeredSecondary:bool=false
func _ready():
	root=get_parent().get_parent()
	space_state=get_viewport().find_world_3d().direct_space_state


func _process(delta):
	timeLeft-=delta
	secondaryTimeLeft-=delta

func _unhandled_input(event):
	#prevents double-trigger if moving mouse while pressing
	#not sure why it does that but i'm guessing 2 actions same frame, so it counted it still
	if not event is InputEventKey:return
	if Input.is_action_just_pressed("TriggerAbility")&&timeLeft<=0.:
		timeLeft=abilityDuration+abilityDelay
		justTrigered=true
		AbilityTrigger()
	if Input.is_action_just_released("TriggerAbility")&&justTrigered:
		justTrigered=false
		AbilityRelease()
	if Input.is_action_just_pressed("TriggerAbilitySecondary")&&secondaryTimeLeft<=0.:
		secondaryTimeLeft=secondaryAbilityDuration+secondaryAbilityDelay
		justTrigeredSecondary=true
		AbilitySecondaryTrigger()
	if Input.is_action_just_released("TriggerAbilitySecondary")&&justTrigeredSecondary:
		justTrigered=false
		AbilitySecondaryRelease()




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

#ability drawing function
#put in the code that creates the vfx for the ability itself
func drawAbilityEffect():pass
