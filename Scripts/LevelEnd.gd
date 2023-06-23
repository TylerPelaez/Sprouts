extends Node2D
class_name LevelEnd

signal level_ended

func _on_area_2d_area_entered(area):
	level_ended.emit()

func _on_area_2d_body_entered(body):
	level_ended.emit()
