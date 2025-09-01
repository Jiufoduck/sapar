extends CharacterBody2D
class_name Player

signal take_damage(damage)
signal take_gold
signal shoot_grapple(grapple)
signal set_dash_line(dash)
signal set_obstacle(obs)
signal black_hole(pos,strength)
signal shoot_trumpet(trumpet)
signal paused
signal pause_overed

@onready var HitBox = $HitBox
@onready var CancelTip = $CancelTip
@onready var PauseTimer = $PauseTimer

const grapple = preload("res://weapon&skill/grapple.tscn")
const dash_line = preload("res://weapon&skill/dash_line.tscn")
const obstacle = preload("res://weapon&skill/obstacle.tscn")
const trumpet_bullet = preload("res://weapon&skill/trumpet_bullet.tscn")

var frame_ind = 0
var trans_sec = 0.2
var time = 0.0

@export_group("Player_skill")
@export var defalt_Player_spd = 40
@export var defalt_Max_speed = 100
@export_subgroup("dash_line")
@export var dash_maxspd = 600
@export var dash_spd = 200
@export var dash_time = 2
@export_subgroup("pause")
@export var pause_time = 2
@export_subgroup("obstacle")
@export var obstacle_time = 5
@export_group("Player_weapon")
@export_subgroup("grapple")
@export var grab_velocity = 400
@export var grab_max_vel = 1000
@export var grab_time = 5
@export var grab_player_velocity = 700
@export var grab_p_max_vel = 1000
@export var grab_dece_time = 0.7
@export_subgroup("trumpet")
@export var trumpet_speed = 1000
@export var trumpet_strength = 100
@export var trumpet_number = 3
@export var trumpet_interval_time = 0.2
@export_subgroup("black_hole")
@export var hole_strength = 100
@export var hole_number = 3
@export var hole_interval_time = 0.2

var grapple_instance:Grapple

var Player_speed = 40
var Max_speed = 100


func _physics_process(delta: float) -> void:
	if !Engine.time_scale:
		return

	if PlayerData.skill_cd_time > 0:
		PlayerData.skill_cd_time -= delta

	if PlayerData.weapon_cd_time > 0:
		PlayerData.weapon_cd_time -= delta

	if grapple_instance:
		$chain.set_point_position(0,Vector2.ZERO.move_toward(grapple_instance.position - position,40))
		$chain.set_point_position(1,grapple_instance.position - position)
		$chain.show()
		if grapple_instance.state == Grapple.Statetype.OnWall:
			var vel = velocity
			velocity += (grapple_instance.position - position).normalized() * clamp(grab_velocity,0,clamp(grab_max_vel - vel.length(),0,INF))
	else:
		$chain.set_point_position(0,Vector2.ZERO)
		$chain.set_point_position(1,Vector2.ZERO)
	var offset = Vector2.ZERO
	if Input.is_action_pressed("right"):
		offset+= Vector2.RIGHT
	if Input.is_action_pressed("left"):
		offset+= Vector2.LEFT
	if Input.is_action_pressed("up"):
		offset+= Vector2.UP
	if Input.is_action_pressed("down"):
		offset+= Vector2.DOWN
	velocity/=1.2
	var vel = velocity
	velocity += offset.normalized() * clamp(Player_speed,0,clamp(Max_speed - vel.length(),0,INF))
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
	if event.is_action_pressed("skill"):
		skill()
	if event.is_action_pressed("weapon"):
		weapon()


#skill
func skill():
	if !PlayerData.current_skill:
		return

	if PlayerData.skill_cd_time > 0.0:
		return
	PlayerData.skill_cd_time = PlayerData.current_skill.cd
	match PlayerData.current_skill.project_name:
		"dash_line":
			var ins = dash_line.instantiate()
			ins.initialze(get_local_mouse_position(),dash_spd,dash_maxspd,dash_time)
			set_dash_line.emit(ins)
		"pause":
			PauseTimer.start(pause_time)
			paused.emit()
			$AttractEffect.shoot()
			GameGlobal.time_scale = 0.0
		"obstacle":
			var ins = obstacle.instantiate()
			ins.initialize(get_global_mouse_position(),get_local_mouse_position().angle(),obstacle_time)
			set_obstacle.emit(ins)

		"":
			pass



func weapon():
	if !PlayerData.current_weapon:
		return

	if grapple_instance:
		_on_grapple_over()
		grapple_instance.cancel()

	if PlayerData.weapon_cd_time > 0.0:
		return
	PlayerData.weapon_cd_time = PlayerData.current_weapon.cd
	match PlayerData.current_weapon.project_name:
		"grapple":
			var ins = grapple.instantiate()
			ins.initialize(get_local_mouse_position().length()*5,grab_velocity * get_local_mouse_position().normalized(),grab_time)
			ins.on_over.connect(_on_grapple_over)
			ins.on_wall.connect(_on_grapple_on_wall)
			grapple_instance = ins
			shoot_grapple.emit(ins)
			CancelTip.show()

		"trumpet":
			for i in trumpet_number:
				var ins = trumpet_bullet.instantiate()
				ins.initialize(0,get_local_mouse_position().normalized()*trumpet_speed,trumpet_strength)
				shoot_trumpet.emit(ins)
				await get_tree().create_timer(trumpet_interval_time).timeout
		"blackhole":
			for i in hole_number:
				black_hole.emit(position, hole_strength)
				await get_tree().create_timer(hole_interval_time).timeout
		"":
			pass

func _on_grapple_on_wall():
	Max_speed = max(grab_p_max_vel,Max_speed)
	create_tween().set_trans(Tween.TRANS_SINE).tween_property(self,"Max_speed",defalt_Max_speed,grab_dece_time)
	Player_speed = max(Player_speed,grab_player_velocity)



func _on_grapple_over():
	if Max_speed == grab_p_max_vel:
		Max_speed = defalt_Max_speed
	if Player_speed ==grab_player_velocity:
		Player_speed = defalt_Player_spd
	$CancelTip.hide()
	$chain.hide()

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

func enter_dashline():
	Max_speed = max(dash_maxspd + 400,Max_speed)



func exit_dashline():
	if Max_speed == dash_maxspd + 400:
		Max_speed = defalt_Max_speed


func _on_pause_timer_timeout() -> void:
	GameGlobal.time_scale = 1.0
	pause_overed.emit()
