extends AnimatedSprite2D

@export var snowball = load("res://scenes/snowball_burst.tscn")
var player: Node2D = null
@onready var evil = get_parent().get_parent()
@onready var sound = $BurstSound

@export var time_left: float = randf_range(1, 5)
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shoot()
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
	var total_snowballs = 5
	sound.play()
	
	for i in range(total_snowballs):
		var angle = i * (TAU / total_snowballs) # TAU = pi*2
		
		var snowball_instance = snowball.instantiate()
		get_tree().current_scene.add_child(snowball_instance)
		
		snowball_instance.scale = Vector2(1.35, 1.35) 
		
		snowball_instance.global_position = global_position
		
		var dir = Vector2(cos(angle), sin(angle))
		
		snowball_instance.direction = dir
			
		snowball_instance.rotation = angle


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
