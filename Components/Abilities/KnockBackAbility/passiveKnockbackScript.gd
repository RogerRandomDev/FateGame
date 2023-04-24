extends PassiveScriptResource




func inflictAOE():
	var inRange:Array=checkWithinRange(get_parent().global_position,2)
	for collider in inRange:
		if collider.collider is RigidBody3D:
			collider.collider.apply_central_impulse(
				collider.collider.global_position-get_parent().global_position
			)


func _process(_delta):
	inflictAOE()
