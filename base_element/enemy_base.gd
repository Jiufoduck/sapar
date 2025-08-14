extends CharacterBody2D
class_name EnemyBase

enum State{Spawning,Idle,OnAttack,Dying}
var current_state:State = State.Spawning

var last_position = Vector2.ZERO

@export var MaxHealth:int
var health:int

func _ready() -> void:
	health = MaxHealth
	last_position = position


func spawn():
	pass


func take_damage(count:int):
	for i in count:
		var damage = PlayerData.player_strength
		if !(randi()%10):
			damage*=2
			$JumpCountConponent.jump(str(damage),true)
		else:
			$JumpCountConponent.jump(str(damage))
