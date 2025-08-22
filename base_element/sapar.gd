extends Node2D
class_name Sapar

var line_scene:PackedScene = preload("res://base_element/sapar_line.tscn")
var lines:Array[SaparLine]

var on = false

func _ready() -> void:
	PlayerData.connect("sapar_changed",initialize_lines)

func initialize_lines():
	for i in lines:
		i.queue_free()
	on = true
	lines.clear()
	for i in PlayerData.sapar_radius:
		var ins = line_scene.instantiate()
		ins.radius = i-1
		lines.append(ins)
		$lines.add_child(ins)

	scale = Vector2.ZERO
	modulate = Color(0,0,0,0)
	var t = create_tween().set_trans(Tween.TRANS_SINE)
	t.tween_property(self,"scale",Vector2.ONE,0.3)
	t.tween_property(self,"modulate",Color.WHITE,0.3)



func sapar_check(obj:EnemyBase)-> int:
	#初始化
	if !on:
		return 0
	if obj.last_position == Vector2.ZERO:
		obj.last_position = obj.position - position

	var prev_pos:Vector2 = obj.last_position
	var current_pos:Vector2 = obj.position - position
	var result := {}
	var prev_dist := prev_pos.length()
	var current_dist := current_pos.length()

	obj.last_position = current_pos

	for i in range(PlayerData.sapar_radius.size()):
		var radius = PlayerData.sapar_radius[i]
		var intersections := []

		# 检查是否穿过这个圆（进入或离开）
		if (prev_dist < radius and current_dist >= radius) or \
			(prev_dist > radius and current_dist <= radius):

			# 计算第一个交点角度
			var t1 = (radius - prev_dist) / (current_dist - prev_dist)
			var point1 = prev_pos.lerp(current_pos, t1)
			var angle1 = rad_to_deg(point1.angle())
			if angle1 < 0:
				angle1 += 360
			intersections.append(angle1)

		# 如果有交点，添加到结果
		if intersections.size() == 1:
			result[i] = intersections[0]
	for key in result:
		lines[key].push(result[key])
	return result.size()
