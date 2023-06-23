extends CharacterBody2D
class_name Player

signal died

@export var SPEED: float = 300.0
@export var JUMP_VELOCITY: float = -400.0
@export var MAX_FALL_SPEED: float = 1800.0

@export var has_jump: bool = true
@export var has_double_jump: bool = false

@onready var coyote_timer := $CoyoteTimer
@onready var remote_transform := $RemoteTransform2D

@onready var fall_timer: Timer = $FallTimer

@onready var safe_fall_cast: RayCast2D = $SafeFallCast

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var jumped: bool = false
var double_jumped: bool = false

var was_on_ground: bool = true

var fall_is_deadly: bool = false

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, MAX_FALL_SPEED)
		
		if was_on_ground:
			fall_timer.start()
		

		was_on_ground = false
	else:
		if fall_is_deadly and !safe_fall_cast.is_colliding():
			die()
			return
		coyote_timer.start()
		jumped = false
		double_jumped = false
		was_on_ground = true
		fall_is_deadly = false
		
	
	var do_jump: bool = false
	if has_jump and Input.is_action_just_pressed("Jump"):
		if is_on_floor() or !coyote_timer.is_stopped():
			if !jumped:
				jumped = true
				do_jump = true
			elif !double_jumped and has_double_jump:
				# Handle someone hitting double jump reaaaly soon after first jump
				double_jumped = true
				do_jump = true
		elif !double_jumped and has_double_jump:
			double_jumped = true
			do_jump = true
	
	if do_jump:
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func set_camera_follow(camera: Node2D):
	remote_transform.remote_path = remote_transform.get_path_to(camera)

func die():
	died.emit()

func _on_kill_area_check_area_entered(area):
	die()


func _on_fall_timer_timeout():
	fall_is_deadly = true
