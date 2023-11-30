extends CSGBox3D

@export var bounce_force:float=100.0

var query:=PhysicsShapeQueryParameters3D.new()

func _ready():
	var shape=BoxShape3D.new()
	shape.size=(size+Vector3(-0.1,0.4,-0.1))
	query.shape=shape
	query.transform=transform

func _process(delta):
	var col:=get_world_3d().direct_space_state.intersect_shape(query)
	for s in col:
		if s.collider is CharacterBody3D:
			s.collider.velocity.y+=bounce_force
