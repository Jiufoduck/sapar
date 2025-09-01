extends Equipment

func _init() -> void:
	texture = "res://pic/UI/ring.png"
	tip = "韧法环：让攻击力增加1点"
	price = 19
	project_name = "power_ring"



func _on_load():
	PlayerData.player_strength += 1

func _on_delete():
	PlayerData.player_strength -= 1
