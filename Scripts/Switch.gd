extends Node2D
class_name Switch

signal switch_hit(effect: SwitchEffect)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var prompt: Label = $Label

@export var switch_effect: SwitchEffect = SwitchEffect.INVERT_GRAVITY
@export var prompt_above: bool = true

var player_is_inside: bool = false

enum SwitchEffect {
	INVERT_GRAVITY
}

func _input(event):
	if event.is_action_pressed("Hit Switch") and player_is_inside:
		switch_hit.emit(switch_effect)

func _on_area_2d_body_entered(body):
	player_is_inside = true
	if prompt_above:
		prompt.position = Vector2(-50, -109)
	else:
		prompt.position = Vector2(-50, 50)
	prompt.visible = true
	animation_player.play("Pulsate")

func _on_area_2d_body_exited(body):
	player_is_inside = false
	prompt.visible = false
	animation_player.play("RESET")
