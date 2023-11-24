@tool
extends CharacterBody3D
class_name CharacterNode

signal attacked(attack_data)

var GRAVITY:Vector3
@export var MASS:float=1.
@export var SPEED:float=1.
@export var DAMPING:float=1.
@export var accelSpeed:float=0.5
@export var decelSpeed:float=60.0
@export var amplifiedDecelInMotion:float=2.0
@export_range(0,1) var rotationDamping:float=0.125;
@export var abilityOrigin:Node

@export_category("Impulse")
@export var stairForce:float=2.
@export var jumpForce:float=2.5;


var stateManager:Node;

var anim_data:Dictionary={}

func _ready()->void:
	GRAVITY=ProjectSettings.get_setting("global/gravity")
	initializeStructure()
	get_node("States").setActiveState("PlayerWalkingState")
var rotate:float=0.
var moveTowards:Vector3=Vector3.ZERO
var on_floor=false

func is_on_floor():
	return is_on_floor()

func _physics_process(delta):
	if Engine.is_editor_hint():return
	
	#updates global data of the player location
	RenderingServer.global_shader_parameter_set("character_position",global_position)
	move_and_slide()
	rotation.y=rotate
	global_transform.origin+=moveTowards
	moveTowards=Vector3.ZERO
	velocity-=velocity*Vector3(decelSpeed,0,decelSpeed)*delta
	velocity.y+=GRAVITY.y*delta
	velocity.y*=int(!is_on_floor())



func _input(event):
	if Input.is_action_just_pressed("TriggerAbility"):get_node("Abilities").triggerAbility(0)
	if Input.is_action_just_pressed("TriggerAbilitySecondary"):get_node("Abilities").triggerAbility(1)
	if Input.is_action_just_pressed("TriggerAbilityMotion"):get_node("Abilities").triggerAbility(2)
	if Input.is_action_just_released("TriggerAbility"):get_node("Abilities").releaseAbility(0)
	if Input.is_action_just_released("TriggerAbilitySecondary"):get_node("Abilities").releaseAbility(1)
	if Input.is_action_just_released("TriggerAbilityMotion"):get_node("Abilities").releaseAbility(2)


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


##returns the look direction of the character currently
func getFaceDirection()->Vector3:
	return Vector3($CameraArm.global_rotation.x,global_rotation.y,0.)


func _on_player_camera_rotation_changed(rotationNew):
	$WeaponModelManager.updateRotations(rotationNew)


func getCamera()->Camera3D:
	return $CameraArm/PlayerCamera
