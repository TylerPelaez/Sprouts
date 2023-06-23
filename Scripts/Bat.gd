extends Node2D

var flySpeed = 40
@export var move_speed := 400.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#set_process(get_progress() + flySpeed * delta)
func _physics_process(delta: float) -> void:
	$Path2D/PathFollow2D.progress += move_speed * delta
	
