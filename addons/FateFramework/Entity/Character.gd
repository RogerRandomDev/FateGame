@tool
extends CharacterBody3D
class_name CharacterNode

signal attacked(attack_data)

var GRAVITY:Vector3

@onready var _state_chart:StateChart = $StateChart

@export var MASS:float=1.
@export var SPEED:float=1.
@export var DAMPING:float=1.
@export var accelSpeed:float=0.5
@export var decelSpeed:float=60.0
@export var amplifiedDecelInMotion:float=2.0
@export_range(0,1) var rotationDamping:float=0.125;
@export var abilityOrigin:Node

var facing_direction:Vector3

var stateManager:Node;

var anim_data:Dictionary={}

func _ready()->void:
	GRAVITY=ProjectSettings.get_setting("global/gravity")
	
	
	initializeStructure()
var rotate:float=0.
var moveTowards:Vector3=Vector3.ZERO
var on_floor=false

func is_on_floor():
	return is_on_floor()

func _physics_process(delta):
	if Engine.is_editor_hint():return
	
	
	
	
	
	
	move_and_slide()
	rotation.y=rotate
	velocity.y+=GRAVITY.y*delta
	
	
	#whether you are on the floor or not
	if is_on_floor():
		_state_chart.send_event("grounded")
		velocity.y=0
	else:
		#this check is to ensure if you are capable
		#of sliding at the given time
		var slide_pos=Vector3.ZERO
		var slide=get_last_slide_collision()
		if slide:slide_pos=slide.get_position()-global_position
		
		if is_on_wall()&&get_wall_normal().y>0.6&&(abs(slide_pos.x)<0.1||abs(slide_pos.y)<0.1):
			
			_state_chart.send_event("sliding")
		else:
			_state_chart.send_event("airborne")
	
	#trigger sliding
	
	
	if (velocity*Vector3(1,0,1)).length_squared()<2:
		_state_chart.send_event("idle")
	else:
		_state_chart.send_event("moving")
	
	
	velocity-=velocity*delta*decelSpeed*Vector3(1,0,1)

#needs to be made into its own node/resource to allow swapping
#what handles the triggers more easily

func _input(event):
	if Input.is_action_just_pressed("TriggerAbility"):get_node("Abilities").emit_signal("AbilityTriggered",0)
	#if Input.is_action_just_pressed("TriggerAbilitySecondary"):get_node("Abilities").triggerAbility(1)
	#if Input.is_action_just_pressed("TriggerAbilityMotion"):get_node("Abilities").triggerAbility(2)
	#if Input.is_action_just_released("TriggerAbility"):get_node("Abilities").releaseAbility(0)
	#if Input.is_action_just_released("TriggerAbilitySecondary"):get_node("Abilities").releaseAbility(1)
	#if Input.is_action_just_released("TriggerAbilityMotion"):get_node("Abilities").releaseAbility(2)


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
	return facing_direction


func _on_player_camera_rotation_changed(rotationNew):
	facing_direction=rotationNew
	
	$WeaponModelManager.updateRotations(rotationNew)


func getCamera()->Camera3D:
	return $CameraArm/PlayerCamera


func update_model_rotation(dir:Vector3)->void:
	if dir.is_equal_approx(Vector3.ZERO):return
	$Model.look_at(dir+global_position)

#rotates the input vector by the current rotation basis of the root node
func applyFacingDirection(inputVector:Vector2)->Vector3:
	var direction=(Basis.from_euler(facing_direction) * Vector3(inputVector.y,0,inputVector.x)).normalized()*inputVector.length()
	return direction



func _on_jump_enabled_state_physics_process(delta):
	if Input.is_action_just_pressed("jump"):
		velocity.y = -GRAVITY.y*0.275
		_state_chart.send_event("jump")

func _on_movement_enabled_state_physics_process(delta):
	var baseInput=Vector2(
		Input.get_axis("forward","backward"),
		Input.get_axis("left","right")
	)
	var dir=(applyFacingDirection(baseInput)*Vector3(1,0,1)).normalized()
	
	update_model_rotation(dir)
	
	velocity+=dir*delta*accelSpeed

func _on_sliding_enabled_state_physics_process(delta):
	var dir=get_wall_normal()*Vector3(1,0,1)
	dir=-Vector3(dir.z,0,dir.x)
	update_model_rotation(dir)



