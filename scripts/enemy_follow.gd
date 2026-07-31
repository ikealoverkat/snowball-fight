extends AnimatedSprite2D

@export var snowball = load("res://scenes/snowball.tscn")
var player: Node2D = null

@export var time_left: float = randf_range(0.5, 4.0)
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	else:
		push_error("player not found in node group")	
	
	timer.wait_time = time_left
	timer.timeout.connect(shoot)
	timer.start()
	
	play("throw_idle")
	$AnimationPlayer.play("throw_idle")

func shoot() -> void:
	var snowball_instance = snowball.instantiate()
	get_tree().current_scene.add_child(snowball_instance)
	
	snowball_instance.position = position
	snowball_instance.direction = (player.position - global_position).normalized()		
	snowball_instance.global_position = global_position + (snowball_instance.direction * 50.0)
	snowball_instance.look_at(player.position)
	play("throw_active")
	$AnimationPlayer.play("throw_active")
	await animation_finished
	play("throw_idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

	
func _input(event: InputEvent) -> void:
	if timer.is_stopped():
		timer.start()
