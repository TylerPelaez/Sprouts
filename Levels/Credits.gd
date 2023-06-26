extends CanvasLayer

@onready var main: Control = $Main
@onready var credits: Control = $Credits




func _on_defective_melon_pressed():
	OS.shell_open("https://defectivemelon.itch.io/")
func _on_loki_howell_studios_pressed():
	OS.shell_open("https://loki-howell-studios.itch.io/")
func _on_altagracia_pressed():
	OS.shell_open("https://itch.io/profile/altagracia")
func _on_back_pressed():
	get_tree().change_scene_to_file("res://Levels/Main_Menu.tscn")
