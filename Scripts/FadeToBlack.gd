extends CanvasLayer

signal fade_out_complete
signal fade_in_complete
@onready var color_rect := $ColorRect


func do_fade_out_in(duration: float = 1.0):
	var tween = get_tree().create_tween().bind_node(self)
	var original_color = Color.WHITE
	original_color.a = 0
	var final_color = Color.WHITE
	tween.tween_property(color_rect, "modulate", final_color, duration / 2)
	tween.tween_callback(func(): fade_out_complete.emit())
	tween.tween_property(color_rect, "modulate", original_color, duration / 2)
	tween.tween_callback(func(): fade_in_complete.emit())
