extends Node
class_name DialogueManager



var activeDialogue:ClydeDialogue

#pretty clear but it just says if dialogue already exists or not
func canOpen():return !activeDialogue;


#launches dialogue
func openDialogue(dialoguePath:String)->ClydeDialogue:
	if !canOpen():return;
	activeDialogue=ClydeDialogue.new();
	
	activeDialogue.load_dialogue(dialoguePath)
	
	return activeDialogue

#removes the dialogue once it ends
func endDialogue():
	activeDialogue=null;
	
