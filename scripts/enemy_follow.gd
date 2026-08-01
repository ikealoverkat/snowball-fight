extends AnimatedSprite2D

@export var snowball = load("res://scenes/evil_snowball.tscn")
var player: Node2D = null
@onready var evil = get_parent().get_parent()

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
	
	play(evil.character + "_throw_idle")
	$AnimationPlayer.play("throw_idle")

func shoot() -> void:
	var snowball_instance = snowball.instantiate()
	get_tree().current_scene.add_child(snowball_instance)
	
	print(evil.character)
	snowball_instance.position = position
	snowball_instance.direction = (player.position - global_position).normalized()		
	snowball_instance.global_position = global_position + (snowball_instance.direction * 50.0)
	snowball_instance.look_at(player.position)
	play(evil.character + "_throw_active")
	$AnimationPlayer.play("throw_active")
	await animation_finished
	play(evil.character + "_throw_idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

	
func _input(_event: InputEvent) -> void:
	if timer.is_stopped():
		timer.start()
