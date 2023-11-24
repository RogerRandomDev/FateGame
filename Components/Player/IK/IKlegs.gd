@tool
extends Node3D
class_name IKLegs


@export_node_path("Skeleton3D") var skeleton
@export var LeftRoot:StringName
@export var LeftTip:StringName
@export var RightRoot:StringName
@export var RightTip:StringName
@export var foot_height_offset:float=0.5

var footCastL:RayCast3D=RayCast3D.new()
var footCastR:RayCast3D=RayCast3D.new()
var ikL:=SkeletonIK3D.new()
var ikR:=SkeletonIK3D.new()
var targetL:=Marker3D.new()
var targetR:=Marker3D.new()





#creates base node structure for the character
func initializeStructure()->void:
	ikL=appendToScene(ikL,"LeftIk",get_node(skeleton))
	ikR=appendToScene(ikR,"RightIk",get_node(skeleton))
	targetL=appendToScene(targetL,"targetLIK");
	targetR=appendToScene(targetR,"targetRIK");
	footCastL=appendToScene(footCastL,"footCastL");
	footCastR=appendToScene(footCastR,"footCastR");
	
	

#appends given node to scene tree at the given parent node
func appendToScene(node:Node,nodeName:String,nodeParent:Node=self):
	if !nodeParent||nodeParent.get_node_or_null(nodeName):return nodeParent.get_node_or_null(nodeName);
	node.name=nodeName;
	nodeParent.add_child(node);
	node.set_owner(get_tree().get_edited_scene_root())
	return node;



func _ready():
	initializeStructure()
	ikL.start()
	ikR.start()


func update_ik_target_pos(target, raycast, no_raycast_pos, foot_height_offset):
	if raycast.is_colliding():
		var hit_point = raycast.get_collision_point().y + foot_height_offset
		target.global_transform.origin.y = hit_point
	else:
		target.global_transform.origin.y = no_raycast_pos.y


func _physics_process(delta):
	if Engine.is_editor_hint():return
	update_ik_target_pos(targetL, footCastL, Vector3(0,0.05,0), foot_height_offset)
	update_ik_target_pos(targetR, footCastR, Vector3(0,0.05,0), foot_height_offset)




