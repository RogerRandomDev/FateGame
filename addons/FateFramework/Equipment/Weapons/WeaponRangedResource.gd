extends WeaponResource
class_name WeaponRangedResource
##A Node for Handling Ranged Weapons based on [WeaponState]


@export_group("RANGED DATA")
##quantity of [annotation Projectiles] fired by the weapon
@export var ProjectileCount:int=1
##the [annotation Spread] of the weapon [annotation Projectiles]. [annotation Spread] is not applied when [member ProjectileCount] is 1.
@export var ProjectileSpread:float=0.0




##returns the unique stats for a Ranged Weapon
func getUniqueStats()->Dictionary:
	return {
		'Projectiles':ProjectileCount,
		'Spread':ProjectileSpread,
		'WeaponType':'RANGED'
	}
