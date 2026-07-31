extends Area2D

@export var speed = 600
var direction: Vector2
#var direction:= Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

#func shoot() -> void:
	#direction = (mousepos - global_position).normalized()
	#look_at(mousepos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	body.queue_free()
	queue_free()
