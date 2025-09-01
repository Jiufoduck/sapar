extends Line2D

@export var FRAGMENT = 60
var angle_arr:Array[Vector2]

var radius:float:
	set(val):
		radius = val
		clear_points()
		for i in angle_arr:
			add_point(val * i)

func _ready() -> void:
	for i in FRAGMENT:
		angle_arr.append(Vector2.from_angle(deg_to_rad(i*(360/FRAGMENT))))

var tween:Tween
func shoot():
	show()
	if tween and tween.is_running():
		tween.stop()
	tween = create_tween().set_trans(Tween.TRANS_SINE)
	radius = 0
	tween.tween_property(self,"radius",1000,0.2)
	tween.finished.connect(hide)
