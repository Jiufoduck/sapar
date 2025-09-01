extends Equipment

func _init() -> void:
	texture = "res://pic/UI/ring.png"
	tip = "护盾：获得一个4点血量，每10秒恢复1点的护盾抵挡伤害"
	price = 40
	project_name = "shield"



func _on_load():
	PlayerData.sheild = true
	PlayerData.initialize_combat_ui()

func _on_delete():
	PlayerData.sheild = false
	PlayerData.initialize_combat_ui()
