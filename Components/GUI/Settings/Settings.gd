extends Control

@onready var SettingNodes=$Inputs/ScrollContainer/Vcontainer
# Called when the node enters the scene tree for the first time.
func _ready():
	add_labels_to_settings()
	await get_tree().process_frame
	$Inputs/ScrollContainer.size.x+=14
	
	
	#region run initializer functions
	var method_list=get_method_list()
	for method in method_list:
		if method.name.contains("initialize_"):
			call(method.name)
	#endregion
	
	$AnimationPlayer.play("settings_animation")
	

##adds labels to the settings by using their node name
##also updates scroll container to recenter the settings
func add_labels_to_settings()->void:
	var max_x:int=0
	var max_setting_x:int=0
	for setting in SettingNodes.get_children():
		if setting.is_in_group("dont_label"):continue
		var setting_label=Label.new()
		setting_label.theme_type_variation="SettingLabel"
		setting_label.text=setting.name.capitalize()
		
		
		setting.add_child(setting_label)
		setting_label.force_update_transform()
		max_x=max(max_x,setting_label.size.x)
		max_setting_x=max(max_setting_x,setting.size.x)
	
	
	for setting in SettingNodes.get_children():
		if setting.is_in_group("dont_label"):continue
		setting.get_child(0).position.x-=max_x+16
	$Inputs/ScrollContainer.custom_minimum_size.x=max_x+max_setting_x-16



#region Shadow Quality
const shadow_quality_modes=[
	1024,
	2048,
	4096,
	8192,
	16384
]

func _on_shadow_quality_item_selected(index)->void:
	Settings.set_setting("ShadowQuality",index)
	ProjectSettings.set_setting(
		"rendering/lights_and_shadows/directional_shadow/size",
		shadow_quality_modes[index]
		)
	$RestartNeeded.show()

func initialize_shadow_quality_setting()->void:
	var shadow_res=ProjectSettings.get_setting("rendering/lights_and_shadows/directional_shadow/size")
	for x in len(shadow_quality_modes):
		if shadow_quality_modes[x]==shadow_res:
			SettingNodes.get_node("ShadowQuality").selected=x
			break

#endregion


#region Window Mode

func _on_window_mode_item_selected(index):
	var window_mode=index+int(index>0)
	
	ProjectSettings.set_setting("display/window/size/mode",window_mode)
	DisplayServer.window_set_mode(window_mode)
	
	#setting the size when undoing fullscreen to the base resolution
	if window_mode==0:
		DisplayServer.window_set_size(Vector2i(1152,648))

func initialize_window_mode()->void:
	var window_mode=ProjectSettings.get_setting("display/window/size/mode")
	var index=window_mode-int(window_mode>0)
	
	SettingNodes.get_node("WindowMode").select(index)

#endregion


#region VSync Mode

func _on_v_sync_item_selected(index):
	ProjectSettings.set_setting("display/window/vsync/vsync_mode",index)
	DisplayServer.window_set_vsync_mode(index)

func initialize_vsync_mode()->void:
	var index=ProjectSettings.get_setting("display/window/vsync/vsync_mode")
	DisplayServer.window_set_vsync_mode(index)
	SettingNodes.get_node("VSync").select(index)

#endregion


#region MSAA Mode
func _on_msaa_item_selected(index):
	ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d",index)
	RenderingServer.viewport_set_msaa_3d(get_tree().root.get_viewport_rid(),index)

func initialize_msaa_mode()->void:
	SettingNodes.get_node("MSAA").select(ProjectSettings.get_setting("rendering/anti_aliasing/quality/msaa_3d"))


#endregion

func save_data()->void:ProjectSettings.save_custom("override.cfg")








