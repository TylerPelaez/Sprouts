extends CanvasLayer
class_name UIController

signal dialog_complete

@onready var dialog_container = $DialogContainer
@onready var dialog_text = $DialogContainer/DialogTextRect/MarginContainer/DialogText
@onready var dialog_image = $DialogContainer/NinePatchRect/MarginContainer/TextureRect

var default_icon = preload("res://Art/Test/TestChickpea1.png")
var dialog_data = []
var dialog_index = 0

func set_dialog_data(data: Array):
	dialog_data = data
	dialog_index = 0
	dialog_container.visible = true
	show_dialog(dialog_data[dialog_index])

func show_dialog(data: Dictionary):
	dialog_text.text = data["text"]
	dialog_image.texture = load(data["icon"]) if data.has("icon") else default_icon

func _input(event):
	if event.is_action_pressed("Hit Switch") and dialog_container.visible:
		dialog_index += 1
		if dialog_index >= dialog_data.size():
			dialog_complete.emit()
			dialog_container.visible = false
		else:
			show_dialog(dialog_data[dialog_index])
