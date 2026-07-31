extends CharacterBody2D


@export var speed = 400
@export var health = 50
@export var mouseposition: Vector2
@export var turn_speed: float = 5.0

const MAX_TURN_ANGLE = deg_to_rad(15.0)
var movement_angle: float = 0.0

func onready():
	$Player.flip_h = true

func get_input(delta: float):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
	var mouse_is_left = get_global_mouse_position().x < global_position.x
	var moving_left = input_direction.x < 0
	var moving_right = input_direction.x > 0
	
	if moving_left or (mouse_is_left and not moving_right):
		$Player.flip_h = true
	else:
		$Player.flip_h = false
		
	if input_direction != Vector2.ZERO:
		$PlayerAnim.play("move")
	else: $PlayerAnim.play("idle")

func turn(delta: float) -> void:
	mouseposition = get_global_mouse_position()
	var target_mouse_angle = global_position.angle_to_point(mouseposition)
	var angle_diff = angle_difference(movement_angle, target_mouse_angle)
	var clamped_diff = clamp(angle_diff, -MAX_TURN_ANGLE, MAX_TURN_ANGLE)
		
	var final_target_angle = movement_angle + clamped_diff
	global_rotation = lerp_angle(global_rotation, final_target_angle, turn_speed * delta)

func _physics_process(delta: float) -> void:
	get_input(delta)
	turn(delta)
	move_and_slide()

func take_damage(damage) -> void:
	health = health - damage
	print(health)
