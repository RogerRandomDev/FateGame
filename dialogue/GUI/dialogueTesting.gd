extends Control

@onready var box:RichTextLabel=$RichTextLabel

var dialogueNode:ClydeDialogue
# Called when the node enters the scene tree for the first time.
func _ready():
	dialogueNode=Dialogue.openDialogue("res://dialogues/testing.clyde")
	
	nextContent()


func nextContent():
	var dialogue:Dictionary=dialogueNode.get_content()
	print(dialogue)
