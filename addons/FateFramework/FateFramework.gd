@tool
extends EditorPlugin

# Replace this value with a PascalCase autoload name, as per the GDScript style guide.


func _enter_tree():
	# The autoload can be a scene or script file.
	add_autoload_singleton("Fate", "res://addons/FateFramework/tools.gd")


func _exit_tree():
	remove_autoload_singleton("Fate")
