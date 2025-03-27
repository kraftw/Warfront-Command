extends Node2D

@onready var sprite = $Sprite2D

func _process(_delta: float) -> void:
	if GameData.is_game_running:
		sprite.play()
	else:
		sprite.stop()
