extends Level
class_name Level_fight

signal spawn_enemy(pos:Vector2,obj:EnemyBase)

var enemies_index = 0
@onready var enemy_detector = %enemy_detector

var enemy_set:Array[Dictionary]
@export var enemy_level:int = 0


func load_turn_enemy() -> bool:
	if enemies_index >= enemy_set.size():
		return false

	var enemy:Dictionary = enemy_set[enemies_index]
	for pos in enemy:
		var ins = load(EnemyBase.enemy_types[enemy[pos]]).instantiate()
		ins.level = enemy_level
		ins.connect("about_to_dead",_on_enemy_dead)
		spawn_enemy.emit(pos+position,ins)
	enemies_index += 1
	return true



func _on_enemy_dead(obj):
	var enemys:Array[Node2D] = enemy_detector.get_overlapping_bodies()
	enemys.erase(obj)
	if enemys.is_empty(): level_clear.emit()


func open_door():
	$exit.queue_free()
	for i in range(-2,2):
		for j in range(-11,-8):
			set_cell(Vector2i(i,j),0,Vector2i(6,4))
	for i in range(-11,-8):
		set_cell(Vector2i(-3,i),0,Vector2i(3,4))
	for i in range(-11,-8):
		set_cell(Vector2i(2,i),0,Vector2i(10,4))

func close_door():
	$entry/CollisionShape2D.disabled = false
	for i in range(-4,4):
		set_cell(Vector2i(i,10),0,Vector2i(4,5))
