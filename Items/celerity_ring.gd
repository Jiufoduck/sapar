extends Equipment

func _init() -> void:
	texture = "res://pic/UI/ring.png"
	tip = "流转法环：让武器的cd减少1秒"
	price = 13
	project_name = "celerity_ring"



func _on_load():
	PlayerData.weapon_cd_down = true
	PlayerData.current_weapon_cd -= 1

func _on_delete():
	PlayerData.weapon_cd_down = false
	PlayerData.current_weapon_cd += 1
