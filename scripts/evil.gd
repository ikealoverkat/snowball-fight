extends CharacterBody2D

@export var health = randi_range(4, 10)

func onready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass
	
func take_damage(amount: int) -> void:
		health = health - amount
		$AnimationPlayer.play("hit")
		
		if health <= 0:
			die()

func die() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("die")
	await $AnimationPlayer.animation_finished
	queue_free()
