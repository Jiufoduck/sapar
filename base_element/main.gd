extends Node2D

const Gold_scene:PackedScene = preload("res://base_element/gold.tscn")

@onready var MonoManager = %MonologueManager
@onready var DiaManager = %DialogueManager
@onready var CombatUI = %CombatUI
@onready var Menu = %Menu
@export var player:CharacterBody2D
@export var sapar:Sapar
@export var Enemy_base:Node2D


func _ready() -> void:
	$enemys/Walker.spawn()

func _physics_process(delta: float) -> void:
	sapar.position = sapar.position.move_toward(player.position,(player.position - sapar.position).length()/5)
	PlayerData.player_pos = $Player.position

	#Sapar
	for i in Enemy_base.get_children():
		if i.current_state == EnemyBase.State.Idle or i.current_state == EnemyBase.State.Grabled:
			var damage_time = sapar.sapar_check(i)
			if damage_time:
				i.take_damage(damage_time)

func game_over():
	pass

func collect_gold():
	for i in $golds.get_children():
		i.clear()

func _on_spawn_enemy(pos:Vector2,obj:EnemyBase):
	obj.position = pos
	$enemys.add_child(obj)
	obj.spawn()


func _spawn_gold(pos):
	var amount = randi_range(2,6) + PlayerData.basis_gold_amount
	for i in amount:
		var ins = Gold_scene.instantiate()
		ins.position = pos
		$golds.add_child(ins)
		ins.position = pos
		ins.random_splash()







func _on_player_take_damage(damage:int) -> void:
	var true_damage = damage
	if PlayerData.sheild:
		if true_damage <= PlayerData.sheild_value:
			_on_shield_take_damage(damage)
			return
		else:
			true_damage -= PlayerData.sheild_value
			_on_shield_take_damage(PlayerData.sheild_value)
	if true_damage >= PlayerData.HP:
		game_over()
	else:
		PlayerData.HP -= true_damage
		CombatUI._on_Hp_changed(PlayerData.HP)




func _on_shield_take_damage(damage:int):
	if PlayerData.sheild_value >= 2:
		$ShieldRecoverTimer.start()
	PlayerData.sheild_value -= damage
	CombatUI._on_Shield_changed(PlayerData.sheild_value)



func _on_shield_recover_timer_timeout() -> void:
	PlayerData.sheild_value += 1
	CombatUI._on_Shield_changed(PlayerData.sheild_value)

	if PlayerData.sheild_value < 2:
		$ShieldRecoverTimer.start()


func _on_player_take_gold() -> void:
	PlayerData.golds += 1
	CombatUI._on_gold_changed(PlayerData.golds)

func _on_attack_changed(val):
	%CombatUI._on_attack_change(val)
	PlayerData.player_strength = val
