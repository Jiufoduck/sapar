extends Control

const message_scene:PackedScene = preload("res://dialogue/message.tscn")

@onready var his_panel = %HistoryPanel
@onready var his_button = %History
@onready var list = %list
@onready var timer = %dialogue_timer
@onready var his_scroll = %HistoryScroll


var chat_json:Array[String]
var current_json:String
var chat_data = {}
var current_message_index = 0

var reaching_summit = false

func _ready():
	pass


func _process(delta: float) -> void:
	if reaching_summit:
		his_scroll.scroll_vertical = his_scroll.get_v_scroll_bar().max_value


func add_json(json:String,is_instance:bool,is_force:bool):
	if chat_json.is_empty():
		show_history()
		chat_json.append(json)
		start_json()
	else:
		if is_instance:
			return
		if is_force:
			chat_json.pop_front()
			chat_json.insert(0, json)
			timer.stop()
			start_json()
			return
		chat_json.append(json)

func start_json():
	if chat_json.has(current_json):
		chat_json.erase(current_json)
	if chat_json.is_empty():
		hide_history()
		return
	current_json = chat_json.front()
	var file = FileAccess.open(current_json, FileAccess.READ)
	chat_data = JSON.parse_string(file.get_as_text())
	file.close()
	current_message_index = 0
	_send_next_message()


func _send_next_message():
	if current_message_index >= chat_data["messages"].size():
		ScriptManager._on_dialogue_finished()
		timer.stop()
		start_json()
		return

	var msg = chat_data["messages"][current_message_index]
	var sender_name = chat_data["participants"][msg["sender"]]

	# 这里替换为实际的微信消息发送接口
	add_history(msg["content"], sender_name)

	current_message_index += 1
	if current_message_index < chat_data["messages"].size():
		timer.start(chat_data["messages"][current_message_index]["delay"])



func add_history(text,text_owner:String):
	var ins = message_scene.instantiate()
	list.add_child(ins)

	if !his_panel.visible:
		message_ainmation()
	reaching_summit = true
	if text_owner == "Mir":
		await ins.initialize(text, Message.OwnerType.Mir)
	elif text_owner == "Zina":
		await ins.initialize(text, Message.OwnerType.Zina)

	reaching_summit = false
	create_tween().set_trans(Tween.TRANS_SINE).tween_property(his_scroll,"scroll_vertical",his_scroll.get_v_scroll_bar().max_value,0.3)

var t:Tween
func message_ainmation():
	if t and t.is_running():
		t.stop()

	t = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
	t.tween_property(%message_come,"scale",Vector2.ONE,0.2)
	t.tween_property(%message_come,"rotation",0.3,0.1)
	t.chain().tween_property(%message_come,"rotation",-0.3,0.1)
	t.chain().tween_property(%message_come,"rotation",0.3,0.1)
	t.chain().tween_property(%message_come,"rotation",-0.3,0.1)
	t.chain().tween_property(%message_come,"rotation",0.3,0.1)
	t.chain().tween_property(%message_come,"rotation",-0.3,0.1)
	t.tween_property(%message_come,"scale",Vector2.ZERO,0.2)

var tween:Tween
func show_history():
	if tween and tween.is_running():
		tween.stop()
	his_panel.show()
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_parallel()
	tween.tween_property(his_panel,"custom_minimum_size",Vector2(400,500),0.5)
	tween.tween_property(his_panel,"position",Vector2(1520.0,0),0.5)
	tween.tween_property(his_button,"position",Vector2(1376.0,24.0),0.5)
	await tween.finished



func hide_history():
	if tween and tween.is_running():
		tween.stop()
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_parallel()
	tween.tween_property(his_panel,"size",Vector2(0,500),0.5)
	tween.tween_property(his_panel,"position",Vector2(1920,0),0.5)
	tween.tween_property(his_button,"position",Vector2(1832.0,24.0),0.5)
	await tween.finished
	his_panel.hide()

func _on_history_pressed() -> void:
	if his_panel.visible:
		hide_history()
	else:
		show_history()


func _on_dialogue_timer_timeout() -> void:
	_send_next_message()
