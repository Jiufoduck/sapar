extends CharacterBody2D
class_name EnemyBase

static var enemy_types:Array[String] = [
"res://enemy/walker/walker.tscn",
]

signal spawn_gold(pos)
signal about_to_dead(obj)
enum State{Spawning,Idle,Grabled,Dying}
var current_state:State = State.Spawning

var last_position = Vector2.ZERO

var example = {"MaxHealth":10,"Attack":1}

var level = 0
@export var attribute_configuration:Array[Dictionary]
#分为3级，每集不同配置表

@export var MaxHealth:int
@export var Attack:int

var health:int

var is_golden = false

func _ready() -> void:

	last_position = position


func spawn():
	var config = attribute_configuration[level]
	for attribute in config:
		set(attribute, config[attribute])


	health = MaxHealth
	$HP.initialize(MaxHealth)
	current_state = State.Idle


func golden():
	is_golden = true

func take_damage(count:int):
	$HP.show()
	for i in count:
		var damage = PlayerData.player_strength
		if !(randi()%10):
			damage*=2
			$JumpCountConponent.jump(str(damage),true)
		else:
			$JumpCountConponent.jump(str(damage))
		if damage >= health:
			dead()
		health -= damage
		$HP._on_Hp_changed(health)


func dead():
	about_to_dead.emit(self)
	current_state = State.Dying
	if is_golden:
		spawn_gold.emit(position)

	var t = create_tween().set_parallel()
	t.tween_property(self,"scale",Vector2.ZERO,0.3)
	t.tween_property(self,"modulate",Color.TRANSPARENT,0.3)
	await t.finished
	queue_free()


func count_damage():
	return Attack
