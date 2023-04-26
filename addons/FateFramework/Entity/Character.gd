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
@export_range(0,1) var rotationDamping:float=0.125;


@export_category("Impulse")
@export var stairForce:float=2.
@export var jumpForce:float=2.5;

var velocity:Vector3

var stateManager:Node;

@export var stairCheckShape:Shape3D
var stairFinder:=PhysicsShapeQueryParameters3D.new()


func _ready()->void:
	GRAVITY=ProjectSettings.get_setting("global/gravity")
	initializeStructure()
	get_node("States").setActiveState("PlayerWalkingState")
	stairFinder.shape=stairCheckShape
	stairFinder.exclude=[self]
func is_on_floor():
	return on_floor

func _physics_process(delta):
	if Engine.is_editor_hint():return
	
	#updates global data of the player location
	RenderingServer.global_shader_parameter_set("character_position",global_position)
	
var rotate:float=0.
var moveTowards:Vector3=Vector3.ZERO
var on_floor=false
func _integrate_forces(state):
	

	var velocityApplied=velocity
	on_floor=false
	for contact in state.get_contact_count():
		if state.get_contact_local_position(contact).y-global_position.y<-0.95:on_floor=true
		var dir=state.get_contact_local_normal(contact)
		dir.y=dir.y-1
		if(dir.y<-0.25&&dir.y>-0.9):
			apply_central_impulse(dir)
		elif dir.y>-0.35&&dir.y<0.:
			velocityApplied-=GRAVITY*Vector3(0,1,0)
	if on_floor:velocity.y=0.
	#integrate stairs
	var stairChecks=getStairCheck()
	if(stairChecks&&stairChecks.normal.y>0.75&&on_floor):
		
		if(stairChecks.point.y-position.y>-0.95):apply_central_impulse(Vector3(0,stairForce,0))
		elif(stairChecks.point.y-position.y<-1.05):apply_central_impulse(Vector3(0,-stairForce,0))


	state.apply_central_impulse((velocityApplied+GRAVITY)*state.step)
	
	
	
	
	rotation.y=rotate
	state.transform.origin+=moveTowards
	global_transform.origin+=moveTowards
	moveTowards=Vector3.ZERO
	var velY=max(min(linear_velocity.y,velocity.y),GRAVITY.y)
	velocity=-linear_velocity*decelSpeed
	velocity.y=velY
	
	


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

#meant to handle stairs, really i just use it for anything related to nearest point to the feet
func getStairCheck():
	stairFinder.transform.origin=transform.origin-Vector3(0,0.55,0)
	var stairChecks:=get_viewport().world_3d.direct_space_state.get_rest_info(stairFinder)
	return stairChecks

