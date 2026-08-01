extends AnimatedSprite2D

@export var snowball = load("res://scenes/snowball.tscn")

@onready var mouseposition = get_global_mouse_position()
@onready var angle = wrapf(rotation_degrees, 0.0, 360.0)

@export var time_left: float = 0.2
@onready var timer = $Timer

@export var times_shot: int = 0

const Signals = preload("res://scripts/signals.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = time_left
	_on_gun_change()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	turn()

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
	
	snowball_instance.position = position
	snowball_instance.direction = (get_global_mouse_position() - global_position).normalized()		
	snowball_instance.global_position = global_position + (snowball_instance.direction * 50.0)
	snowball_instance.look_at(get_global_mouse_position())
	play(Global.gun + "_active")
	$AnimationPlayer.play(Global.gun + "_active")
	await animation_finished
	play(Global.gun + "_idle")

func shoot_big_gun():
	Global.damageAmount = randi_range(5, 7)		
	var snowball_instance = snowball.instantiate()
	get_tree().current_scene.add_child(snowball_instance)
	
	snowball_instance.scale = Vector2(1.15, 1.15)
	snowball_instance.position = position
	snowball_instance.direction = (get_global_mouse_position() - global_position).normalized()		
	snowball_instance.global_position = global_position + (snowball_instance.direction * 50.0)
	snowball_instance.look_at(get_global_mouse_position())
	$AnimationPlayer.play(Global.gun + "_active")
	await animation_finished
	play(Global.gun + "_idle")
	
func _input(event: InputEvent) -> void:
	if Global.gun == "throw" and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and timer.is_stopped():
		shoot()
		timer.start()
	if Global.gun == "big_gun" and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and timer.is_stopped():
		shoot_big_gun()
		times_shot += 1
		if times_shot >= 50:
			Global.gun = "throw"
		
	if Global.gun == "machine_gun" and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if event.pressed:
			print("yo mouse down")
		else:
			print("yo released")
	
func pseudocode() -> void:
	if Global.gun == "throw":
		#onclick with the timer thing
		pass
	elif Global.gun == "machine-gun":
		#onmousehold do this
		#count amount of instances, if snowball_instance_count exceeds 50 go back to throw
		pass
	elif Global.gun == "big-gun":
		#onclick w the timer thing, longer timer
		#count amount of instancces
		pass
