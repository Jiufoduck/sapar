extends Equipment

func _init() -> void:
	texture = "res://pic/UI/ring.png"
	tip = "吸引法环：从内往外破坏诅咒时对敌人造成的伤害+1"
	price = 9
	project_name = "attract_ring"



func _on_load():
	PlayerData.attract_ring = true

func _on_delete():
	PlayerData.attract_ring = false
