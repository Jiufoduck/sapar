extends Equipment

func _init() -> void:
	texture = "res://pic/UI/ring.png"
	tip = "超韧法环：让攻击力变成2倍"
	price = 60
	project_name = "lotpower_ring"



func _on_load():
	PlayerData.double_rate = 2.0
	PlayerData.player_strength = PlayerData.player_strength

func _on_delete():
	PlayerData.double_rate = 1.0
	PlayerData.player_strength = PlayerData.player_strength
