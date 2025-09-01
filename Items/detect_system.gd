extends Equipment

func _init() -> void:
	texture = "res://pic/UI/ring.png"
	tip = "检测系统：诅咒有几率阻挡子弹"
	price = 25
	project_name = "detect_system"



func _on_load():
	PlayerData.critical_ring = true

func _on_delete():
	PlayerData.critical_ring = false
