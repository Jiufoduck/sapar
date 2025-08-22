extends CharacterBody2D

var is_clear = false

func _physics_process(delta: float) -> void:
	velocity /= 1.1
	if is_clear:
		var vel = velocity + (PlayerData.player_pos - position)
		velocity = vel.normalized() * clamp(vel.length(), 0, 500)
	move_and_slide()

func random_splash():
	var strength = randf_range(50.0,300.0)
	var dir = Vector2(randf_range(-1,1),randf_range(-1,1)).normalized()

	velocity += dir * strength

func clear():
	is_clear = true
