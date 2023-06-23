extends Node2D

@export var player_has_jump: bool = true
@export var player_has_double_jump: bool = false

@onready var player_prefab: PackedScene = preload("res://Prefabs/Player.tscn")

@onready var camera: Camera2D = $Camera2D
@onready var player_spawn_pos: Marker2D = $PlayerSpawnPosition

var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = player_prefab.instantiate()
	add_child(player)
	player.has_jump = player_has_jump
	player.has_double_jump = player_has_double_jump
	player.set_camera_follow(camera)
	player.global_position = player_spawn_pos.global_position
	player.died.connect(_on_player_death)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_death():
	get_tree().reload_current_scene()
