extends Node

signal dialogue_finished
signal monologue_finished

signal add_dialogue(path:String,is_instance:bool,is_force:bool)
signal add_monologue(path:String,is_instance:bool,is_force:bool)
func _on_dialogue_finished():
	dialogue_finished.emit()

func _on_monologue_finished():
	monologue_finished.emit()

func _send_dialogue(path:String,is_instance:bool,is_force:bool):
	add_dialogue.emit(path,is_instance,is_force)

func _send_monologue(path:String,is_instance:bool,is_force:bool):
	add_monologue.emit(load(path),is_instance,is_force)
