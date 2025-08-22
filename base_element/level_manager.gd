extends Node2D

@export var Level_start:PackedScene
@export var level_fight:Array[PackedScene]
var level_shop:PackedScene

@onready var main = $".."


var fight_level_index:int = 0
var now_level_index:int = 0
var now_level:Level

func _ready() -> void:
	var level:Level = Level_start.instantiate()

	level.connect("level_clear",_on_level_clear)
	level.connect("spawn_enemy",main._on_spawn_enemy)
	add_child(level)
	now_level = level



func _on_level_clear():
	var is_clear = now_level.load_turn_enemy()
	if is_clear:
		change_level()


var level_interdistance = 984
func change_level():
	now_level.open_door()
	now_level_index += 1
	var new_level:Level
	if !(now_level_index%4):
		new_level = level_shop.instantiate()
	else:
		new_level.connect("spawn_enemy",main._on_spawn_enemy)
		new_level = level_fight[fight_level_index].instantiate()
		fight_level_index += 1
	new_level.connect("level_clear",_on_level_clear)
	add_child(new_level)
	#清除关卡
	for i in get_children():
		if i != now_level and i != new_level:
			i.queue_free()


	now_level = new_level
