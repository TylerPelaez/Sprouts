extends CanvasLayer
class_name UIController

signal dialog_complete

@export var text_display_time_seconds := 1.0

@onready var dialog_container = $DialogContainer
@onready var dialog_text = $DialogContainer/DialogTextRect/MarginContainer/DialogText
@onready var dialog_image = $DialogContainer/NinePatchRect/MarginContainer/TextureRect
@onready var audio_player = $AudioStreamPlayer

var default_icon = preload("res://Art/UI/PortraitBashfulNoSprout.png")
var dialog_data = []
var dialog_index = 0
var current_tween
var tweening = false

func set_dialog_data(data: Array):
	dialog_data = data
	dialog_index = 0
	dialog_container.visible = true
	show_dialog(dialog_data[dialog_index])

func show_dialog(data: Dictionary):
	if current_tween != null:
		current_tween.kill()
	dialog_text.text = data["text"]
	dialog_image.texture = load(data["icon"]) if data.has("icon") else default_icon
	dialog_text.visible_ratio = 0
	
	current_tween = get_tree().create_tween().bind_node(self)
	current_tween.tween_property(dialog_text, "visible_ratio", 1, text_display_time_seconds)
	current_tween.tween_callback(func(): tweening = false)
	tweening = true
	
	audio_player.play_string(data["text"])

func _input(event):
	if event.is_action_pressed("Hit Switch") and dialog_container.visible:
		if tweening:
			dialog_text.visible_ratio = 1
			if current_tween != null:
				current_tween.kill()
			tweening = false
			audio_player.stop()
			return
		
		dialog_index += 1
		if dialog_index >= dialog_data.size():
			dialog_complete.emit()
			dialog_container.visible = false
		else:
			show_dialog(dialog_data[dialog_index])
