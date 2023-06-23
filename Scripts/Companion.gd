extends Sprite2D
class_name Companion

@export var follow_distance: float = 48.0
@export var initial_offset: Vector2 = Vector2(48, 0)
@export var follow_speed: float = 5.0

var player: Player

func initialize(_player: Player):
	player = _player
	global_position = _player.global_position + initial_offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if global_position.distance_to(player.global_position) > follow_distance:
		global_position = global_position.lerp(player.global_position + (global_position - player.global_position).normalized() * follow_distance, follow_speed * delta)
