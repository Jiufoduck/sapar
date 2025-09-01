extends Line2D
class_name SaparLine

var decay_eff = 1.1
var fragment = 100
var radius = 300


func _ready() -> void:
	for i in fragment:
		add_point(radius*Vector2.from_angle(deg_to_rad(360/float(fragment)*i)))

func _process(delta: float) -> void:
	update_points()

var new_points:PackedVector2Array
func update_points():
	new_points = PackedVector2Array(points)
	for i in new_points.size():
		new_points[i] = points[i].normalized()*(points[i-1].length() + points[(i+1)%fragment].length())/2
		new_points[i].move_toward(radius*points[i].normalized(),100)
	points = new_points




var push_strength = 20
func push(angle, type):
	var centre = int(angle/360*fragment)
	# 使用指数衰减代替固定值（参考材料1的波浪衰减原理）
	for offset in range(-5, 6):
		var idx = (centre + offset) % fragment
		var falloff = exp(-pow(offset, 2) / 8.0) # 高斯衰减曲线
		if type == "enter":
			points[idx] = points[idx].normalized() * (radius - push_strength * falloff)
		else:
			points[idx] = points[idx].normalized() * (radius + push_strength * falloff)
