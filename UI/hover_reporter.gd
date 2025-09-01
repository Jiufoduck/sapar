extends TextureRect

const plus = preload("res://pic/UI/plus.png")

signal hovered(emitter, content)
signal select(emitter, content)

var is_empty = true
var content:Item

var tween:Tween
func _on_mouse_entered() -> void:
	if tween and tween.is_running():
		tween.stop()
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ignore_time_scale()
	tween.tween_property(self,"modulate",Color(1,1,1,0.3),0.2)


	hovered.emit(self,content)


func clear():
	is_empty = true
	content = null
	texture = plus

func load_content(cont):
	is_empty = false
	content = cont
	texture = load(cont.texture)


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("point"):
		if tween and tween.is_running():
			tween.stop()
		tween = create_tween().set_trans(Tween.TRANS_SINE).set_ignore_time_scale()
		tween.tween_property(self,"modulate",Color(1,1,1,0.0),0.1)

		select.emit(self,content)


func _on_mouse_exited() -> void:
	if tween and tween.is_running():
		tween.stop()
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ignore_time_scale()

	tween.tween_property(self,"modulate",Color(1,1,1,1),0.2)
