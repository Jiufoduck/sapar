extends TextureProgressBar




func initialize(Max:int):
	max_value = Max+1
	value = Max


var tween:Tween
func _on_Hp_changed(val:int):
	if tween and tween.is_running():
		tween.stop()
	tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self,"value",float(val),0.3)
