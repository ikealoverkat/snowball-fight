extends AnimatedSprite2D

@export var snowball = load("res://scenes/snowball.tscn")

@onready var mouseposition = get_global_mouse_position()
@onready var angle = wrapf(rotation_degrees, 0.0, 360.0)

@export var time_left: float = Global.default_time_left
@onready var timer = $Timer

@export var times_shot: int = Global.default_times_shot
var is_mouse_held: bool = false

const Signals = preload("res://scripts/signals.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = time_left
	_on_gun_change()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	turn()
	
	if is_mouse_held and Global.gun == "machine_gun" and timer.is_stopped():
		shoot_machine_gun()
		timer.start()

func _on_gun_change():
	times_shot = 0
	print(Global.gun)
	if Global.gun == "throw":
		play(Global.gun + "_idle")
	else:
		play(Global.gun)
	$AnimationPlayer.play(Global.gun + "_idle")	

func turn() -> void:
	mouseposition = get_global_mouse_position()	
	
	var target_radians = global_position.angle_to_point(mouseposition)
	
	angle = wrapf(rad_to_deg(target_radians), 0.0, 360.0)
	
	if Global.gun != "throw":
		mouseposition = get_global_mouse_position()
		look_at(mouseposition)

		if angle  >= 90 && angle <= 270:
			flip_v = true		
		else: 
			flip_v = false

func shoot() -> void:
	Global.damageAmount = 2
	var snowball_instance = snowball.instantiate()
	get_tree().current_scene.add_child(snowball_instance)
	
	snowball_instance.speed = 600	
	snowball_instance.position = position
	snowball_instance.direction = (get_global_mouse_position() - global_position).normalized()		
	snowball_instance.global_position = global_position + (snowball_instance.direction * 50.0)
	snowball_instance.look_at(get_global_mouse_position())
	play(Global.gun + "_active")
	$AnimationPlayer.play(Global.gun + "_active")
	await animation_finished
	play(Global.gun + "_idle")

func shoot_big_gun():
	timer.wait_time = 0.4
	Global.damageAmount = randi_range(3, 7)		
	var snowball_instance = snowball.instantiate()
	get_tree().current_scene.add_child(snowball_instance)
	
	snowball_instance.speed = 400
	snowball_instance.scale = Vector2(1.15, 1.15)
	snowball_instance.position = position
	snowball_instance.direction = (get_global_mouse_position() - global_position).normalized()		
	snowball_instance.global_position = global_position + (snowball_instance.direction * 50.0)
	snowball_instance.look_at(get_global_mouse_position())
	$AnimationPlayer.play(Global.gun + "_active")
	await animation_finished
	play(Global.gun + "_idle")
	
func shoot_machine_gun():
	timer.wait_time = 0.05
	Global.damageAmount = randi_range(1, 2)		
	var snowball_instance = snowball.instantiate()
	get_tree().current_scene.add_child(snowball_instance)
	
	snowball_instance.scale = Vector2(0.65, 0.65)
	snowball_instance.speed = 850
	snowball_instance.position = position
	snowball_instance.direction = (get_global_mouse_position() - global_position).normalized()		
	snowball_instance.global_position = global_position + (snowball_instance.direction * 50.0)
	snowball_instance.look_at(get_global_mouse_position())
	
	times_shot += 1	
	
	if times_shot >= 35:
		Global.gun = "throw"
		is_mouse_held = false
		_on_gun_change()	
	
	$AnimationPlayer.play(Global.gun + "_active")
	await animation_finished
	play(Global.gun + "_idle")

	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_mouse_held = true

			if Global.gun == "throw" and timer.is_stopped():
				shoot()
				timer.start()
			elif Global.gun == "big_gun" and timer.is_stopped():
				shoot_big_gun()
				times_shot += 1
				if times_shot >= 15:
					Global.gun = "throw"
		else:
			is_mouse_held = false	
	
