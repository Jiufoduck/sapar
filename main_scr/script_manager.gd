extends Node

signal dialogue_finished
signal monologue_finished


func _on_dialogue_finished():
	dialogue_finished.emit()

func _on_monologue_finished():
	monologue_finished.emit()
