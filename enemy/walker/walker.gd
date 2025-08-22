extends EnemyBase
class_name Walker

signal hurt

var damp = 2
var heal_strength = 1
@onready var HpBar = %HP

@export var recover_interval = 2.0




func _ready() -> void:
	super()

func golden():
	$sprite.modulate = Color.GOLD
	super()


func spawn():
	super()
	match level:
		0:
			$sprite.modulate = Color.WHITE
		1:
			$sprite.modulate = Color.GREEN
		2:
			$sprite.modulate = Color.RED

	$heal.wait_time = recover_interval
	await create_tween().set_trans(Tween.TRANS_SINE).tween_property(self,"scale",Vector2.ONE,0.5).finished


func _physics_process(delta: float) -> void:
	velocity /= damp
	move_and_slide()

var repulsion_strength = 100
func take_damage(count:int):
	$heal.start()
	if current_state == State.Idle:
		velocity = (position - PlayerData.player_pos).normalized() * repulsion_strength
		damp = 1.1
	super(count)



func _on_heal_timeout() -> void:
	var heal = heal_strength
	var healed_health = clamp(heal + health,0,MaxHealth)
	if healed_health - health:
		HpBar._on_Hp_changed(healed_health)
		$JumpCountConponent.jump(healed_health - health,false,true)
		health = healed_health
	else:
		$heal.stop()
