extends TileMapLayer
class_name Level

signal level_clear




func _on_game_area_body_entered(body: Node2D) -> void:
	close_door()


func open_door():
	pass


func close_door():
	pass
