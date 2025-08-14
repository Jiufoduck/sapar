extends Node2D
class_name Sapar

var line_scene:PackedScene = preload("res://base_element/sapar_line.tscn")

var lines:Array[SaparLine]

func _ready() -> void:
	initialize_lines()

func initialize_lines():
	for i in PlayerData.sapar_radius:
		var ins = line_scene.instantiate()
		ins.radius = i-30
		lines.append(ins)
		$lines.add_child(ins)

"""
var pre
var cur
var atpre = true
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("point"):
		if atpre:
			pre = get_local_mouse_position()
			atpre = false
		else:
			cur = get_local_mouse_position()

			var dic:Dictionary = sapar_check(pre,cur)
			for key in dic:
				for i in dic[key]:
					lines[key].push(i)
			atpre = true
"""

func sapar_check(obj:EnemyBase)-> int:
	#初始化
	if obj.last_position == Vector2.ZERO:
		obj.last_position = obj.position - position

	var prev_pos:Vector2 = obj.last_position
	var current_pos:Vector2 = obj.position - position
	obj.last_position = current_pos
	var result := {}
	var prev_dist := prev_pos.length()
	var current_dist := current_pos.length()

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

			# 检查是否可能穿过两次（从外到内再到外）
			if (prev_dist > radius and current_dist > radius) and \
				(min(prev_dist, current_dist) < radius + (current_pos - prev_pos).length()):

				# 计算第二个交点角度
				var t2 = (radius - prev_dist) / -(current_dist - prev_dist)
				var point2 = prev_pos.lerp(current_pos, t2)
				var angle2 = rad_to_deg(point2.angle())
				if angle2 < 0:
					angle2 += 360
				intersections.append(angle2)

		# 如果有交点，添加到结果
		if intersections.size() > 0:
			if intersections.size() == 1:
				result[i] = intersections[0]
			else:
				# 对于多次穿过的情况，用数组存储所有角度
				result[i] = intersections

	for key in result:
		lines[key].push(result[key])
	return result.size()
