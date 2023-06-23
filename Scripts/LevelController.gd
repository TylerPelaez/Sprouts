extends Node2D

@export var player_has_jump: bool = true
@export var player_has_double_jump: bool = false
@export var player_has_companion: bool = true
@export_file var next_level

@onready var player_prefab: PackedScene = preload("res://Prefabs/Player.tscn")
@onready var companion_prefab: PackedScene = preload("res://Prefabs/Companion.tscn")

@onready var camera: Camera2D = $Camera2D
@onready var player_spawn_pos: Marker2D = $PlayerSpawnPosition

var player: Player
var companion: Companion

# Called when the node enters the scene tree for the first time.
func _ready():
	player = player_prefab.instantiate()
	add_child(player)
	player.has_jump = player_has_jump
	player.has_double_jump = player_has_double_jump
	player.set_camera_follow(camera)
	player.global_position = player_spawn_pos.global_position
	player.died.connect(_on_player_death)
	
	if player_has_companion:
		companion = companion_prefab.instantiate()
		add_child(companion)
		companion.initialize(player)
		
	for child in get_children():
		if child is LevelEnd:
			child.level_ended.connect(_on_level_end)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_death():
	get_tree().reload_current_scene()

func _on_level_end():
	if next_level != null:
		get_tree().change_scene_to_file(next_level)
	else:
		get_tree().reload_current_scene()
