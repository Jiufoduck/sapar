extends Node

var current_monologue: Monologue = null
var queued_monologues: Array[Monologue] = []
var is_playing: bool = false
var current_line_index: int = 0
@onready var timer: Timer = $Timer


func play_monologue(monologue: Monologue, is_instance:bool, is_force:bool):
	if is_playing:
		if is_instance:
			return
		if is_force:
			_finish_monologue(true)
			load_monologue(monologue)
			return

		queued_monologues.append(monologue)
		return
	load_monologue(monologue)

func load_monologue(monologue:Monologue):
	current_monologue = monologue
	is_playing = true
	current_line_index = 0
	_play_next_line()

func _play_next_line():
	if !current_monologue:
		return

	if current_line_index >= current_monologue.lines.size():
		_finish_monologue(false)
		return

	var line = current_monologue.lines[current_line_index]
	$Label.text = line

	#animation
	create_tween().tween_property($Label,"modulate",Color.WHITE,0.2)

	timer.start(current_monologue.interval)
	current_line_index += 1

func _on_timer_timeout():
	await create_tween().tween_property($Label,"modulate",Color(0,0,0,0),0.2).finished
	_play_next_line()

func _finish_monologue(is_force:bool):
	is_playing = false
	current_monologue = null
	timer.stop()

	if !is_force and queued_monologues.size() > 0:
		ScriptManager._on_monologue_finished()
		load_monologue(queued_monologues.pop_front())
