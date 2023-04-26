extends Control




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_energy_change_energy(changedBy, remainder, max):
	$statBars/energyCircle.updateValues(remainder,max,changedBy)


func _on_health_change_health(change, remainder, max):
	$statBars/healthCircle.updateValues(remainder,max,change)
