extends CPUParticles2D

func _ready():
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_interval(0.7)
	tween.tween_callback(queue_free)
