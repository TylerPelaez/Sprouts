extends Control

@onready var main: Control = $Main
@onready var credits: Control = $Credits

func _on_button_play_pressed():
	get_tree().change_scene_to_file("res://Levels/AirLevel1.tscn")
func _on_button_quit_pressed():
	get_tree().quit()

func _on_defective_melon_pressed():
	pass # Replace with function body.
func _on_loki_howell_studios_pressed():
	pass # Replace with function body.
func _on_altagracia_pressed():
	pass # Replace with function body.
