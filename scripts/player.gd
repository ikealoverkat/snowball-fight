extends CharacterBody2D

signal damaged
signal died

@export var hurt_text = load("res://scenes/hurt-text.tscn")

@export var speed = Global.default_speed
@export var mouseposition: Vector2
@export var turn_speed: float = 5.0
var taking_damage = Global.default_taking_damage

const MAX_TURN_ANGLE = deg_to_rad(15.0)
var movement_angle: float = Global.default_movement_angle

func _ready() -> void:
	$Player.flip_h = true

func add_hurt_text(dmg):
	var hurt_text_instance = hurt_text.instantiate()
	add_child(hurt_text_instance)
	hurt_text_instance.text = dmg
	hurt_text_instance.global_position.y = global_position.y - randi_range(55, 70)
	hurt_text_instance.global_position.x = global_position.x + randi_range(12, 25)	

func get_input(_delta: float):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
	var mouse_is_left = get_global_mouse_position().x < global_position.x
	var moving_left = input_direction.x < 0
	var moving_right = input_direction.x > 0
	
	if moving_left or (mouse_is_left and not moving_right):
		$Player.flip_h = true
	else:
		$Player.flip_h = false
		
	if input_direction != Vector2.ZERO and not taking_damage:
		$PlayerAnim.play("move")
	elif input_direction == Vector2.ZERO and not taking_damage:
		$PlayerAnim.play("idle")

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
	Global.playerHealth = Global.playerHealth - damage
	taking_damage = true
	emit_signal("damaged")
	add_hurt_text(str(damage))	
	$PlayerAnim.play("hit")	
	$Player.play("hit")
	await $Player.animation_finished
	$Player.play("default")
	taking_damage = false
	
	if Global.playerHealth <= 0:
		Global.playerHealth = 0		
		Global.reset_game(self)
	
