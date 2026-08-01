extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RichTextLabel.text = "time lived: " + str(roundi(Global.time_stored)) + " seconds"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_menu_pressed() -> void:
	$ButtonSound.play()
	get_tree().change_scene_to_file("res://scenes/UI/menu.tscn")


func _on_play_again_pressed() -> void:
	$ButtonSound.play()
	get_tree().change_scene_to_file("res://scenes/game.tscn")
