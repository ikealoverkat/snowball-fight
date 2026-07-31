extends CharacterBody2D


@export var speed = 400
@export var health = 50
@export var mouseposition: Vector2
@export var turn_speed: float = 5.0

const MAX_TURN_ANGLE = deg_to_rad(15.0)
var movement_angle: float = 0.0

func get_input(delta: float):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
		
	if input_direction.x < 0:
		$Player.flip_h = true
	else:
		$Player.flip_h = false

	if input_direction != Vector2.ZERO:
		mouseposition = get_global_mouse_position()
		var target_mouse_angle = global_position.angle_to_point(mouseposition)
		var angle_difference = angle_difference(movement_angle, target_mouse_angle)
		var clamped_difference = clamp(angle_difference, -MAX_TURN_ANGLE, MAX_TURN_ANGLE)
		
		var final_target_angle = movement_angle + clamped_difference
		global_rotation = lerp_angle(global_rotation, final_target_angle, turn_speed * delta)

func _physics_process(delta: float) -> void:
	get_input(delta)
	move_and_slide()
