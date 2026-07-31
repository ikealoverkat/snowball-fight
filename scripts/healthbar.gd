extends ProgressBar
@onready var player = $"../../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.damaged.connect(_on_character_damage_taken)
	value = Global.playerHealth


func _on_character_damage_taken():
	value = Global.playerHealth

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
