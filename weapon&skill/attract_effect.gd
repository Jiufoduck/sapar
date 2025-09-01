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
	radius = 600
	create_tween().tween_property(self,"radius",0,0.2)
