extends Node
class_name HealthNode

signal hurt(damage)
signal heal(healed)
signal triggerDeath



@export var HP:int=100;
@export var maxHP:int=100;
@export var externalModifier:float=1.;

#modify remaining health
func changeBy(modifier:int)->void:
	var currentHP=HP;
	HP=clamp(HP+modifier,0,maxHP)
	#attempt to die if HP is zero
	if(HP==0):attemptDeath()

#changes the externalModifier and will also update the current values as long as updateValues is true
func updateExternalModifier(modifier:float,updateValues:bool=true)->void:
	var lastModifier:float=externalModifier;
	externalModifier=modifier;
	
	#only continues if updateValues is true and the modifier has changed
	if(!(updateValues&&lastModifier!=externalModifier)):return
	var valueChanged:int=int(maxHP*(externalModifier-1.));
	HP+=valueChanged
	emit_signal(
		"heal" if lastModifier < externalModifier else "hurt",
		abs(valueChanged)
	)



#checks no external circumstance is preventing death
func attemptDeath()->void:
	var externalCircumstanceExists:bool=false
