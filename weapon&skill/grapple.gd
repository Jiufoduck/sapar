extends CharacterBody2D
class_name Grapple

signal on_wall
signal on_over


const max_withdraw_speed = 800

enum Statetype{
	OutShoot,
	Withdraw,
	Catched,
	OnWall,
	Canceled
}
var state:Statetype = Statetype.OutShoot

var distance:float = 0
var max_distance:float

var catched_target:EnemyBase = null

var grab_time
var current_time = 0.0


func initialize(dis, vel, time):
	max_distance = dis
	velocity = vel
	grab_time = time

func _ready() -> void:
	$free_timer.start(grab_time)

func _physics_process(delta: float) -> void:
	current_time += delta
	if state == Statetype.Catched and !catched_target:
		state = Statetype.Canceled
	if state == Statetype.OutShoot:
		distance += velocity.length()/10
		if distance > max_distance:
			state = Statetype.Withdraw
	elif state == Statetype.Withdraw or state == Statetype.Catched:
		var vel = velocity + (PlayerData.player_pos - position)/5 + (PlayerData.player_pos - position).normalized()*10
		velocity = vel.normalized() * (clamp(vel.length(),0,max_withdraw_speed) + 10)
	elif state == Statetype.Canceled:
		velocity = (PlayerData.player_pos - position) + (PlayerData.player_pos - position).normalized()*400
	if state == Statetype.Catched and catched_target:
		catched_target.position = position + Vector2.from_angle(rotation + PI/2) *30


	elif state == Statetype.OnWall:
		velocity = Vector2.ZERO

	if !velocity.is_zero_approx():
		rotation = (position - PlayerData.player_pos).angle() - PI/2
	move_and_slide()

func cancel():
	divorce()
	state = Statetype.Canceled

func divorce():
	if state == Statetype.Catched and catched_target:
		catched_target.current_state = EnemyBase.State.Idle
		catched_target = null

func over():
	on_over.emit()
	divorce()
	queue_free()



func _on_player_detect_body_entered(body: Node2D) -> void:
	if state != Statetype.OutShoot and current_time > 0.2:
		over()

func _on_free_timer_timeout() -> void:
	over()


func _on_body_entered(body: EnemyBase) -> void:
	if state == Statetype.OutShoot or state == Statetype.Withdraw:
		state = Statetype.Catched
		catched_target = body
		body.current_state = EnemyBase.State.Grabled


func _on_obstacle_detect_body_entered(body: Node2D) -> void:
	if current_time < 0.1:
		await get_tree().create_timer(0.1).timeout
		if !$ObstacleDetect.has_overlapping_bodies():
			return
	if state == Statetype.OutShoot or state == Statetype.Withdraw:
		state = Statetype.OnWall
		on_wall.emit()
