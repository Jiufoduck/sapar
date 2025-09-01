extends Equipment

func _init() -> void:
	texture = "res://pic/UI/ring.png"
	tip = "暴击法环：诅咒造成的伤害有可能会变成2倍"
	price = 17
	project_name = "critical_ring"



func _on_load():
	PlayerData.critical_ring = true

func _on_delete():
	PlayerData.critical_ring = false
