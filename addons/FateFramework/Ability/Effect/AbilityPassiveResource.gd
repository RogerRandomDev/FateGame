@tool
extends Resource
class_name AbilityPassiveResource
##Resource for handling the Passive Effects in [AbilityResource]

##Stores [AbilityPassiveEffect] resources to load
@export var PassiveVFX:Array[AbilityPassiveEffect]


##loads [AbilityPassiveEffect] Resources from [member PassiveVFX]
func loadPassive(loadOnto:Node,root:Node)->Node3D:
	var passiveHolder:=Node3D.new()
	loadOnto.add_child(passiveHolder)
	for VFX in PassiveVFX:VFX.loadEffect(passiveHolder,root)
	return passiveHolder
