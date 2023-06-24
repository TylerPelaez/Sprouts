extends Node2D

@export var player_has_jump: bool = true
@export var player_has_companion: bool = true
@export_file var next_level

@onready var player_prefab: PackedScene = preload("res://Prefabs/Player.tscn")
@onready var companion_prefab: PackedScene = preload("res://Prefabs/Companion.tscn")

@onready var camera: Camera2D = $Camera2D
@onready var player_spawn_pos: Marker2D = $PlayerSpawnPosition

var player: Player
var companion: Companion

var gravity_direction: Vector2 = Vector2(0, 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	ProjectSettings.set_setting("physics/2d/default_gravity", 1200)
	player = player_prefab.instantiate()
	add_child(player)
	player.has_jump = player_has_jump
	player.has_double_jump = player_has_companion
	player.set_camera_follow(camera)
	player.global_position = player_spawn_pos.global_position
	player.died.connect(_on_player_death)
	
	if player_has_companion:
		spawn_companion()
		
	for child in get_children():
		_initialize_child_signals(child)

func spawn_companion():
	player.has_double_jump = true
	companion = companion_prefab.instantiate()
	add_child(companion)
	companion.initialize(player)

func _initialize_child_signals(child: Node):
	if child is LevelEnd:
		child.level_ended.connect(_on_level_end)
	elif child is Switch:
		child.switch_hit.connect(_on_switch_hit)
	elif child is InteractableCompanion:
		child.start_dialog.connect(_on_dialog_started)
	
	if child.get_child_count() > 0:
		for grandchild in child.get_children():
			_initialize_child_signals(grandchild)

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

func _on_switch_hit(effect: Switch.SwitchEffect):
	match effect:
		Switch.SwitchEffect.INVERT_GRAVITY:
			var current_grav = ProjectSettings.get_setting("physics/2d/default_gravity")
			ProjectSettings.set_setting("physics/2d/default_gravity", -current_grav)
			gravity_direction = -gravity_direction
			player.on_gravity_switch(gravity_direction)


func _on_dialog_started(dialog_file_path: String):
	var file = FileAccess.open(dialog_file_path, FileAccess.READ)
	var text = file.get_as_text()
	var json_data = JSON.parse_string(text)
	if json_data == null:
		printerr("Invalid JSON!")
	for entry in json_data:
		print_debug(entry["text"])
	
