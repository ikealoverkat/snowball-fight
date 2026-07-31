extends CharacterBody2D

@export var health = randi_range(7, 11)

func onready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass
	
func take_damage(amount: int) -> void:
		print(health)
		health = health - amount
		$AnimationPlayer.play("hit")
		print("opphealth ", health)
		
		if health <= 0:
			die()

func die() -> void:
	print("deaths")
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("die")
	await $AnimationPlayer.animation_finished
	queue_free()
