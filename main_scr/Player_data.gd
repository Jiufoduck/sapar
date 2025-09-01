extends Node

signal sapar_changed
signal combat_init
signal weapon_texture_changed(texture)
signal skill_texture_changed(texture)
signal attack_changed(val)

var player_pos = Vector2.ZERO
var MaxHP = 10
var HP = 10
var golds = 0


var sapar_radius = []
var sapar_level = 0

var target_enemy = []
var player_strength = 2:
	set(val):
		player_strength = val
		attack_changed.emit(val*double_rate)

func _ready() -> void:
	owned_loots.append_array(HighPriceLootList)
	owned_loots.append_array(MediumPriceLootList)

var SkillList:Array[SkillWeapon] = [
SkillWeapon.new("dash_line",3.0,"res://pic/UI/dash.png","加速带"),
SkillWeapon.new("pause",4.0,"res://pic/UI/pause.png","暂停"),
SkillWeapon.new("obstacle",7.0,"res://pic/UI/obstacle.png","障碍")
]
var WeaponList:Array[SkillWeapon] = [
SkillWeapon.new("grapple",2.0,"res://pic/UI/grapple.png","抓钩",10),
SkillWeapon.new("trumpet",4.0,"res://pic/UI/trumpet.png","喇叭",20),
SkillWeapon.new("blackhole",1.0,"res://pic/UI/blackhole.png","小黑洞",16)
]
var HighPriceLootList:Array[Equipment] = [
load("res://Items/lotpower_ring.gd").new(),
load("res://Items/shield.gd").new(),
]
var MediumPriceLootList:Array[Equipment] = [
load("res://Items/critical_ring.gd").new(),
load("res://Items/detect_system.gd").new(),
load("res://Items/harvester.gd").new(),
load("res://Items/lotamount_ring.gd").new(),
load("res://Items/power_ring.gd").new(),
]
var LowPriceLootList:Array[Equipment] = [
load("res://Items/amount_ring.gd").new(),
load("res://Items/attract_ring.gd").new(),
load("res://Items/celerity_ring.gd").new(),
load("res://Items/repel_ring.gd").new(),
]
#loots
var owned_loots:Array[Equipment] = LowPriceLootList
var loaded_loots:Array[Equipment]
var MaxLootNum = 3

var critical_ring = false

var double_rate:int = 1

var attract_ring = false
var repel_ring = false

var sheild:bool = false
var max_sheild_value = 4.0
var sheild_value = 4.0

var basis_gold_amount = 0#获取的金币基数

var weapon_cd_down = false

var bullet_detect_system = false

#skills
var owned_skill:Array[SkillWeapon] = SkillList

var skill_cd_time:float = 0.0
var current_skill_cd:float = 0.0

var current_skill:SkillWeapon

var is_pauseing = false

#weapon
var owned_weapon:Array[SkillWeapon] = WeaponList

var weapon_cd_time:float = 0.0
var current_weapon_cd:float = 0.0

var current_weapon:SkillWeapon

func set_sapar(arr: Array[int]):
	sapar_radius = arr
	sapar_changed.emit()


func initialize_combat_ui():
	combat_init.emit()

func load_weapon(weapon:SkillWeapon):
	if current_weapon:
		owned_weapon.append(current_weapon)
	for i in owned_weapon:
		if i.project_name == weapon.project_name:
			owned_weapon.erase(i)
	current_weapon_cd = weapon.cd
	if weapon_cd_down:
		current_weapon_cd -= 1.0
	weapon_texture_changed.emit(load(weapon.texture))
	current_weapon = weapon

func load_skill(skill:SkillWeapon):
	if current_skill:
		owned_skill.append(current_skill)
	for i in owned_skill:
		if i.project_name == skill.project_name:
			owned_skill.erase(i)
	current_skill_cd = skill.cd
	skill_texture_changed.emit(load(skill.texture))
	current_skill = skill

func load_loot(loot:Equipment):
	if loaded_loots.size() >= MaxLootNum:
		push_error("load exceed maximun loot value")
		return
	for i in owned_loots:
		if i.project_name == loot.project_name:
			owned_loots.erase(i)
	loaded_loots.append(loot)
	loot._on_load()

func delete_loot(loot:Equipment):
	for i in loaded_loots:
		if i.project_name == loot.project_name:
			loaded_loots.erase(i)
	owned_loots.append(loot)
	loot._on_delete()
