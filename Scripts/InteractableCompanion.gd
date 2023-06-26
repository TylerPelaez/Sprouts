extends Node2D
class_name InteractableCompanion

@export var kill_music: bool = false
@onready var sprite:= $Companion
@onready var particles := $CPUParticles2D

signal start_dialog(interactable: InteractableCompanion, dialog_file_path: String)
signal summon_companion(interactible: InteractableCompanion)
signal release_companion(interactible: InteractableCompanion)

@export_file var dialog_file_path
var player_is_in: bool = false

var companion_present = true

var complete = false

@onready var prompt: Label = $Label

func _on_area_2d_body_entered(body):
	player_is_in = true
	prompt.visible = true

func _on_area_2d_body_exited(body):
	player_is_in = false
	prompt.visible = false

func _input(event):
	if dialog_file_path == null:
		printerr("Null Dialog File!")
	if event.is_action_pressed("Hit Switch") and player_is_in and !complete:
		if kill_music:
			MusicController.kill_music()
		start_dialog.emit(self, dialog_file_path)

func set_companion_present(val: bool):
	companion_present = val
	sprite.visible = companion_present
	particles.emitting = !companion_present

func _on_summon_companion_area_body_entered(body):
	summon_companion.emit(self)
	particles.emitting = false
	

func _on_summon_companion_area_body_exited(body):
	release_companion.emit(self)
	particles.emitting = !companion_present
