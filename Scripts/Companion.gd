extends Sprite2D
class_name Companion

@export var follow_distance: float = 48.0
@export var initial_offset: Vector2 = Vector2(48, 0)
@export var follow_speed: float = 5.0
@export var player_double_jump_offset: Vector2 = Vector2(0, 28)
@export var double_jump_movement_time_seconds: float = 0.05
@export var summon_movement_time_seconds: float = 0.2

@onready var particles: PackedScene = preload("res://Prefabs/DoubleJumpParticles.tscn")
@onready var animation_tree := $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")


var player: Player
var original_color: Color
var double_jump_start_position: Vector2
var double_jump_target_position: Vector2
var double_jump_start_time: float

var double_jump_movement_complete_particles_played: bool = false

enum State {
	PLAYER_FOLLOW,
	DOUBLE_JUMP,
	SUMMONED
}

var state: State = State.PLAYER_FOLLOW

var summon_target: InteractableCompanion
var summon_start_position: Vector2
var summon_target_position: Vector2
var summon_start_time: float

func initialize(_player: Player):
	animation_tree.active = true
	player = _player
	global_position = _player.companion_center.global_position + initial_offset
	player.double_jump.connect(_on_player_double_jump)
	player.double_jump_restored.connect(_on_player_double_jump_restored)
	original_color = modulate

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match state:
		State.PLAYER_FOLLOW:
			var pivot = player.companion_center.global_position
			var target_pos = pivot + (global_position - pivot).normalized() * follow_distance
			if global_position.distance_to(target_pos) > 0.01:
				var direction = (target_pos - global_position).normalized()
				global_position = global_position.lerp(target_pos, follow_speed * delta)
				animation_state.travel("Float")
				animation_tree.set("parameters/Idle/blend_position", direction.x)
				animation_tree.set("parameters/Float/blend_position", direction.x)
				animation_tree.set("parameters/Squish/blend_position", direction.x)
			
				if global_position.distance_to(target_pos) < 1:
					animation_state.travel("Idle")
					
		State.DOUBLE_JUMP:
			animation_state.travel("Squish")
			var t = ((Time.get_ticks_msec() - double_jump_start_time) / 1000.0) / float(double_jump_movement_time_seconds)
			if t >= 1:
				global_position = double_jump_target_position
				if !double_jump_movement_complete_particles_played:
					particle_burst()
					double_jump_movement_complete_particles_played = true
			else:
				global_position = double_jump_start_position.lerp(double_jump_target_position, t)
		State.SUMMONED:
			animation_state.travel("Idle")
			var t = ((Time.get_ticks_msec() - summon_start_time) / 1000.0) / float(summon_movement_time_seconds)
			if t >= 1:
				global_position = summon_target_position
			else:
				global_position = summon_start_position.lerp(summon_target_position, t)

func _on_player_double_jump():
	double_jump_start_position = global_position
	var player_expected_distance_at_end = Vector2(player.velocity.x * double_jump_movement_time_seconds * 3, 0)
	double_jump_target_position = player.global_position + (player_double_jump_offset * -player.up_direction.y) + player_expected_distance_at_end
	double_jump_start_time = Time.get_ticks_msec()
	state = State.DOUBLE_JUMP
	double_jump_movement_complete_particles_played = false
	particle_burst()

func _on_player_double_jump_restored():
	if state == State.DOUBLE_JUMP:
		state = State.PLAYER_FOLLOW
	modulate.a = 1.0

func on_double_jump_animation_complete():
	if state == State.DOUBLE_JUMP:
		state = State.PLAYER_FOLLOW
	modulate.a = 0.5

func particle_burst():
	var instance = particles.instantiate()
	get_tree().root.add_child(instance)
	instance.global_position = global_position
	instance.emitting = true

func summon(node: InteractableCompanion):
	summon_target = node
	state = State.SUMMONED
	summon_start_time = Time.get_ticks_msec()
	summon_start_position = global_position
	summon_target_position = node.global_position

func release():
	state = State.PLAYER_FOLLOW
