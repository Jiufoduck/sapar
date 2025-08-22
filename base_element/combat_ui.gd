extends Control

@onready var HP = %HP
@onready var Shield = %Shield

func _ready() -> void:
	PlayerData.combat_init.connect(initialize)

func initialize():
	var t = create_tween()
	t.tween_property(HP,"value",PlayerData.HP,0.2)
	t.tween_property(self,"modulate",Color.WHITE,0.2)
	if PlayerData.sheild:
		Shield.show()
		t.tween_property(Shield,"value",PlayerData.sheild_value,0.2)


var hptween:Tween
func _on_Hp_changed(val:int):
	if hptween and hptween.is_running():
		hptween.stop()
	hptween = create_tween().set_trans(Tween.TRANS_SINE)
	hptween.tween_property(HP,"value",float(val),0.3)

var tween:Tween
func _on_Shield_changed(val:int):
	if tween and tween.is_running():
		tween.stop()
	tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(Shield,"value",float(val),0.3)

var gold_tween:Tween
func _on_gold_changed(val:int):
	if gold_tween and gold_tween.is_running():
		gold_tween.stop()
	%gold_aomout.modulate = Color.GOLD
	gold_tween = create_tween().set_trans(Tween.TRANS_SINE)
	gold_tween.tween_property(%gold_aomout,"modulate",Color.WHITE,0.3)
	%gold_aomout.text = str(val)

func _on_attack_change(val):
	%Attack_amount.text = str(val)
