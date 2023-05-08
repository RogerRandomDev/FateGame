extends Camera3D
class_name PlayerCamera
signal rotation_changed(rotationNew)

@export var mouseSensitivity:float=0.001
@export var joySensitivity:float=1.
@export_range(0,PI) var maxRotUp:float=0.0
@export_range(0,PI) var maxRotDown:float=0.0
@export var invertX:bool=false
@export var invertY:bool=false
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
		emit_signal('rotation_changed',Vector3(get_parent().rotation.x,get_parent().get_parent().rotation.y,0))
func _process(_delta):
	if not Input.get_connected_joypads().size():return
	var relative=Vector2(Input.get_joy_axis(0,JOY_AXIS_RIGHT_Y)*(int(invertY)*2-1),-Input.get_joy_axis(0,JOY_AXIS_TRIGGER_LEFT)*(int(invertX)*2-1))
	if(abs(relative.x)<0.25):relative.x=0.
	if(abs(relative.y)<0.25):relative.y=0.
	get_parent().get_parent().rotateBy(relative*joySensitivity)
	get_parent().rotation.x=clamp(
		get_parent().rotation.x-relative.y*joySensitivity,
		-maxRotUp,
		maxRotDown
	)
#	if(get_parent().get_hit_length()<0.15):get_parent().position.x*=-1
