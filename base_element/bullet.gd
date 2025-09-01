extends CharacterBody2D
class_name Bullets


@export var minimun_vel = 50
var main_velocity = Vector2.ZERO
var attack = 0
var last_velocity = Vector2.ZERO
var time = 10
var vel = Vector2.ZERO

func _ready() -> void:
	$Timer.start(time)

func initialize(attack,vel,color):
	self.attack = attack
	main_velocity = vel
	velocity = vel
	$Sprite2D.modulate = color


func _physics_process(delta: float) -> void:

	if vel.is_zero_approx():
		vel = main_velocity

	if !is_zero_approx(velocity.length()):
		if vel.is_equal_approx(last_velocity):
			vel = vel.normalized() * clamp(vel.length(),minimun_vel,INF)
	last_velocity = vel
	velocity = vel * GameGlobal.time_scale
	move_and_slide()

func _on_body_entered(body: Node) -> void:
	explode()

func explode():
	queue_free()

func count_damage():
	return attack


func _on_timer_timeout() -> void:
	explode()
