class_name Global
extends Node

#player.gd
static var default_speed = 400
static var default_taking_damage = false
static var default_movement_angle = 0.0

#gun.gd
static var default_time_left = 0.2
static var default_times_shot = 0

static var distance: float = 0
static var gun: String = "throw"
static var playerHealthMax: int = 50
static var playerHealth: int = playerHealthMax
static var damageAmount: int = 2

static func reset_game(current_node: Node) -> void:
	default_speed = 400
	default_taking_damage = false
	default_movement_angle = 0.0

	#gun.gd
	default_time_left = 0.2
	default_times_shot = 0

	distance  = 0
	gun = "throw"
	playerHealthMax = 50
	playerHealth  = playerHealthMax
	damageAmount = 2
	
	if current_node and current_node.is_inside_tree():
		current_node.get_tree().reload_current_scene()
