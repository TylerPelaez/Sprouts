extends Label

func _ready():
	var tween = get_tree().create_tween().bind_node(self)
	var final_color = Color.WHITE
	final_color.a = 0
	tween.tween_property(self, "modulate", final_color, 2)
	tween.tween_callback(queue_free)
