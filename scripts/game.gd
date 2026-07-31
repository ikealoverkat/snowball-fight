extends Node2D

@onready var timer = $Timer
@onready var gunTimer = $Timer2

@export var time_left: float = randf_range(5.0, 6.5)
@export var min_time_left: float = 2.0
@export var spawn_acceleration: float = 0.2

@export var gun_time_left: float = 15.0
@export var opp = load("res://scenes/evil.tscn")
@export var gun = load("res://scenes/dropped-gun.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = time_left
	timer.start() # Ensure timer starts right away
	spawnOpp()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if timer.is_stopped():
		spawnOpp()
		
		timer.wait_time = max(min_time_left, timer.wait_time - spawn_acceleration)
		timer.start()

func spawnOpp() -> void:
	var opp_instance = opp.instantiate()
	get_tree().current_scene.add_child(opp_instance)
	
	var camera = get_viewport().get_camera_2d()
	if not camera:
		return
		
	var camera_position = camera.global_position
	
	var random_position = Vector2(
		randf_range(camera_position.x - 400, camera_position.x + 400),
		randf_range(camera_position.y - 250, camera_position.y + 250)
	)

	opp_instance.global_position = random_position
