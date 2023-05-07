extends PassiveScriptResource


const ELEMENT:String="Space"
const Damage:int=5

func _ready():
	var EnergyStatistic:Node=root.get_node("Statistics").getStatistic("Energy")
	EnergyStatistic.updateExternalModifier(1.25)

func inflictAOE():
	var inRange:Array=checkWithinRange(get_parent().global_position,4)
	for collider in inRange:
		if !collider.collider.get_node_or_null("Statistics"):continue
		collider.collider.get_node("Statistics").inflictModifier(
			"Health",
			ELEMENT,
			-Damage
		)


func _process(_delta):
	pass
