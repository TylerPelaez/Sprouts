extends Node2D
class_name MovingPlatform

@export var travel_time_seconds: float = 3.0
@export var wait_time: float = 2.0

@onready var body: StaticBody2D = $AnimatableBody2D
@onready var position_1: Marker2D = $Position1
@onready var position_2: Marker2D = $Position2


@onready var current_origin = position_2.global_position
@onready var current_target = position_1.global_position
var travel_time_start_msec: float


# Called when the node enters the scene tree for the first time.
func _ready():
	body.global_position = current_target
	change_target()

func change_target():
	if current_target == position_1.global_position:
		current_target = position_2.global_position
		current_origin = position_1.global_position
	else:
		current_target = position_1.global_position
		current_origin = position_2.global_position
	var tween = get_tree().create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(body, "global_position", current_target, travel_time_seconds)
	tween.tween_callback(func(): Util.call_delayed(change_target, wait_time))
