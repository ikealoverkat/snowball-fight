extends Area2D

@export var droppedGun: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer2D.play()
	var randomNumber = randi_range(0, 1)
	if randomNumber == 1:
		$AnimatedSprite2D.play("big_gun")
		droppedGun = "big_gun"
	else:
		$AnimatedSprite2D.play("machine_gun")
		droppedGun = "machine_gun"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.gun = droppedGun

		var player_gun_node = get_tree().get_first_node_in_group("player_gun")
		
		if player_gun_node and player_gun_node.has_method("_on_gun_change"):
			player_gun_node._on_gun_change()
			
		queue_free()
