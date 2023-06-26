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
var ui_controller: UIController

var checkpoints_index = 0

var interactible_companions := []

var gravity_direction: Vector2 = Vector2(0, 1)
func _ready():
	checkpoints_index = 0
	ProjectSettings.set_setting("physics/2d/default_gravity", 1200)
	player = player_prefab.instantiate()
	add_child(player)
	player.has_jump = player_has_jump
	player.has_double_jump = player_has_companion
	player.set_camera_follow(camera)
	player.global_position = CollectibleTracker.last_checkpoint_position if CollectibleTracker.last_checkpoint_position != null else player_spawn_pos.global_position
	player.died.connect(_on_player_death)
	
	for child in get_children():
		_initialize_child_signals(child)
	
	if player_has_companion:
		spawn_companion()

func spawn_companion():
	player_has_companion = true
	player.has_double_jump = true
	companion = companion_prefab.instantiate()
	add_child(companion)
	companion.initialize(player)
	for interactible in interactible_companions:
		if interactible != null:
			interactible.set_companion_present(false)

func _initialize_child_signals(child: Node):
	if child is LevelEnd:
		child.level_ended.connect(_on_level_end)
	elif child is Switch:
		child.switch_hit.connect(_on_switch_hit)
	elif child is InteractableCompanion:
		child.start_dialog.connect(_on_dialog_started)
		interactible_companions.append(child)
		child.summon_companion.connect(on_companion_summon)
		child.release_companion.connect(on_companion_release)
	elif child is UIController:
		ui_controller = child
		ui_controller.dialog_complete.connect(on_dialog_complete)
	elif child is Collectible:
		child.collected.connect(_on_collect)
	elif child is Checkpoint:
		child.reached.connect(_on_checkpoint.bind(checkpoints_index))
		if CollectibleTracker.last_checkpoint_index == checkpoints_index:
			child.queue_free()
			checkpoints_index += 1
			return
		checkpoints_index += 1
	
	if child.get_child_count() > 0:
		for grandchild in child.get_children():
			_initialize_child_signals(grandchild)

func _on_collect():
	CollectibleTracker.collect_one()
	MusicController.play_collect_sound()

func _on_player_death():
	MusicController.play_death_sound()
	CollectibleTracker.on_scene_restarted()
	get_tree().reload_current_scene()

func _on_level_end():
	if next_level != null:
		CollectibleTracker.save_collected()
		FadeToBlack.fade_out_complete.connect(func(): get_tree().change_scene_to_file(next_level))
		FadeToBlack.do_fade_out_in()
	else:
		CollectibleTracker.on_scene_restarted()
		get_tree().reload_current_scene()

func _on_switch_hit(effect: Switch.SwitchEffect):
	match effect:
		Switch.SwitchEffect.INVERT_GRAVITY:
			var current_grav = ProjectSettings.get_setting("physics/2d/default_gravity")
			ProjectSettings.set_setting("physics/2d/default_gravity", -current_grav)
			gravity_direction = -gravity_direction
			player.on_gravity_switch(gravity_direction)
			MusicController.play_gravity_sound()

func _on_dialog_started(caller: InteractableCompanion, dialog_file_path: String):
	var file = FileAccess.open(dialog_file_path, FileAccess.READ)
	var text = file.get_as_text()
	var json_data = JSON.parse_string(text)
	if json_data == null:
		printerr("Invalid JSON!")
	get_tree().paused = true
	ui_controller.set_dialog_data(json_data)
	caller.complete = true
	caller.queue_free()
	
func on_dialog_complete():
	get_tree().paused = false
	if !player_has_companion:
		spawn_companion()
	else:
		companion.release()

func _on_checkpoint(checkpoint: Node2D, index: int):
	MusicController.play_checkpoint_sound()
	CollectibleTracker.set_last_checkpoint_position(checkpoint.global_position, index)

func on_companion_summon(node: InteractableCompanion):
	if companion != null:
		companion.summon(node)

func on_companion_release(node: InteractableCompanion):
	if companion != null:
		companion.release()
