extends Item
class_name SkillWeapon


@export var cd:float

func _init(pname, cd, texture,tip,price = 0) -> void:
	project_name = pname
	self.cd = cd
	self.texture = texture
	self.tip = tip
	self.price = price
