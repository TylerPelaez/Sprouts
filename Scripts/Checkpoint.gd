extends Node2D
class_name Checkpoint

signal reached(object)

func _on_area_2d_body_entered(body):
	reached.emit(self)
	call_deferred("queue_free")
