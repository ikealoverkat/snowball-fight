extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Animated.play("default")
	await $Animated.animation_finished
	get_tree().change_scene_to_file("res://scenes/game.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
