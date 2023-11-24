extends Control


func _ready():
	var abilityList=get_parent().get_node("CharacterNode/Abilities")
	abilityList.ActiveAbilityChanged.connect(updateAbilities)


func updateAbilities(ability:AbilityResource)->void:
	var contents=ability.getAbilityData()
	for child in $AbilityCooldowns/list.get_children():
		child.updateTo(contents[child.AbilityListed],ability)


func _on_energy_change_energy(changedBy, remainder, maxVal)->void:
	$statBars/energyCircle.updateValues(remainder,maxVal,changedBy)


func _on_health_change_health(change, remainder, maxVal)->void:
	$statBars/healthCircle.updateValues(remainder,maxVal,change)
