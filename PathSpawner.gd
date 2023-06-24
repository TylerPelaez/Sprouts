extends Path2D

var timer = 0
var spawnTime = 5
var follower = preload("res://Prefabs/BatTest.tscn")
@export var move_speed := 400.0
var flySpeed = 40
var child_node = get_child(0)


func _physics_process(delta: float) -> void:
	$Path2D/PathFollow2D.progress += move_speed * delta
	timer = timer + delta
	if (timer > spawnTime):
		var newFollower = follower.get_instance_id()
		add_child(newFollower)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
