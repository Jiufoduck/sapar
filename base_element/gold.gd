extends CharacterBody2D

var is_clear = false

var vel = Vector2.ZERO

var damp = 1.1

func _physics_process(delta: float) -> void:
	vel /= damp if GameGlobal.time_scale else 1
	if is_clear:
		var tvel = vel + (PlayerData.player_pos - position)
		vel = tvel.normalized() * clamp(tvel.length(), 0, 500)
	velocity = vel
	move_and_slide()

func random_splash():
	var strength = randf_range(50.0,300.0)
	var dir = Vector2(randf_range(-1,1),randf_range(-1,1)).normalized()

	vel += dir * strength

func clear():
	is_clear = true
