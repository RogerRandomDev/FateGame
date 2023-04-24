@tool
extends Resource
class_name AbilityPassiveResource


@export var PassiveVFX:Array[AbilityPassiveEffect]



func loadPassive(loadOnto:Node,root:Node):
	var passiveHolder:=Node3D.new()
	loadOnto.add_child(passiveHolder)
	for VFX in PassiveVFX:VFX.loadEffect(passiveHolder,root)
	return passiveHolder
