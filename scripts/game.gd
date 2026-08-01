extends Node2D

@onready var timer = $Timer
@onready var gunTimer = $Timer2
@onready var burstTimer = $Timer3

@export var time_left: float = 2.5
@export var min_time_left: float = 1.0
@export var spawn_acceleration: float = 0.4

@export var gun_time_left: float = randf_range(10.0, 20.0)

@export var burst_time_left: float = 4.0
@export var min_burst_time_left: float = 1.0

@export var opp = load("res://scenes/evil.tscn")
@export var burst_opp = load("res://scenes/evil_burst.tscn")
@export var gun = load("res://scenes/dropped-gun.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnOpp()
	timer.wait_time = time_left
	timer.start()
	
	gunTimer.wait_time = gun_time_left
	gunTimer.start()

	burstTimer.wait_time = burst_time_left
	burstTimer.start()
	print("timers started")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Global.time_elapsed += delta
	
	if timer.is_stopped():
		spawnOpp()
		
		timer.wait_time = max(min_time_left, timer.wait_time - spawn_acceleration)
		timer.start()
	
	if gunTimer.is_stopped():
		spawnGun()
		gunTimer.wait_time = randf_range(10.0, 20.0)
		gunTimer.start()
		
	if burstTimer.is_stopped():
		spawnBurstOpp()
		timer.wait_time = max(min_burst_time_left, burstTimer.wait_time - spawn_acceleration)
		burstTimer.start()	

func spawnOpp() -> void:
	var opp_instance = opp.instantiate()
	
	var random_number = randi_range(0, 1)
	print(random_number)
	if random_number == 1:
		opp_instance.character = "yellow"
	elif random_number == 0:
		opp_instance.character = "grey"	
	
	var camera = get_viewport().get_camera_2d()
	if not camera:
		return
		
	var camera_position = camera.global_position
	
	var random_position = Vector2(
		randf_range(camera_position.x - 400, camera_position.x + 400),
		randf_range(camera_position.y - 250, camera_position.y + 250)
	)

	opp_instance.global_position = random_position
	
	get_tree().current_scene.add_child(opp_instance)	

func spawnBurstOpp() -> void:
	var burst_instance = burst_opp.instantiate()
	
	var random_number = randi_range(0, 1)
	if random_number == 1:
		burst_instance.character = "yellow"
	else:
		burst_instance.character = "grey"

	var camera = get_viewport().get_camera_2d()
	if not camera:
		return
		
	var camera_position = camera.global_position
	var random_position = Vector2(
		randf_range(camera_position.x - 400, camera_position.x + 400),
		randf_range(camera_position.y - 250, camera_position.y + 250)
	)

	burst_instance.global_position = random_position
	get_tree().current_scene.add_child(burst_instance)
	print("opp here")

func spawnGun() -> void:
	var gun_instance = gun.instantiate()
	get_tree().current_scene.add_child(gun_instance)
	
	var camera = get_viewport().get_camera_2d()
	if not camera:
		return	
	
	var camera_position = camera.global_position
	
	var random_position = Vector2(
		randf_range(camera_position.x - 400, camera_position.x + 400),
		randf_range(camera_position.y - 250, camera_position.y + 250)
	)
	
	var random_rotation = randi_range(-15, 15)
	
	gun_instance.global_position = random_position
	gun_instance.global_rotation_degrees = random_rotation
