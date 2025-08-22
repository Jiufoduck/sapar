extends TileMapLayer
class_name Level

signal level_clear
signal send_script(path:String, is_instance:bool, is_force:bool, type:String)



func _on_game_area_body_entered(body: Node2D) -> void:
	close_door()


func open_door():
	pass


func close_door():
	pass
