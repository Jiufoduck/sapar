extends HBoxContainer
class_name Message

enum OwnerType{
	Mir,
	Zina
}

@onready var name_text:Label = $text/name
@onready var main_text:Label = $text/text
@onready var texture:TextureRect = $Texture
var MirNetPic = preload("res://pic/和平使者.png")
var ZinaNetPic = preload("res://pic/朋克神迹.png")


func initialize(text = "",text_owner:OwnerType = OwnerType.Mir) -> void:
	main_text.text = text

	#animation
	var t:Tween = create_tween().set_parallel().set_trans(Tween.TRANS_SINE)
	$text.modulate = Color(0,0,0,0)
	$Texture.modulate = Color(0,0,0,0)
	t.tween_property(texture,"custom_minimum_size",Vector2(60,60),0.3)
	t.tween_property(texture,"modulate",Color.WHITE,0.3)
	t.tween_property($text,"custom_minimum_size",Vector2(320,main_text.get_minimum_size().y + 40),0.3)
	t.tween_property($text,"modulate",Color.WHITE,0.3)


	if text_owner == OwnerType.Mir:
		name_text.text = "和平使者"
		alignment = BoxContainer.ALIGNMENT_END
		name_text.horizontal_alignment = 2
		main_text.horizontal_alignment = 2
		texture.texture = MirNetPic
	else:
		name_text.text = "朋克神迹"
		alignment = BoxContainer.ALIGNMENT_BEGIN
		name_text.horizontal_alignment = 0
		main_text.horizontal_alignment = 0
		texture.texture = ZinaNetPic
		$text.move_to_front()
	await t.finished
