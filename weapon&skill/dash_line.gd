extends Area2D

var bodys:Array
var velocity:Vector2
var speed:float
var max_speed:float
var time:float

var sec_point:Vector2:
	set(val):
		$Line2D.set_point_position(1,val)
		sec_point = val
var offset = 20

func _ready() -> void:
	$Timer.start(time)

func initialze(vector:Vector2, speed:float, max_speed:float, time:float):
	velocity = vector
	self.speed = speed
	self.max_speed = max_speed
	self.time = time
	position = PlayerData.player_pos
	$Line2D.set_point_position(0,vector.normalized() * offset)
	sec_point = vector.normalized() * offset
	var shape = RectangleShape2D.new()
	shape.size = Vector2(150,vector.length())
	$CollisionShape2D.rotation = vector.angle()-PI/2
	$CollisionShape2D.position = vector/2 + vector.normalized() * offset
	$CollisionShape2D.shape = shape
	$PlayerDetect/CollisionShape2D.shape = shape
	$PlayerDetect/CollisionShape2D.position = vector/2 + vector.normalized() * offset
	$PlayerDetect/CollisionShape2D.rotation = vector.angle()-PI/2

	create_tween().set_trans(Tween.TRANS_SINE).tween_property(self,"sec_point",vector+vector.normalized() * offset,0.5)
func _physics_process(delta: float) -> void:
	bodys = get_overlapping_bodies()
	for i:CharacterBody2D in bodys:
		if i is Player:
			var vel = i.velocity
			i.velocity += velocity.normalized() * clamp(speed,0,clamp(max_speed - vel.length(),0,INF))
		else:
			var vel = i.vel
			i.vel += velocity.normalized() * clamp(speed,0,clamp(max_speed - vel.length(),0,INF))


func _on_timer_timeout() -> void:
	over()

func over():
	$CollisionShape2D.disabled = true
	await create_tween().tween_property($Line2D,"width",0,0.3).finished
	queue_free()

func _on_player_detect_body_entered(body: Node2D) -> void:
	body.enter_dashline()


func _on_player_detect_body_exited(body: Node2D) -> void:
	body.exit_dashline()
