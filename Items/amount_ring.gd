extends Equipment

func _init() -> void:
	texture = "res://pic/UI/ring.png"
	tip = "多法环：使诅咒更加密集"
	price = 7
	project_name = "amount_ring"



func _on_load():
	match PlayerData.sapar_level:
		0:
			PlayerData.sapar_level = 1
			PlayerData.set_sapar([70,100,130,150])
		2:
			PlayerData.sapar_level = 3
			PlayerData.set_sapar([70,90,110,130,170,210])
func _on_delete():
		match PlayerData.sapar_level:
			1:
				PlayerData.sapar_level = 0
				PlayerData.set_sapar([70,110,130])
			3:
				PlayerData.sapar_level = 2
				PlayerData.set_sapar([70,95,120,150,180])
