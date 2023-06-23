extends CharacterBody2D
class_name Player

signal died

@export var SPEED: float = 300.0
@export var JUMP_VELOCITY: float = -400.0

@export var has_jump: bool = true
@export var has_double_jump: bool = false

@onready var coyote_timer := $CoyoteTimer
@onready var remote_transform := $RemoteTransform2D

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var jumped := false
var double_jumped := false

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		coyote_timer.start()
		jumped = false
		double_jumped = false

	# Handle Jump.
	
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
