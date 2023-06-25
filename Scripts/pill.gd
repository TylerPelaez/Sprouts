extends Node
class_name Collectible

signal collected

func _on_body_entered(body):
	collected.emit()
	queue_free()
