extends Area2D

@export var speed = 600
var direction: Vector2
#var direction:= Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	pass

func _on_body_entered(body) -> void:
	if body.is_in_group("opps"):
		if body.has_method("take_damage"):
			body.take_damage(Global.damageAmount)
			$OppDamage.play()
