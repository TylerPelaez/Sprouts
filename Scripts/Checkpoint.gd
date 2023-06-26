extends Node2D
class_name Checkpoint

signal reached(object)

@onready var reached_prefab = preload("res://Prefabs/CheckpointReached.tscn")
@onready var reached_marker = $Marker2D

func _on_area_2d_body_entered(body):
	reached.emit(self)
	var instance = reached_prefab.instantiate()
	get_tree().root.add_child(instance)
	instance.position = reached_marker.global_position
	call_deferred("queue_free")

