extends Camera3D
class_name PlayerCamera

@export var mouseSensitivity:float=0.001
@export var joyStickSensitivity:float=0.1
@export_range(0,PI) var maxRotUp:float=0.0
@export_range(0,PI) var maxRotDown:float=0.0
func _ready():
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
#handles rotation when moving the mouse
func _input(event):
	if event is InputEventMouseMotion:
		
		
		get_parent().get_parent().rotateBy(-event.relative*mouseSensitivity)
		get_parent().rotation.x=clamp(
			get_parent().rotation.x-event.relative.y*mouseSensitivity,
			-maxRotUp,
			maxRotDown
		)
