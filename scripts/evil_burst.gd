extends CharacterBody2D

@export var health = randi_range(3, 7)
@export var hurt_text = load("res://scenes/hurt-text.tscn")
@export var character: String
@export var speed = 50

var player: Node2D = null
var wander_timer: float = 0.0
var random_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	$Evil.play(character + "_default")	
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func _physics_process(delta: float) -> void:
	if not is_instance_valid(player):
		velocity = Vector2.ZERO
		move_and_slide()
		return

	wander_timer -= delta
	if wander_timer <= 0:
		wander_timer = randf_range(1.0, 2.0)
		random_offset = Vector2(randf_range(-150, 150), randf_range(-150, 150))

	var target_pos = player.global_position + random_offset
	var direction = global_position.direction_to(target_pos)
	
	velocity = direction * speed
	move_and_slide()
	
	if velocity.x < 0:
		$Evil.flip_h = true
	elif velocity.x > 0:
		$Evil.flip_h = false
	
func take_damage(amount: int) -> void:
	health = health - amount
	
	if health <= 0:
		die()
		
	add_hurt_text(amount)
	$AnimationPlayer.play("hit")		
	$Evil.play(character + "_hit")
	await $Evil.animation_finished
	$Evil.play(character + "_default")
		
func die() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("die")
	await $AnimationPlayer.animation_finished
	queue_free()

func add_hurt_text(dmg):
	var hurt_text_instance = hurt_text.instantiate()
	add_child(hurt_text_instance)
	hurt_text_instance.scale = Vector2(0.15, 0.15)
	hurt_text_instance.add_theme_color_override("default_color", Color(0.117647, 0.235294, 0.556863))
	hurt_text_instance.text = str(dmg)
	hurt_text_instance.global_position.y = global_position.y - randi_range(55, 70)
	hurt_text_instance.global_position.x = global_position.x + randi_range(12, 25)
