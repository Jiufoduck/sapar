extends RigidBody2D

var time = 0.0

func _ready() -> void:
	$Timer.start(time)

func initialize(pos, dir,time):
	rotation = dir +PI/2
	position = pos
	$Sprite2D.scale = Vector2(0,0.5)
	create_tween().set_trans(Tween.TRANS_SINE).tween_property($Sprite2D,"scale",Vector2.ONE*0.5,0.3)
	self.time = time

func _on_timer_timeout() -> void:
	$CollisionShape2D.disabled = true
	await create_tween().set_trans(Tween.TRANS_SINE).tween_property($Sprite2D,"scale",Vector2(0,1)*0.5,0.3).finished
	queue_free()
