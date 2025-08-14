extends RichTextLabel

var tween:Tween

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("point"):
		jump("Yes")

func jump(show_text,is_criti = false):
	show()
	if tween and tween.is_running():
		tween.stop()
	$fade.start()
	scale = Vector2.ZERO
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	if is_criti:
		text = "[color=red]" + show_text
	else:
		text = show_text
	tween.tween_property(self,"scale",Vector2.ONE,0.3)

func _on_fade_timeout() -> void:
	hide()
