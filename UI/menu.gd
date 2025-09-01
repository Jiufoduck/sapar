extends Control

const HoverRepoter:PackedScene = preload("res://UI/hover_reporter.tscn")

var is_on = false

var out_screen_point = Vector2(0,1080)

var main_tween:Tween

@onready var tabContainer = %TabContainer
#skillweapon
@onready var load_skill = %load_skill
@onready var load_weapon = %load_weapon
@onready var skills = %skills
@onready var weapons = %weapons
@onready var SkillWeaponExplain = %explination
#loots
@onready var owned_loots_root = %loots_root
@onready var loaded_loots_root = %loaded_loot
@onready var EquipExplination = %EquipmentExplination
#setting
@onready var master_volumn = %master_volumn


func _ready() -> void:
	for i in 20:
		var a = HoverRepoter.instantiate()
		owned_loots_root.add_child(a)
		a.hovered.connect(_on_owned_loot_hovered)
		a.select.connect(_on_owned_loot_selected)

	$ColorRect.color = Color.TRANSPARENT
	$ColorRect.position = out_screen_point
	%Panel.position = out_screen_point

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		if is_on:
			fade()
		else:
			appear()

func appear():
	GameGlobal.time_scale = 0.0
	Engine.time_scale = 0.0
	is_on = true
	if main_tween and main_tween.is_running():
		main_tween.stop()
	main_tween = create_tween().set_parallel().set_trans(Tween.TRANS_SINE)
	main_tween.set_ignore_time_scale()
	$ColorRect.position = Vector2.ZERO
	main_tween.tween_property($ColorRect,"color",Color(0,0,0,0.5),0.5)
	main_tween.tween_property(%Panel,"position",Vector2(200.0,100),0.5)


	load_SkillWeapon()

	load_equipment()

func load_SkillWeapon():
	for i in 3:
		skills.get_child(i).clear()
	for i in 3:
		weapons.get_child(i).clear()
	for i in PlayerData.owned_skill.size():
		skills.get_child(i).load_content(PlayerData.owned_skill[i])
	for i in PlayerData.owned_weapon.size():
		weapons.get_child(i).load_content(PlayerData.owned_weapon[i])

func fade():
	Engine.time_scale = 1.0

	if !PlayerData.is_pauseing:
		GameGlobal.time_scale = 1.0
	is_on = false
	if main_tween and main_tween.is_running():
		main_tween.stop()
	main_tween = create_tween().set_parallel().set_trans(Tween.TRANS_SINE)
	main_tween.set_ignore_time_scale()
	main_tween.tween_property($ColorRect,"color",Color(0,0,0,0),0.5)
	main_tween.tween_property(%Panel,"position",out_screen_point+ Vector2(200,100),0.5)
	await main_tween.finished
	$ColorRect.position = out_screen_point
	%Panel.position = out_screen_point

var t:Tween
func _on_tab_container_tab(tab: int) -> void:
	if t and t.is_running():
		t.stop()
	t = create_tween().set_ignore_time_scale()
	var control:Control = tabContainer.get_tab_control(tab)
	control.modulate = Color.TRANSPARENT
	t.tween_property(control,"modulate",Color(1,1,1,1), 0.2)

func _on_skill_hovered(emitter: Variant, content: Variant) -> void:
	if emitter.is_empty:
		SkillWeaponExplain.text = "这一栏没有技能"
	else:
		SkillWeaponExplain.text = content.tip

func _on_skill_select(emitter: Variant, content: Variant) -> void:
	if emitter.is_empty:
		return
	if PlayerData.current_skill:
		emitter.load_content(PlayerData.current_skill)
	else:
		emitter.clear()
	load_skill.load_content(content)
	PlayerData.load_skill(content)

func _on_weapon_hovered(emitter: Variant, content: Variant) -> void:
	if emitter.is_empty:
		SkillWeaponExplain.text = "这一栏没有武器"
	else:
		SkillWeaponExplain.text = content.tip

func _on_weapon_select(emitter: Variant, content: Variant) -> void:
	if emitter.is_empty:
		return
	if PlayerData.current_weapon:
		emitter.load_content(PlayerData.current_weapon)
	else:
		emitter.clear()
	load_weapon.load_content(content)
	PlayerData.load_weapon(content)

func _on_load_skill_hovered(emitter: Variant, content: Variant) -> void:
	if emitter.is_empty:
		SkillWeaponExplain.text = "您还没有装配技能"
	else:
		SkillWeaponExplain.text = content.tip

func _on_load_weapon_hovered(emitter: Variant, content: Variant) -> void:
	if emitter.is_empty:
		SkillWeaponExplain.text = "您还没有装配武器"
	else:
		SkillWeaponExplain.text = content.tip


func _on_master_volumn_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)


func load_equipment():
	for i in 3:
		loaded_loots_root.get_child(i).clear()
	for i in owned_loots_root.get_children():
		i.clear()

	for i in PlayerData.loaded_loots.size():
		loaded_loots_root.get_child(i).load_content(PlayerData.loaded_loots[i])
	for i in PlayerData.owned_loots.size():
		owned_loots_root.get_child(i).load_content(PlayerData.owned_loots[i])

func _on_equipment_hovered(emitter: Variant, content: Variant) -> void:
	if emitter.is_empty:
		EquipExplination.text = "您还没有装配装备"
	else:
		EquipExplination.text = content.tip

func _on_equipment_select(emitter: Variant, content: Variant) -> void:
	if emitter.is_empty:
		return
	var replacement = find_owned_loot_empty()
	if !replacement:
		EquipExplination.text = "装备槽位不足???，你个作弊者"
		ScriptManager._send_dialogue("res://dialogue/incase1.json",true,false)
		return
	emitter.clear()
	replacement.load_content(content)
	PlayerData.delete_loot(content)


func _on_owned_loot_hovered(emitter: Variant, content: Variant) -> void:
	if emitter.is_empty:
		EquipExplination.text = "这一栏还没有装备"
	else:
		EquipExplination.text = content.tip

func _on_owned_loot_selected(emitter: Variant, content: Variant) -> void:
	if emitter.is_empty:
		return
	var replacement = find_load_loot_empty()
	if !replacement:
		EquipExplination.text = "装备槽位不足，请卸载后再重试"
		return
	replacement.load_content(content)
	emitter.clear()
	PlayerData.load_loot(content)

func find_owned_loot_empty():
	for i in owned_loots_root.get_children():
		if i.is_empty:
			return i
	return null

func find_load_loot_empty():
	for i in loaded_loots_root.get_children():
		if i.is_empty:
			return i
	return null
