extends Level

signal spawn_enemy(pos:Vector2,obj:EnemyBase)

var enemies_index = 0
@onready var enemy_detector = %enemy_detector
@onready var script_timer = %script_timer

@export var enemy_set:Array[Dictionary]
@export var enemy_level:int = 0


func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	ScriptManager._send_dialogue("res://dialogue/dialogue_jsons/start/start1.json",false,false)

	script_timer.start(11)#7
	await script_timer.timeout
	PlayerData.initialize_combat_ui()
	PlayerData.set_sapar([100])


	script_timer.start(6)#6
	await script_timer.timeout
	load_turn_enemy()
	script_timer.start(1)
	await script_timer.timeout

	ScriptManager._send_monologue("res://dialogue/monologue_resource/start/start1.tres",false,false)

	script_timer.start(20)
	await script_timer.timeout
	if script_timer.wait_time == 20:
		ScriptManager._send_dialogue("res://dialogue/dialogue_jsons/start/start_incase.json",true,false)


func load_turn_enemy() -> bool:
	if enemies_index >= enemy_set.size():
		return false

	var enemy:Dictionary = enemy_set[enemies_index]
	for pos in enemy:
		var ins:EnemyBase = load(EnemyBase.enemy_types[enemy[pos]]).instantiate()
		ins.level = enemy_level
		ins.connect("about_to_dead",_on_enemy_dead)
		spawn_enemy.emit(pos+position,ins)
	enemies_index += 1
	return true




func _on_enemy_dead(obj):
	var enemys:Array[Node2D] = enemy_detector.get_overlapping_bodies()
	enemys.erase(obj)
	if enemys.is_empty(): _level_clear()

func _level_clear():
	if enemies_index == 1:
		create_tween().tween_property($tip,"modulate",Color.TRANSPARENT,1.0)
		ScriptManager._send_dialogue("res://dialogue/dialogue_jsons/start/start2.json",false,true)
		script_timer.start(5)
		await script_timer.timeout
		PlayerData.set_sapar([70,110,130])
		script_timer.start(9)
		await script_timer.timeout
		load_turn_enemy()
	elif enemies_index == 2:
		level_clear.emit()
		ScriptManager._send_dialogue("res://dialogue/dialogue_jsons/start/start3.json",false,true)
		script_timer.start(2)
		await script_timer.timeout
		ScriptManager._send_monologue("res://dialogue/monologue_resource/start/start2.tres",false,false)

func open_door():
	$exit.queue_free()
	for i in range(-2,2):
		for j in range(-11,-8):
			set_cell(Vector2i(i,j),0,Vector2i(6,4))
	for i in range(-11,-8):
		set_cell(Vector2i(-3,i),0,Vector2i(3,4))
	for i in range(-11,-8):
		set_cell(Vector2i(2,i),0,Vector2i(10,4))
