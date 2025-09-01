extends RichTextLabel

var tween:Tween

func _ready() -> void:
	pass


func jump(show_text,is_criti = false, is_heal = false):
	show()
	if tween and tween.is_running():
		tween.stop()
	$fade.start()
	scale = Vector2.ZERO
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	if is_criti:
		text = "[color=red]" + str(show_text)
	elif is_heal:
		text = "[color=green]" + str(show_text)
	else:
		text = str(show_text)
	tween.tween_property(self,"scale",Vector2.ONE,0.3)

func _on_fade_timeout() -> void:
	hide()
