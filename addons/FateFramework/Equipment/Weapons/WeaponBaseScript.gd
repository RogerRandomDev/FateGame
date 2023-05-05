extends Node3D
class_name WeaponBaseScript
##Base script for handling weapons in the scene tree.
##Inherited by the [WeaponMeleeScript] and [WeaponRangedScript].


##the [annotation Model] for the weapon to be loaded.
var MODEL:Node3D
##the holder [Node] for the [annotation WeaponScript].
##Should either be a [WeaponMeleeScript] or a [WeaponRangedScript].
var SCRIPT:Node

var weaponStats:Dictionary

##loads the weapon data into self along with building the weapon structure. Returns self
func loadWeapon(loadOnto:Node3D,weapon:WeaponResource)->Node3D:
	if get_parent():get_parent().remove_child(self)
	for child in get_children():child.queue_free()
	
	#loads self into the loadOnto
	loadOnto.add_child(self)
	#stores stats
	weaponStats=weapon.getWeaponStats()
	MODEL=weaponStats.weaponModel
	SCRIPT=Node.new()
	SCRIPT.set_script(weaponStats.Script)
	
	#makes sure MODEL and SCRIPT aren't already child nodes
	if !MODEL.get_parent():
		add_child(MODEL)
		add_child(SCRIPT)
	return self
