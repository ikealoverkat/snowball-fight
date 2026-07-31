extends CharacterBody2D

@export var health = randi_range(4, 10)
@export var hurt_text = load("res://scenes/hurt-text.tscn")


func onready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass
	
func take_damage(amount: int) -> void:
		health = health - amount
		
		if health <= 0:
			die()
			
		add_hurt_text(amount)
		$AnimationPlayer.play("hit")		
		$Evil.play("hit")
		await $Evil.animation_finished
		$Evil.play("default")
		

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
