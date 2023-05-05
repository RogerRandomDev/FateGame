extends WeaponBaseScript
class_name WeaponRangedScript
##the [WeaponBaseScript] for the handling of a ranged weapon









func attack()->void:
	
	pass

##math function uses to calculate bullet spread from multishot
##WORK IN PROGRESS, STILL NEEDS TO BE PROPERLY DESIGNED. 
##FIGURE THE MATH OUT
func getSpread(bulletID:int):return Vector2(float(bulletID)/(weaponStats.Projectiles*weaponStats.Projectiles) *weaponStats.Spread,float(bulletID)/(weaponStats.Projectiles*weaponStats.Projectiles) *weaponStats.Spread)
