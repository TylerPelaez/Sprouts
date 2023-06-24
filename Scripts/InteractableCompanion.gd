extends Sprite2D
class_name InteractableCompanion

signal start_dialog(interactable: InteractableCompanion, dialog_file_path: String)

@export_file var dialog_file_path
var player_is_in: bool = false

var complete = false

func _on_area_2d_body_entered(body):
	player_is_in = true

func _on_area_2d_body_exited(body):
	player_is_in = false

func _input(event):
	if dialog_file_path == null:
		printerr("Null Dialog File!")
	if event.is_action_pressed("Hit Switch") and player_is_in and !complete:
		start_dialog.emit(self, dialog_file_path)
