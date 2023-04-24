extends StateNode
class_name ChargingState

@export var duration:float
@export var exitToState:String
@export var SPEED:float
@export var chargeDirection:Vector3
var timeLeft:float=0.

func _ready():
	super._ready()

func onTrigger():
	timeLeft=duration

func _physics_process(delta):
	if timeLeft<=0.:get_parent().setActiveState(exitToState)
	timeLeft-=delta
	
	root.apply_central_impulse(-chargeDirection*SPEED)
