extends Equipment

func _init() -> void:
	texture = "res://pic/UI/ring.png"
	tip = "排斥法环：从外往内破坏诅咒时对敌人造成的伤害+1"
	price = 9
	project_name = "repel_ring"



func _on_load():
	PlayerData.repel_ring = true

func _on_delete():
	PlayerData.repel_ring = false
