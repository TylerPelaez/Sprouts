extends CharacterBody2D
class_name Player

signal died
signal double_jump
signal double_jump_restored

@export var SPEED: float = 300.0
@export var JUMP_VELOCITY: float = -400.0
@export var MAX_FALL_SPEED: float = 1800.0

@export var has_jump: bool = true
@export var has_double_jump: bool = false

@onready var sprite = $Sprite2D

@onready var coyote_timer := $CoyoteTimer
@onready var remote_transform := $RemoteTransform2D

@onready var animation_tree := $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

@onready var companion_center := $PlayerCompanionCenter

var jumped: bool = false
var double_jumped: bool = false : set = set_double_jumped
var was_on_ground: bool = true

func _ready():
	animation_tree.active = true
	set_floor_snap_length(32)

func _physics_process(delta):
	var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.y = sign(velocity.y) *  min(abs(velocity.y), MAX_FALL_SPEED)
		was_on_ground = false
		animation_state.travel("Idle")
	else:
		coyote_timer.start()
		jumped = false
		self.double_jumped = false
		was_on_ground = true
	
	var do_jump: bool = false
	if has_jump and Input.is_action_just_pressed("Jump"):
		if is_on_floor() or !coyote_timer.is_stopped():
			if !jumped:
				jumped = true
				do_jump = true
			elif !double_jumped and has_double_jump:
				# Handle someone hitting double jump reaaaly soon after first jump
				self.double_jumped = true
				do_jump = true
		elif !double_jumped and has_double_jump:
			self.double_jumped = true
			do_jump = true
	
	if do_jump:
		velocity.y = JUMP_VELOCITY * -up_direction.y

	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor():
			animation_state.travel("Run")
		
		post_grav_change_input_check()
		animation_tree.set("parameters/Run/blend_position", velocity.x)
		animation_tree.set("parameters/Idle/blend_position", velocity.x)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation_state.travel("Idle")
	
	move_and_slide()

func set_camera_follow(camera: Node2D):
	remote_transform.remote_path = remote_transform.get_path_to(camera)

func die():
	died.emit()

func _on_kill_area_check_area_entered(area):
	die()

func set_double_jumped(val):
	double_jumped = val
	if double_jumped:
		double_jump.emit()
	else:
		double_jump_restored.emit()

var invert_direction_next_animation_play = false
	

func on_gravity_switch(direction: Vector2):
	up_direction = -direction
	var new_rotation = 0 if up_direction.y < 0 else PI
	
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_interval(0.2)
	tween.tween_property(self, "rotation", new_rotation, 0.3)
	tween.tween_callback(func(): invert_direction_next_animation_play = true)

func post_grav_change_input_check():
	if invert_direction_next_animation_play:
		sprite.scale.x = -sprite.scale.x
		invert_direction_next_animation_play = false

