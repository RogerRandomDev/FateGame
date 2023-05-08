extends PlayerController
class_name PlayerDeathState



func onTrigger():
	root.freeze=true


func attemptingToDie(_nodeCalled:Node):
	get_parent().setActiveState("PlayerDeathState")
	get_parent().lock()
	
	return 'dontDie'
