extends CharacterBody2D

signal take_damage(damage)
signal take_gold

@onready var HitBox = $HitBox

var frame_ind = 0
var trans_sec = 0.2
var time = 0.0

@export_group("Player_skill")
@export var defalt_Player_spd = 40
@export var defalt_Max_speed = 100
@export_subgroup("dash")
@export var dash_cd = 0.0
@export var dash_maxspd = 500
@export var dash_spd = 300
@export var dash_time = 0.3


var Player_speed = 40
var Max_speed = 100


func _physics_process(delta: float) -> void:
	#cds
	dash_cd -= delta

	var offset = Vector2.ZERO
	if Input.is_action_pressed("right"):
		offset+= Vector2.RIGHT
	if Input.is_action_pressed("left"):
		offset+= Vector2.LEFT
	if Input.is_action_pressed("up"):
		offset+= Vector2.UP
	if Input.is_action_pressed("down"):
		offset+= Vector2.DOWN
	var vel = (velocity/1.2+offset*Player_speed)

	velocity = vel.normalized() * clamp(vel.length(),0,Max_speed)
	move_and_slide()



	time += delta
	if time>trans_sec:
		time = 0.0
		frame_ind = (1+frame_ind)%4
	#dir

	if is_zero_approx(offset.length()):
		frame_ind = 0
	else:
		var angle = offset.angle()


		if is_equal_approx(angle,deg_to_rad(0)): $sprite.frame_coords.y = 3
		elif is_equal_approx(angle,deg_to_rad(90)): $sprite.frame_coords.y = 0
		elif is_equal_approx(angle,deg_to_rad(180)): $sprite.frame_coords.y = 2
		elif is_equal_approx(angle,deg_to_rad(-90)): $sprite.frame_coords.y = 1
		elif abs(angle)<=PI/2:$sprite.frame_coords.y = 3
		elif abs(PI-angle)<=PI/2:$sprite.frame_coords.y = 2
	#frame

	$sprite.frame_coords.x = frame_ind

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dash") and PlayerData.is_dash_able:
		dash()

#skill
func dash():
	if dash_cd > 0:
		return
	dash_cd = 2.0
	Max_speed = dash_maxspd
	Player_speed = dash_spd
	await get_tree().create_timer(dash_time).timeout
	Max_speed = defalt_Max_speed
	Player_speed = defalt_Player_spd

var push_strength = 1000
func _on_hit_box_body_entered(body: Node2D) -> void:
	if $HitCDTimer.time_left:
		return
	Max_speed = 500

	$hitanimation.play("hit_anim")
	velocity += (position - body.position).normalized() * push_strength
	take_damage.emit(body.count_damage())
	HitBox.set_deferred("monitoring",false)
	$HitCDTimer.start()

func _on_hit_cd_timer_timeout() -> void:
	Max_speed = defalt_Max_speed
	HitBox.set_deferred("monitoring",true)


func _on_gold_box_body_entered(body: Node2D) -> void:
	take_gold.emit()
	body.queue_free()
