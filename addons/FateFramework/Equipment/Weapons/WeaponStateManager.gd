extends Node
class_name WeaponStateManager
##A node for handling the [WeaponState] Nodes

##the current [WeaponState] Node in use
var activeWeapon:Node;

#disasbles all Weapons by default
func _ready():
	for weapon in get_children():
		setWeaponProcess(weapon,false)
	swapWeapon("Main")




##sets the [member activeWeapon] if the Weapon exists
func swapWeapon(Weapon:String):
	var newWeapon=get_node_or_null(Weapon)
	if(newWeapon==null):return
	
	if(activeWeapon!=null):setWeaponProcess(activeWeapon,false)
	setWeaponProcess(newWeapon,true)
	activeWeapon=newWeapon


##changes process mode for any Abilities[br]
##does not disable [method _process] so as to allow miscellaneous functionality[br]
##calls [method WeaponState.onTrigger] to the activated ability if set to process true
func setWeaponProcess(Weapon:Node,process:bool)->void:
	Weapon.set_physics_process(process)
	Weapon.set_process_input(process)
	Weapon.set_physics_process_internal(process)
	if(process):Weapon.onTrigger()

##returns relevant [WeaponState]
func getWeapon(Weapon:String)->WeaponState:
	return get_node_or_null(Weapon);
