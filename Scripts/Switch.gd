extends Node2D
class_name Switch

signal switch_hit(effect: SwitchEffect)

@export var switch_effect: SwitchEffect = SwitchEffect.INVERT_GRAVITY


var player_is_inside: bool = false

enum SwitchEffect {
	INVERT_GRAVITY
}

func _input(event):
	if event.is_action_pressed("Hit Switch") and player_is_inside:
		switch_hit.emit(switch_effect)

func _on_area_2d_body_entered(body):
	player_is_inside = true


func _on_area_2d_body_exited(body):
	player_is_inside = false
