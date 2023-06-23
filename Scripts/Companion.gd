extends Sprite2D
class_name Companion

@export var follow_distance: float = 48.0
@export var initial_offset: Vector2 = Vector2(48, 0)
@export var follow_speed: float = 5.0
@export var player_double_jump_offset: Vector2 = Vector2(0, 32)
@export var double_jump_movement_time_seconds: float = 0.05

var player: Player
var original_color: Color
var double_jump_start_position: Vector2
var double_jump_target_position: Vector2
var double_jump_start_time: float

enum State {
	PLAYER_FOLLOW,
	DOUBLE_JUMP
}

var state: State = State.PLAYER_FOLLOW

func initialize(_player: Player):
	player = _player
	global_position = _player.global_position + initial_offset
	player.double_jump.connect(_on_player_double_jump)
	player.double_jump_restored.connect(_on_player_double_jump_restored)
	original_color = modulate

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match state:
		State.PLAYER_FOLLOW:
			if global_position.distance_to(player.global_position) > follow_distance:
				global_position = global_position.lerp(player.global_position + (global_position - player.global_position).normalized() * follow_distance, follow_speed * delta)
		State.DOUBLE_JUMP:
			var t = ((Time.get_ticks_msec() - double_jump_start_time) / 1000.0) / float(double_jump_movement_time_seconds)
			if t >= 1:
				global_position = double_jump_target_position
				modulate = original_color.blend(Color.GRAY)
				state = State.PLAYER_FOLLOW
			else:
				global_position = double_jump_start_position.lerp(double_jump_target_position, t)


func _on_player_double_jump():
	double_jump_start_position = global_position
	double_jump_target_position = player.global_position + player_double_jump_offset
	double_jump_start_time = Time.get_ticks_msec()
	state = State.DOUBLE_JUMP

func _on_player_double_jump_restored():
	state = State.PLAYER_FOLLOW
	modulate = original_color
