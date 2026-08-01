extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Music.seek(0.0)
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play("default")
	await $AnimatedSprite2D.animation_finished
	$Sound.play()
	$Node2D.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
