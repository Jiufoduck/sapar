extends EnemyBase

var damp = 2

func _ready() -> void:
	current_state = State.Idle

func _physics_process(delta: float) -> void:
	velocity /= damp
	move_and_slide()


func take_damage(count:int):
	if current_state == State.Idle or current_state == State.OnAttack:
		velocity = (position - PlayerData.player_pos).normalized() * 300
		damp = 1.1
	super(count)
