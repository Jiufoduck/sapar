extends Node2D

@export var player:CharacterBody2D
@export var sapar:Sapar
@export var Enemy_base:Node2D

const Player_speed = 100
const Max_speed = 500



func _physics_process(delta: float) -> void:
	var offset = Vector2.ZERO
	if Input.is_action_pressed("right"):
		offset+= Vector2.RIGHT
	if Input.is_action_pressed("left"):
		offset+= Vector2.LEFT
	if Input.is_action_pressed("up"):
		offset+= Vector2.UP
	if Input.is_action_pressed("down"):
		offset+= Vector2.DOWN
	var vel = (player.velocity/1.2+offset*Player_speed)

	player.velocity = vel.normalized() * clamp(vel.length(),0,Max_speed)
	sapar.position = sapar.position.move_toward(player.position,10)
	player.move_and_slide()
	PlayerData.player_pos = $Player.position


	#Sapar
	for i in Enemy_base.get_children():
		if i.current_state == EnemyBase.State.Idle or i.current_state == EnemyBase.State.OnAttack:
			var damage_time = $sapar.sapar_check(i)
			i.take_damage(damage_time)
