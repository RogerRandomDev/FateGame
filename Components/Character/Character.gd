@tool
extends RigidBody3D
class_name CharacterNode

var GRAVITY:Vector3
@export var MASS:float=1.
@export var SPEED:float=1.
@export var DAMPING:float=1.
@export var accelSpeed:float=0.5
@export var decelSpeed:float=0.75
@export var amplifiedDecelInMotion:float=2.0

@export var jumpForce:float=2.5;
@export_range(0,1) var rotationDamping:float=0.125;
var velocity:Vector3

var stateManager:Node;

var floorChecker:=PhysicsShapeQueryParameters3D.new()
@export var floorCheckShape:Shape3D

func _ready()->void:
	GRAVITY=ProjectSettings.get_setting("global/gravity")
	initializeStructure()
	get_node("States").setActiveState("PlayerWalkingState")
	floorChecker.shape=floorCheckShape
	floorChecker.exclude=[self]

func is_on_floor():
	floorChecker.transform=global_transform
	return get_viewport().world_3d.direct_space_state.intersect_shape(floorChecker)

func _physics_process(delta):
	if Engine.is_editor_hint():return
	
	#updates global data of the player location
	RenderingServer.global_shader_parameter_set("character_position",global_position)
	
var rotate:float=0.
var moveTowards:Vector3=Vector3.ZERO

func _integrate_forces(state):
	velocity.y=max(linear_velocity.y,velocity.y)
	state.linear_velocity=velocity
	rotation.y=rotate
	state.transform.origin+=moveTowards
	global_transform.origin+=moveTowards
	moveTowards=Vector3.ZERO


#handles updating velocity when rotating
func rotateBy(rot:Vector2):
	rotate+=rot.x
	velocity=velocity*rotationDamping+velocity.rotated(Vector3.UP,rot.x)*(1-rotationDamping)


func moveTo(moveBy:Vector3):
	moveTowards=moveBy-global_transform.origin;
	

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

