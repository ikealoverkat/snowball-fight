extends Node2D

@onready var timer = $Timer
@export var time_left: float = 1.0
@export var opp = load("res://scenes/evil.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = time_left
	spawnOpp()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
 
func spawnOpp() -> void:
	var opp_instance = opp.instantiate()
	get_tree().current_scene.add_child(opp_instance)
	
	var camera = get_viewport().get_camera_2d()
	var camera_position = camera.global_position
	
	var random_position = Vector2(
		randf_range(camera_position.x - 400, camera_position.x + 400),
		randf_range(camera_position.y - 250, camera_position.y + 250)
	)
	

	opp_instance.global_position = random_position	
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if timer.is_stopped():
			spawnOpp()
			timer.start()
