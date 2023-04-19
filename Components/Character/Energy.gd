extends Node
class_name EnergyNode

signal usedENERGY(energy)
signal regainENERGY(energy)


@export var ENERGY:int=100;
@export var maxENERGY:int=100;
@export var externalModifier:float=1.;


#modify remaining ENERGY
func changeBy(modifier:int)->void:
	var currentENERGY:int=ENERGY;
	ENERGY=clamp(ENERGY+modifier,0,int(maxENERGY*externalModifier))
	
	#only emit signal if ENERGY changed
	if(ENERGY==currentENERGY):return
	emit_signal(
		"regainENERGY" if modifier>0 else "usedENERGY",
		abs(modifier)
	)


#changes the externalModifier and will also update the current values as long as updateValues is true
func updateExternalModifier(modifier:float,updateValues:bool=true)->void:
	var lastModifier:float=externalModifier;
	externalModifier=modifier;
	
	#only continues if updateValues is true and the modifier has changed
	if(!(updateValues&&lastModifier!=externalModifier)):return
	var valueChanged:int=int(maxENERGY*(externalModifier-1.));
	ENERGY+=valueChanged
	emit_signal(
		"regainENERGY" if lastModifier < externalModifier else "usedENERGY",
		abs(valueChanged)
	)



#returns if the required cast energy is less or equal to current energy reserves
func attemptCast(castEnergyRequired:int)->bool:return ENERGY>=castEnergyRequired
