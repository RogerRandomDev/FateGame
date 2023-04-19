@tool
extends CharacterBody3D
class_name CharacterNode

var GRAVITY:Vector3
@export var SPEED:float=1.
@export var DAMPING:float=1.
@export var accelSpeed:float=0.5
@export var decelSpeed:float=0.75
@export var amplifiedDecelInMotion:float=2.0

@export var jumpForce:float=2.5;
@export_range(0,1) var rotationDamping:float=0.125;


var stateManager:Node;

func _ready()->void:
	GRAVITY=ProjectSettings.get_setting("global/gravity")
	initializeStructure()
	get_node("States").setActiveState("PlayerWalkingState")
	


func _physics_process(delta):
	if Engine.is_editor_hint():return
	
	move_and_slide()
	for col_idx in get_slide_collision_count():
		var col := get_slide_collision(col_idx)
		if col.get_collider() is RigidBody3D:
			col.get_collider().apply_central_impulse(-col.get_normal() * 0.3 * col.get_collider().mass)
			col.get_collider().apply_impulse(-col.get_normal() * 0.01  * col.get_collider().mass, col.get_position())
	#updates global data of the player location
	RenderingServer.global_shader_parameter_set("character_position",global_position)
#a list of medeival names



#handles updating velocity when rotating
func rotateBy(rot:Vector2):
	rotation.y+=rot.x
	velocity=velocity*rotationDamping+velocity.rotated(Vector3.UP,rot.x)*(1-rotationDamping)

#functions below here are used in editor for making character creation easier

#creates base node structure for the character
func initializeStructure()->void:
	if !Engine.is_editor_hint():return;
	stateManager=appendToScene(StateManagerNode.new(),"States");
	appendToScene(AbilityManagerNode.new(),"Abilities");

#appends given node to scene tree at the given parent node
func appendToScene(node:Node,nodeName:String,nodeParent:Node=self):
	if !nodeParent||nodeParent.get_node_or_null(nodeName):return;
	node.name=nodeName;
	nodeParent.add_child(node);
	node.set_owner(get_tree().get_edited_scene_root())
	return node;

