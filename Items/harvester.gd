extends Equipment

func _init() -> void:
	texture = "res://pic/UI/ring.png"
	tip = "收割机：金色敌人掉落的金币数量+3"
	price = 16
	project_name = "harvester"



func _on_load():
	PlayerData.basis_gold_amount = 3

func _on_delete():
	PlayerData.basis_gold_amount = 0
