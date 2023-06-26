extends CanvasLayer

@onready var main: Control = $Main
@onready var credits: CanvasLayer = $"../CanvasLayer2"


func _on_button_play_pressed():
	get_tree().change_scene_to_file("res://Levels/AirLevel1.tscn")
	
func _on_button_credits_pressed():
	main.visible = false
	credits.visible = true
	
func _on_button_quit_pressed():
	get_tree().quit()



