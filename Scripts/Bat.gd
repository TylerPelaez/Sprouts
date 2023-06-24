extends Node2D

var batPrefab =preload("res://Prefabs/SpikeEnemy.tscn")
var flySpeed = 40
@export var move_speed := 400.0
@export var num_bats := 1
var pathfollows = []
@export var spacing := 32

func _ready():
	for i in num_bats:
		var bat = batPrefab.instantiate()
		var path_follow = PathFollow2D.new()
		$Path2D.add_child(path_follow)
		path_follow.add_child(bat)
		pathfollows.append(path_follow)
		path_follow.progress = spacing * i
		bat.position = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#set_process(get_progress() + flySpeed * delta)
func _physics_process(delta: float) -> void:
	for path_follow in pathfollows:
		path_follow.progress += move_speed * delta
		
	
