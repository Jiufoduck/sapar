extends Node2D

const Gold_scene:PackedScene = preload("res://base_element/gold.tscn")
const attract_effect:PackedScene = preload("res://weapon&skill/attract_effect.tscn")

var mouse_in_window = false

@onready var filter = $UIs/filter
@onready var MonoManager = %MonologueManager
@onready var DiaManager = %DialogueManager
@onready var CombatUI = %CombatUI
@onready var Menu = %Menu
@onready var WeaponSkill = $"Weapon&Skill"
@onready var Enemy_base = $enemys
@onready var gold = $golds
@onready var bullet = $bullet
@export var player:CharacterBody2D
@export var sapar:Sapar



func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

var inc = 0.0
func _physics_process(delta: float) -> void:
	inc+=delta
	if inc > 360:
		inc = 0

	$mouse/round.scale = Vector2.ONE * (abs(sin(inc))/8 + 0.4)
	$mouse/round.rotation = inc

	$mouse.position = get_global_mouse_position()

	if Menu.is_on or !mouse_in_window:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

	sapar.position = sapar.position.move_toward(player.position,(player.position - sapar.position).length()/5)
	PlayerData.player_pos = $Player.position

	#Sapar
	for i in Enemy_base.get_children():
		if i.current_state == EnemyBase.State.Idle or i.current_state == EnemyBase.State.Grabled:
			var result = sapar.sapar_check(i)

			if !result.is_empty():
				i.take_damage(result.size(), result[result.keys()[0]]["type"])

func game_over():
	pass

func collect_gold():
	for i in $golds.get_children():
		i.clear()

func _on_spawn_enemy(pos:Vector2,obj:EnemyBase):
	obj.position = pos
	obj.spawn_gold.connect(_spawn_gold)
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

func attract_object(centre,strength):
	var ins = attract_effect.instantiate()
	ins.position = centre
	add_child(ins)
	for i in Enemy_base.get_children():
		i.vel +=  (centre - i.position).normalized() * strength
	for i in bullet.get_children():
		i.vel +=  (centre - i.position).normalized() * strength
	for i in gold.get_children():
		i.vel +=  (centre - i.position).normalized() * strength

func _on_shield_take_damage(damage:int):
	if PlayerData.sheild_value >= PlayerData.max_sheild_value:
		$ShieldRecoverTimer.start()
	PlayerData.sheild_value -= damage
	CombatUI._on_Shield_changed(PlayerData.sheild_value)



func _on_shield_recover_timer_timeout() -> void:
	PlayerData.sheild_value += 1
	CombatUI._on_Shield_changed(PlayerData.sheild_value)

	if PlayerData.sheild_value < PlayerData.max_sheild_value:
		$ShieldRecoverTimer.start()


func _on_player_take_gold() -> void:
	PlayerData.golds += 1
	CombatUI._on_gold_changed(PlayerData.golds)

func _on_attack_changed(val):
	%CombatUI._on_attack_change(val)
	PlayerData.player_strength = val

func shoot_grapple(grapple):
	grapple.position = PlayerData.player_pos
	WeaponSkill.add_child(grapple)


func _on_combat_ui_mouse_entered() -> void:
	mouse_in_window = true


func _on_combat_ui_mouse_exited() -> void:
	mouse_in_window = false


func _on_player_set_dash_line(dash: Variant) -> void:
	WeaponSkill.add_child(dash)


func _on_player_set_obstacle(obs: Variant) -> void:
	WeaponSkill.add_child(obs)


func _on_player_shoot_trumpet(trumpet: Variant) -> void:
	trumpet.position = PlayerData.player_pos
	trumpet.attract.connect(attract_object)
	WeaponSkill.add_child(trumpet)


func _on_player_paused() -> void:
	create_tween().tween_property(filter,"color",Color(0,0,0,0.3),0.2)


func _on_player_pause_overed() -> void:
	create_tween().tween_property(filter,"color",Color(0,0,0,0),0.2)
