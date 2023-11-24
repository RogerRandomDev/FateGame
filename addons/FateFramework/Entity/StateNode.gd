extends Node
class_name StateNode


signal changeState(changeTo:String)

var root:CharacterBody3D=null
func _ready():
	root=get_parent().get_parent()


func onTrigger():pass

func stateEntered():pass

func stateExited():pass
